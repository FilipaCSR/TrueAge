# =============================================================================
# LAB REPORT EXTRACTION MODULE
# =============================================================================
# Functions to extract biomarker values from uploaded lab reports (PDF/images)
# =============================================================================

# Biomarker patterns for extraction
# Each pattern includes variations of how the biomarker might appear in lab reports
BIOMARKER_PATTERNS <- list(
  albumin = list(
    names = c("albumin", "albumina", "alb"),
    unit_conversions = list(
      "g/dL" = 1,
      "g/L" = 0.1  # Convert g/L to g/dL
    ),
    typical_range = c(2.0, 6.0)
  ),
  alp = list(
    names = c("alkaline phosphatase", "alp", "fosfatase alcalina", "alk phos", "alkp"),
    unit_conversions = list(
      "U/L" = 1,
      "IU/L" = 1
    ),
    typical_range = c(20, 300)
  ),
  creatinine = list(
    names = c("creatinine", "creatinina", "creat", "crea"),
    unit_conversions = list(
      "mg/dL" = 1,
      "µmol/L" = 0.0113,  # Convert µmol/L to mg/dL
      "umol/L" = 0.0113
    ),
    typical_range = c(0.3, 3.0)
  ),
  hba1c = list(
    names = c("hba1c", "hemoglobin a1c", "a1c", "glycated hemoglobin", "hemoglobina glicada", "hgba1c"),
    unit_conversions = list(
      "%" = 1,
      "mmol/mol" = function(x) (x / 10.929) + 2.15  # IFCC to NGSP conversion
    ),
    typical_range = c(4.0, 14.0)
  ),
  crp = list(
    names = c("c-reactive protein", "crp", "proteína c reativa", "pcr", "hs-crp", "high sensitivity crp", "proteina c reactiva"),
    unit_conversions = list(
      "mg/L" = 1,
      "mg/dL" = 10  # Convert mg/dL to mg/L (we want mg/L for input)
    ),
    typical_range = c(0.1, 50)
  ),
  wbc = list(
    names = c("white blood cell", "wbc", "leucocytes", "leucócitos", "leukocytes", "white cell count", "leucocitos"),
    unit_conversions = list(
      "10³/µL" = 1,
      "x10^9/L" = 1,
      "10^9/L" = 1,
      "K/µL" = 1,
      "/µL" = 0.001  # Convert /µL to 10³/µL
    ),
    typical_range = c(2.0, 15.0)
  ),
  mcv = list(
    names = c("mean corpuscular volume", "mcv", "vcm", "volume corpuscular médio"),
    unit_conversions = list(
      "fL" = 1
    ),
    typical_range = c(60, 120)
  ),
  rdw = list(
    names = c("red cell distribution width", "rdw", "rdw-cv", "rdw cv", "amplitude de distribuição eritrocitária"),
    unit_conversions = list(
      "%" = 1
    ),
    typical_range = c(10, 20)
  ),
  lymph = list(
    names = c("lymphocyte", "lymph", "linfócitos", "linfocitos", "lymphocytes"),
    unit_conversions = list(
      "%" = 1
    ),
    typical_range = c(5, 60)
  ),
  # Age extraction
  age = list(
    names = c("age", "idade", "edad", "years old", "anos"),
    unit_conversions = list("years" = 1),
    typical_range = c(18, 100)
  ),
  # Sex extraction  
  sex = list(
    names = c("sex", "gender", "sexo", "género", "genero"),
    unit_conversions = list(),
    typical_range = NULL
  )
)

#' Extract text from uploaded file (PDF or image)
#' 
#' @param file_path Path to the uploaded file
#' @param file_type MIME type of the file
#' @return Character string with extracted text
extract_text_from_file <- function(file_path, file_type) {
  
  text <- ""
  
  tryCatch({
    if (grepl("pdf", file_type, ignore.case = TRUE)) {
      # Extract text from PDF
      if (requireNamespace("pdftools", quietly = TRUE)) {
        text <- paste(pdftools::pdf_text(file_path), collapse = "\n")
      }
    } else if (grepl("image|png|jpg|jpeg", file_type, ignore.case = TRUE)) {
      # Extract text from image using OCR
      if (requireNamespace("tesseract", quietly = TRUE)) {
        text <- tesseract::ocr(file_path)
      }
    }
  }, error = function(e) {
    warning(paste("Error extracting text:", e$message))
  })
  
  return(text)
}

