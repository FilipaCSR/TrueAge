# =============================================================================
# KDM CALCULATION FUNCTIONS
# =============================================================================
# Core biological age calculation logic
# =============================================================================

#' Calculate Biological Age using KDM method
#' 
#' @param user_inputs List containing user input values
#' @return List with KDM results and population statistics
calculate_biological_age <- function(user_inputs) {
  
  # CRP is entered in mg/L, convert to mg/dL for NHANES compatibility
  crp_mgdL <- user_inputs$crp / 10
  
  # Apply floor for CRP (NHANES detection limit)
  crp_mgdL <- max(crp_mgdL, 0.01)
  
  # Create user data frame
  user_data <- data.frame(
    sampleID = "user",
    age = user_inputs$age,
    gender = as.numeric(user_inputs$sex),
    albumin = user_inputs$albumin,
    alp = user_inputs$alp,
    creat = user_inputs$creatinine,
    hba1c = user_inputs$hba1c,
    crp = crp_mgdL,
    wbc = user_inputs$wbc,
    mcv = user_inputs$mcv,
    rdw = user_inputs$rdw,
    lymph = user_inputs$lymph
  )
  
  # Add log transforms (matching NHANES3 formulas)
  user_data <- user_data %>%
    mutate(
      lncreat = log(creat + 1),
      lncrp = log(crp + 1)
    )
  
  # Duplicate row for package requirement
  user_data_calc <- bind_rows(user_data, user_data)
  user_data_calc$sampleID <- c("user", "dummy")
  
  # Define biomarkers
  biomarkers <- c("albumin", "alp", "lymph", "mcv", "lncreat", "lncrp", "hba1c", "wbc", "rdw")
  
  # Train KDM on NHANES III
  kdm_trained <- kdm_calc(NHANES3, biomarkers = biomarkers)
  
  # Calculate KDM for user
  user_kdm <- kdm_calc(
    user_data_calc,
    biomarkers = biomarkers,
    fit = kdm_trained$fit,
    s_ba2 = kdm_trained$fit$s_ba2
  )
  
  # Calculate biomarker contributions
  bm_contributions <- calculate_biomarker_contributions(
    user_data_calc[1, ],
    kdm_trained,
    biomarkers
  )
  
  # Get population statistics
  pop_stats <- calculate_population_stats(
    user_inputs,
    crp_mgdL,
    bm_contributions
  )
  
  list(
    kdm_age = user_kdm$data$kdm[1],
    kdm_advance = user_kdm$data$kdm_advance[1],
    chrono_age = user_inputs$age,
    pop_stats = pop_stats,
    comparison_n = nrow(pop_stats),
    crp_mgdL = crp_mgdL
  )
}

#' Calculate each biomarker's contribution to biological age
#' 
#' @param user_values User biomarker values (single row data frame)
#' @param kdm_trained Trained KDM model
#' @param biomarkers Vector of biomarker names
#' @return Named vector of age contributions
calculate_biomarker_contributions <- function(user_values, kdm_trained, biomarkers) {
  
  agev <- kdm_trained$fit$lm_age
  s_ba2 <- kdm_trained$fit$s_ba2
  
  # Calculate individual contributions exactly as in KDM formula
  bm_contributions <- sapply(biomarkers, function(m) {
    row <- which(agev$bm == m)
    contrib <- (user_values[[m]] - agev[row, 'q']) * (agev[row, 'k'] / (agev[row, 's']^2))
    return(contrib)
  })
  
  # Total denominator
  BAe_d <- sum(agev$n2, na.rm = TRUE)
  total_denom <- BAe_d + (1/s_ba2)
  
  # Each biomarker's contribution to final age
  bm_age_contrib <- bm_contributions / total_denom
  
  return(bm_age_contrib)
}

#' Calculate population comparison statistics
#' 
#' @param user_inputs User input values
#' @param crp_mgdL CRP in mg/dL
#' @param bm_age_contrib Biomarker age contributions
#' @return Data frame with population statistics
calculate_population_stats <- function(user_inputs, crp_mgdL, bm_age_contrib) {
  
  # Get comparison population (same sex and age range)
  comparison_pop <- NHANES3 %>%
    filter(
      gender == as.numeric(user_inputs$sex),
      age >= user_inputs$age - 3,
      age <= user_inputs$age + 3
    )
  
  # Calculate population means and SDs
  pop_stats <- data.frame(
    biomarker = c("albumin", "alp", "creatinine", "hba1c", "crp", "wbc", "mcv", "rdw", "lymph"),
    pop_mean = c(
      mean(comparison_pop$albumin, na.rm = TRUE),
      mean(comparison_pop$alp, na.rm = TRUE),
      mean(comparison_pop$creat, na.rm = TRUE),
      mean(comparison_pop$hba1c, na.rm = TRUE),
      mean(comparison_pop$crp, na.rm = TRUE),
      mean(comparison_pop$wbc, na.rm = TRUE),
      mean(comparison_pop$mcv, na.rm = TRUE),
      mean(comparison_pop$rdw, na.rm = TRUE),
      mean(comparison_pop$lymph, na.rm = TRUE)
    ),
    pop_sd = c(
      sd(comparison_pop$albumin, na.rm = TRUE),
      sd(comparison_pop$alp, na.rm = TRUE),
      sd(comparison_pop$creat, na.rm = TRUE),
      sd(comparison_pop$hba1c, na.rm = TRUE),
      sd(comparison_pop$crp, na.rm = TRUE),
      sd(comparison_pop$wbc, na.rm = TRUE),
      sd(comparison_pop$mcv, na.rm = TRUE),
      sd(comparison_pop$rdw, na.rm = TRUE),
      sd(comparison_pop$lymph, na.rm = TRUE)
    ),
    your_value = c(
      user_inputs$albumin,
      user_inputs$alp,
      user_inputs$creatinine,
      user_inputs$hba1c,
      crp_mgdL,
      user_inputs$wbc,
      user_inputs$mcv,
      user_inputs$rdw,
      user_inputs$lymph
    ),
    stringsAsFactors = FALSE
  )
  
  pop_stats$z_score <- (pop_stats$your_value - pop_stats$pop_mean) / pop_stats$pop_sd
  pop_stats$percentile <- pnorm(pop_stats$z_score) * 100
  
  # Map biomarker contributions to pop_stats order
  pop_stats$age_contrib <- c(
    bm_age_contrib["albumin"],
    bm_age_contrib["alp"],
    bm_age_contrib["lncreat"],
    bm_age_contrib["hba1c"],
    bm_age_contrib["lncrp"],
    bm_age_contrib["wbc"],
    bm_age_contrib["mcv"],
    bm_age_contrib["rdw"],
    bm_age_contrib["lymph"]
  )
  
  return(pop_stats)
}
