# =============================================================================
# SERVER LOGIC
# =============================================================================
# Server-side logic for the Biological Age Calculator
# =============================================================================

server <- function(input, output, session) {
  
  # =============================================================================
  # FILE UPLOAD HANDLING
  # =============================================================================
  
  # Reactive to store upload results
  upload_result <- reactiveVal(NULL)
  
  # Process uploaded file(s)
  observeEvent(input$lab_file, {
    req(input$lab_file)
    
    # Process multiple lab reports
    result <- process_multiple_lab_reports(input$lab_file)
    upload_result(result)
    
    if (result$success && !is.null(result$values)) {
      # Update input fields with extracted values
      values <- result$values
      
      if (!is.na(values$age)) {
        updateNumericInput(session, "age", value = round(values$age))
      }
      if (!is.na(values$sex)) {
        updateSelectInput(session, "sex", selected = values$sex)
      }
      if (!is.na(values$albumin)) {
        updateNumericInput(session, "albumin", value = round(values$albumin, 1))
      }
      if (!is.na(values$alp)) {
        updateNumericInput(session, "alp", value = round(values$alp))
      }
      if (!is.na(values$creatinine)) {
        updateNumericInput(session, "creatinine", value = round(values$creatinine, 2))
      }
      if (!is.na(values$hba1c)) {
        updateNumericInput(session, "hba1c", value = round(values$hba1c, 1))
      }
      if (!is.na(values$crp)) {
        updateNumericInput(session, "crp", value = round(values$crp, 1))
      }
      if (!is.na(values$wbc)) {
        updateNumericInput(session, "wbc", value = round(values$wbc, 1))
      }
      if (!is.na(values$mcv)) {
        updateNumericInput(session, "mcv", value = round(values$mcv, 1))
      }
      if (!is.na(values$rdw)) {
        updateNumericInput(session, "rdw", value = round(values$rdw, 1))
      }
      if (!is.na(values$lymph)) {
        updateNumericInput(session, "lymph", value = round(values$lymph, 1))
      }
    }
  })
  
  # Output: Upload status message
  output$upload_status <- renderUI({
    result <- upload_result()
    
    if (is.null(result)) {
      return(NULL)
    }
    
    if (result$success) {
      div(class = "upload-success",
          tags$span(class = "upload-icon", "✓"),
          tags$span(result$message)
      )
    } else {
      div(class = "upload-error",
          tags$span(class = "upload-icon", "⚠"),
          tags$span(result$message)
      )
    }
  })
  
  # =============================================================================
  # BIOLOGICAL AGE CALCULATION
  # =============================================================================
  
  # Reactive: Calculate biological age when button is pressed
  results <- eventReactive(input$calculate, {
    
    # CRP is entered in mg/L, convert to mg/dL for NHANES compatibility
    crp_mgdL <- input$crp / 10
    
    # Apply floor for CRP (NHANES detection limit)
    crp_mgdL <- max(crp_mgdL, 0.01)
    
    # Create user data
    user_data <- data.frame(
      sampleID = "user",
      age = input$age,
      gender = as.numeric(input$sex),
      albumin = input$albumin,
      alp = input$alp,
      creat = input$creatinine,
      hba1c = input$hba1c,
      crp = crp_mgdL,
      wbc = input$wbc,
      mcv = input$mcv,
      rdw = input$rdw,
      lymph = input$lymph
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
    
    # Calculate each biomarker's contribution using actual KDM formula
    agev <- kdm_trained$fit$lm_age
    s_ba2 <- kdm_trained$fit$s_ba2
    chrono_age <- input$age
    
    # Get user's biomarker values
    user_bm_values <- user_data_calc[1, biomarkers]
    
    # Calculate individual contributions exactly as in KDM formula
    # Each biomarker contributes: (value - q) * (k / s²)
    bm_contributions <- sapply(biomarkers, function(m) {
      row <- which(agev$bm == m)
      contrib <- (user_bm_values[[m]] - agev[row, 'q']) * (agev[row, 'k'] / (agev[row, 's']^2))
      return(contrib)
    })
    
    # Total denominator
    BAe_d <- sum(agev$n2, na.rm = TRUE)
    total_denom <- BAe_d + (1/s_ba2)
    
    # KDM formula: kdm = (BAe_n + age/s_ba2) / (BAe_d + 1/s_ba2)
    # Rearranging to show contribution of each biomarker to final KDM age:
    # Each biomarker's contribution to final age = contrib_i / total_denom
    bm_age_contrib <- bm_contributions / total_denom
    
    # The chronological age contribution
    chrono_contrib <- (chrono_age / s_ba2) / total_denom
    
    # Get comparison population (same sex and age range)
    comparison_pop <- NHANES3 %>%
      filter(
        gender == as.numeric(input$sex),
        age >= input$age - 3,
        age <= input$age + 3
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
        input$albumin,
        input$alp,
        input$creatinine,
        input$hba1c,
        crp_mgdL,
        input$wbc,
        input$mcv,
        input$rdw,
        input$lymph
      ),
      stringsAsFactors = FALSE
    )
    
    pop_stats$z_score <- (pop_stats$your_value - pop_stats$pop_mean) / pop_stats$pop_sd
    pop_stats$percentile <- pnorm(pop_stats$z_score) * 100
    
    # Map biomarker contributions to pop_stats order
    # pop_stats order: albumin, alp, creat, hba1c, crp, wbc, mcv, rdw, lymph
    # bm_age_contrib order: albumin, alp, lymph, mcv, lncreat, lncrp, hba1c, wbc, rdw
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
    
    list(
      kdm_age = user_kdm$data$kdm[1],
      kdm_advance = user_kdm$data$kdm_advance[1],
      chrono_age = input$age,
      pop_stats = pop_stats,
      comparison_n = nrow(comparison_pop),
      crp_mgdL = crp_mgdL
    )
  })
  
  # Output: Results UI
  output$resultsUI <- renderUI({
    
    if (is.null(input$calculate) || input$calculate == 0) {
      return(
        div(class = "apple-card", style = "text-align: center; padding: 60px 30px;",
            div(style = "font-size: 48px; margin-bottom: 16px;", "🧬"),
            h3(style = "font-size: 18px; font-weight: 600; color: #1d1d1f; margin-bottom: 8px;",
               "Enter Your Biomarkers"),
            p(style = "font-size: 14px; color: #86868b; max-width: 300px; margin: 0 auto;",
              "Fill in your blood test results and click Calculate.")
        )
      )
    }
    
    req(results())
    
    bio_age <- round(results()$kdm_age, 1)
    chrono_age <- results()$chrono_age
    diff <- round(results()$kdm_advance, 1)
    
    # Determine color based on difference
    diff_tile_class <- if (diff < -3) "result-tile-green" else if (diff > 3) "result-tile-red" else "result-tile-yellow"
    
    tagList(
      # Main Result Card - Three aligned tiles
      div(class = "apple-card", style = "text-align: center;",
          
          # Three tiles row
          div(class = "results-row",
              # Chronological Age
              div(class = "result-tile result-tile-neutral",
                  div(class = "tile-value tile-value-dark", chrono_age),
                  div(class = "tile-unit tile-unit-dark", "years"),
                  div(class = "tile-label tile-label-dark", "Chronological Age")
              ),
              # Biological Age (main - colored based on result)
              div(class = paste("result-tile", diff_tile_class),
                  div(class = "tile-value", bio_age),
                  div(class = "tile-unit", "years"),
                  div(class = "tile-label", "Biological Age")
              ),
              # Difference
              div(class = "result-tile result-tile-neutral",
                  div(class = "tile-value tile-value-dark", paste0(ifelse(diff > 0, "+", ""), diff)),
                  div(class = "tile-unit tile-unit-dark", "years"),
                  div(class = "tile-label tile-label-dark", "Difference")
              )
          ),
          
          # Interpretation message
          p(style = "font-size: 14px; color: #86868b; margin: 0;",
            if (diff < -3) {
              "✨ You're aging slower than average. Keep it up!"
            } else if (diff > 3) {
              "⚠️ Consider the recommendations below."
            } else {
              "👍 You're aging at a typical pace."
            }
          )
      ),
      
      # Two column layout for plot and table - CSS Grid
      div(class = "comparison-row",
        # Biomarker Comparison Plot
        div(class = "apple-card",
            h3(class = "apple-card-title", "Biomarker Comparison"),
            plotOutput("comparisonPlot", height = "400px")
        ),
        
        # Detailed Table
        div(class = "apple-card",
            h3(class = "apple-card-title", "Population Comparison"),
            p(class = "table-legend",
              "* Based on individuals of the same sex and age (±3 years) from NHANES III."),
            DTOutput("biomarkerTable")
        )
      ),
      
      # Recommendations - only show biomarkers adding years
      div(class = "apple-card",
          h3(class = "apple-card-title", "Focus Areas"),
          p(style = "font-size: 12px; color: #86868b; margin-top: -8px; margin-bottom: 12px;",
            "Biomarkers adding the most years to your biological age"),
          uiOutput("recommendations")
      )
    )
  })
  
  # Output: Comparison Plot
  output$comparisonPlot <- renderPlot({
    req(results())
    
    plot_data <- results()$pop_stats %>%
      mutate(
        biomarker_name = c("Albumin", "ALP", "Creat", "HbA1c", "CRP", "WBC", "MCV", "RDW", "Lymph"),
        # Color based on age contribution
        status = case_when(
          age_contrib > 0.5 ~ "Adding Years",
          age_contrib < -0.5 ~ "Reducing Years",
          TRUE ~ "Neutral"
        ),
        status = factor(status, levels = c("Reducing Years", "Neutral", "Adding Years"))
      )
    
    ggplot(plot_data, aes(x = reorder(biomarker_name, z_score), y = z_score, fill = status)) +
      geom_col(width = 0.6) +
      geom_hline(yintercept = 0, linewidth = 0.5, color = "#1d1d1f") +
      geom_hline(yintercept = c(-1, 1), linetype = "dashed", alpha = 0.3, color = "#86868b") +
      coord_flip() +
      scale_fill_manual(
        values = c("Reducing Years" = "#2D7A5F", "Neutral" = "#8C8C8C", "Adding Years" = "#C4622D"),
        drop = FALSE
      ) +
      scale_y_continuous(limits = c(-3, 3), breaks = seq(-3, 3, 1)) +
      labs(x = "", y = "Z-Score", fill = "") +
      theme_minimal(base_size = 12) +
      theme(
        text = element_text(family = "Inter"),
        plot.background = element_rect(fill = "#F8F7F4", color = NA),
        panel.background = element_rect(fill = "#F8F7F4", color = NA),
        panel.grid.major.y = element_blank(),
        panel.grid.minor = element_blank(),
        panel.grid.major.x = element_line(color = "#EBEBEB"),
        legend.position = "bottom",
        legend.text = element_text(size = 10, color = "#86868b"),
        axis.text = element_text(color = "#1d1d1f", size = 11),
        axis.title.x = element_text(color = "#86868b", size = 10, margin = margin(t = 8))
      )
  })
  
  # Output: Biomarker Table
  output$biomarkerTable <- renderDT({
    req(results())
    
    table_data <- results()$pop_stats %>%
      mutate(
        Marker = c("Albumin", "ALP", "Creat", "HbA1c", "CRP", "WBC", "MCV", "RDW", "Lymph"),
        You = sprintf("%.1f", your_value),
        `Pop. Avg` = sprintf("%.1f", pop_mean),
        `Age Contrib.` = paste0(ifelse(age_contrib >= 0, "+", ""), sprintf("%.1f", age_contrib), "y")
      ) %>%
      arrange(desc(z_score)) %>%
      select(Marker, You, `Pop. Avg`, `Age Contrib.`)
    
    datatable(
      table_data,
      options = list(
        pageLength = 10,
        dom = 't',
        ordering = FALSE,
        columnDefs = list(
          list(className = 'dt-right', targets = c(1, 2, 3))
        )
      ),
      rownames = FALSE,
      class = 'display compact'
    )
  })
  
  # Output: Recommendations
  output$recommendations <- renderUI({
    req(results())
    
    # Filter biomarkers marked as "Adding Years" (age_contrib > 0.5, shown in red/orange on plot)
    attention_needed <- results()$pop_stats %>%
      filter(age_contrib > 0.5) %>%
      arrange(desc(age_contrib))
    
    if (nrow(attention_needed) == 0) {
      return(
        div(style = "text-align: center; padding: 20px;",
            div(style = "font-size: 32px; margin-bottom: 8px;", "✨"),
            p(style = "font-size: 14px; color: #1d1d1f; margin: 0;", 
              "Great! No biomarkers are adding years to your biological age.")
        )
      )
    }
    
    # Show all biomarkers marked as "Adding Years"
    recommendations <- lapply(1:nrow(attention_needed), function(i) {
      bm <- as.character(attention_needed$biomarker[i])
      z <- attention_needed$z_score[i]
      contrib <- attention_needed$age_contrib[i]
      info <- biomarker_info[[bm]]
      
      if (is.null(info)) return(NULL)
      
      direction <- if (z > 0) "High" else "Low"
      # Always use badge-high (red/orange) since these are all "Adding Years" biomarkers
      
      div(class = "recommendation-card",
          div(class = "recommendation-title",
              info$name,
              span(class = "recommendation-badge badge-high", 
                   paste0("+", sprintf("%.1f", contrib), "y"))
          ),
          p(style = "font-size: 12px; color: #86868b; margin-bottom: 8px;",
            if (z > 0) info$higher_means else info$lower_means),
          tags$ul(class = "recommendation-list",
                  lapply(info$how_to_improve[1:4], function(tip) tags$li(tip))
          )
      )
    })
    
    div(class = "info-grid", style = "grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));",
        recommendations
    )
  })
}