#' Parse a numeric value from text near a biomarker name
#' 
#' @param text The full text to search
#' @param biomarker_names Vector of possible names for the biomarker
#' @param typical_range Expected range for validation
#' @return Extracted numeric value or NA
parse_biomarker_value <- function(text, biomarker_names, typical_range = NULL) {
  
  text_lower <- tolower(text)
  
  for (name in biomarker_names) {
    name_lower <- tolower(name)
    
    # Find position of biomarker name
    pos <- regexpr(name_lower, text_lower, fixed = TRUE)
    
    if (pos > 0) {
      # Extract surrounding context (200 chars after the name)
      start <- pos
      end <- min(pos + 200, nchar(text))
      context <- substr(text, start, end)
      
      # Look for numeric values (handles decimals, commas as decimal separators)
      # Pattern: number possibly followed by decimal (. or ,) and more digits
      matches <- gregexpr("[0-9]+[.,]?[0-9]*", context)
      values <- regmatches(context, matches)[[1]]
      
      if (length(values) > 0) {
        # Convert comma to period and parse
        for (val_str in values) {
          val_str <- gsub(",", ".", val_str)
          val <- as.numeric(val_str)
          
          # Validate against typical range if provided
          if (!is.na(val) && !is.null(typical_range)) {
            if (val >= typical_range[1] && val <= typical_range[2]) {
              return(val)
            }
          } else if (!is.na(val) && val > 0) {
            return(val)
          }
        }
      }
    }
  }
  
  return(NA)
}

#' Extract sex from text
#' 
#' @param text The full text to search
#' @return "1" for male, "2" for female, or NA
parse_sex <- function(text) {
  text_lower <- tolower(text)
  
  # Check for combined age/gender format like "34 Y/F", "34Y/M", "Age/Gender : 34 Y/F"
  # Format: number followed by Y or y, then / and M or F
  age_gender_match <- regmatches(text, regexpr("\\d+\\s*[Yy]\\s*/\\s*([MFmf])", text))
  if (length(age_gender_match) > 0 && nchar(age_gender_match) > 0) {
    gender_char <- toupper(sub(".*([MFmf])$", "\\1", age_gender_match))
    if (gender_char == "M") return("1")
    if (gender_char == "F") return("2")
  }
  
  # Check for formats like "Sex: M", "Gender: F", "Sex/Gender: Female"
  sex_line_match <- regmatches(text_lower, regexpr("(sex|gender|sexo|género|genero)\\s*[:/]?\\s*([mf]|male|female|masculino|feminino|femenino)", text_lower))
  if (length(sex_line_match) > 0 && nchar(sex_line_match) > 0) {
    if (grepl("(female|feminino|femenino|\\bf\\b)", sex_line_match)) {
      return("2")
    }
    if (grepl("(male|masculino|\\bm\\b)", sex_line_match) && !grepl("female", sex_line_match)) {
      return("1")
    }
  }
  
  # Check for standalone female indicators (more specific patterns first)
  if (grepl("\\b(female|feminino|femenino|mujer|femme)\\b", text_lower)) {
    return("2")
  }
  
  # Check for standalone male indicators (make sure it's not "female")
  if (grepl("\\b(male|masculino|hombre|homme)\\b", text_lower)) {
    if (!grepl("female|femenino|mujer|femme", text_lower)) {
      return("1")
    }
  }
  
  return(NA)
}

#' Extract all biomarkers from lab report text
#' 
#' @param text The full extracted text from the lab report
#' @return Named list with extracted biomarker values
extract_biomarkers_from_text <- function(text) {
  
  results <- list(
    albumin = NA,
    alp = NA,
    creatinine = NA,
    hba1c = NA,
    crp = NA,
    wbc = NA,
    mcv = NA,
    rdw = NA,
    lymph = NA,
    age = NA,
    sex = NA
  )
  
  if (is.null(text) || nchar(text) == 0) {
    return(results)
  }
  
  # Extract each biomarker
  for (bm_name in names(BIOMARKER_PATTERNS)) {
    pattern <- BIOMARKER_PATTERNS[[bm_name]]
    
    if (bm_name == "sex") {
      results[[bm_name]] <- parse_sex(text)
    } else {
      results[[bm_name]] <- parse_biomarker_value(
        text, 
        pattern$names, 
        pattern$typical_range
      )
    }
  }
  
  return(results)
}

#' Main function to process uploaded file and extract biomarkers
#' 
#' @param file_info File info from Shiny fileInput (with name, size, type, datapath)
#' @return Named list with extracted biomarker values and status message
process_lab_report <- function(file_info) {
  
  if (is.null(file_info)) {
    return(list(
      success = FALSE,
      message = "No file uploaded",
      values = NULL
    ))
  }
  
  # Extract text from file
  text <- extract_text_from_file(file_info$datapath, file_info$type)
  
  if (is.null(text) || nchar(trimws(text)) == 0) {
    return(list(
      success = FALSE,
      message = "Could not extract text from file. Please ensure it's a readable PDF or clear image.",
      values = NULL
    ))
  }
  
  # Extract biomarkers
  values <- extract_biomarkers_from_text(text)
  
  # Count how many values were extracted
  extracted_count <- sum(!is.na(unlist(values)))
  total_biomarkers <- 9  # Main biomarkers (excluding age/sex)
  
  if (extracted_count == 0) {
    return(list(
      success = FALSE,
      message = "No biomarker values could be extracted. Please enter values manually.",
      values = values,
      extracted_text = text
    ))
  }
  
  # Create success message
  biomarker_count <- sum(!is.na(values[c("albumin", "alp", "creatinine", "hba1c", "crp", "wbc", "mcv", "rdw", "lymph")]))
  
  return(list(
    success = TRUE,
    message = paste0("Extracted ", biomarker_count, " of ", total_biomarkers, " biomarkers. Please verify and complete any missing values."),
    values = values,
    extracted_text = text
  ))
}

#' Merge biomarker values from multiple extractions
#' 
#' @param values_list List of value lists from multiple files
#' @return Single merged list with best values (non-NA preferred)
merge_biomarker_values <- function(values_list) {
  
  # Initialize with NAs
  merged <- list(
    albumin = NA,
    alp = NA,
    creatinine = NA,
    hba1c = NA,
    crp = NA,
    wbc = NA,
    mcv = NA,
    rdw = NA,
    lymph = NA,
    age = NA,
    sex = NA
  )
  
  # Merge values - take first non-NA value found
  for (values in values_list) {
    if (!is.null(values)) {
      for (name in names(merged)) {
        if (is.na(merged[[name]]) && !is.na(values[[name]])) {
          merged[[name]] <- values[[name]]
        }
      }
    }
  }
  
  return(merged)
}

#' Process multiple uploaded files and extract biomarkers
#' 
#' @param file_info Data frame from Shiny fileInput with multiple=TRUE
#' @return Named list with extracted biomarker values and status message
process_multiple_lab_reports <- function(file_info) {
  
  if (is.null(file_info) || nrow(file_info) == 0) {
    return(list(
      success = FALSE,
      message = "No files uploaded",
      values = NULL
    ))
  }
  
  n_files <- nrow(file_info)
  all_values <- list()
  all_texts <- c()
  files_processed <- 0
  
  # Process each file
  for (i in 1:n_files) {
    text <- extract_text_from_file(file_info$datapath[i], file_info$type[i])
    
    if (!is.null(text) && nchar(trimws(text)) > 0) {
      values <- extract_biomarkers_from_text(text)
      all_values[[i]] <- values
      all_texts <- c(all_texts, text)
      files_processed <- files_processed + 1
    }
  }
  
  if (files_processed == 0) {
    return(list(
      success = FALSE,
      message = "Could not extract text from any file. Please ensure files are readable PDFs or clear images.",
      values = NULL
    ))
  }
  
  # Merge values from all files
  merged_values <- merge_biomarker_values(all_values)
  
  # Count extracted biomarkers
  biomarker_count <- sum(!is.na(merged_values[c("albumin", "alp", "creatinine", "hba1c", "crp", "wbc", "mcv", "rdw", "lymph")]))
  total_biomarkers <- 9
  
  if (biomarker_count == 0) {
    return(list(
      success = FALSE,
      message = paste0("Processed ", files_processed, " file(s) but no biomarkers found. Please enter values manually."),
      values = merged_values,
      extracted_text = paste(all_texts, collapse = "\n\n---\n\n")
    ))
  }
  
  # Create success message
  file_word <- if (n_files == 1) "file" else "files"
  
  return(list(
    success = TRUE,
    message = paste0("Processed ", files_processed, " ", file_word, ". Extracted ", biomarker_count, " of ", total_biomarkers, " biomarkers."),
    values = merged_values,
    extracted_text = paste(all_texts, collapse = "\n\n---\n\n")
  ))
}
