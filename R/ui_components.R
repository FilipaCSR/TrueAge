# =============================================================================
# UI COMPONENTS
# =============================================================================
# Reusable UI helper functions and components
# =============================================================================

#' Create the compact header with navigation
#' 
#' @return HTML tags for the header
create_header <- function() {
  tags$div(
    class = "header-compact",
    tags$div(
      class = "header-content",
      tags$div(
        class = "header-left",
        tags$div(
          class = "logo-title-row",
          tags$span(class = "logo-text", "BioAge"),
          tags$span(class = "logo-separator", "|"),
          tags$span(class = "logo-subtitle", "Biological Age Calculator")
        )
      ),
      tags$div(
        class = "header-right",
        tags$a(
          href = "https://github.com/dayoonkwon/BioAge",
          target = "_blank",
          class = "github-link",
          tags$span("View on GitHub")
        )
      )
    )
  )
}

#' Create result tile for displaying biological age results
#' 
#' @param title Title of the tile
#' @param value_id Output ID for the value
#' @param is_main Whether this is the main (larger) result tile
#' @return HTML tags for the result tile
create_result_tile <- function(title, value_id, is_main = FALSE) {
  tags$div(
    class = if(is_main) "result-card result-card-main" else "result-card",
    tags$div(
      class = "result-label",
      title
    ),
    tags$div(
      class = "result-value",
      textOutput(value_id, inline = TRUE)
    )
  )
}

#' Create biomarker recommendation card
#' 
#' @param biomarker Biomarker name
#' @param type Either "increase" (good) or "reduce" (bad)
#' @return HTML tags for the recommendation card
create_recommendation_card <- function(biomarker, type) {
  info <- biomarker_info[[biomarker]]
  if (is.null(info)) return(NULL)
  
  if (type == "reduce") {
    # This biomarker is adding years (bad)
    header_class <- "card-header card-header-reduce"
    badge_text <- "Adding years"
    badge_class <- "badge badge-bad"
  } else {
    # This biomarker is reducing years (good)
    header_class <- "card-header card-header-increase"
    badge_text <- "Reducing years"
    badge_class <- "badge badge-good"
  }
  
  tags$div(
    class = "recommendation-card",
    tags$div(
      class = header_class,
      tags$div(
        class = "card-title-row",
        tags$span(class = "card-title", info$name),
        tags$span(class = badge_class, badge_text)
      )
    ),
    tags$div(
      class = "card-body",
      tags$p(info$description),
      tags$div(
        class = "info-section",
        tags$strong("Optimal Range: "),
        tags$span(info$optimal_range)
      ),
      tags$div(
        class = "info-section",
        tags$strong(if(type == "reduce") "Why it adds years: " else "Why it reduces years: "),
        tags$span(if(type == "reduce") info$higher_means else info$lower_means)
      ),
      tags$div(
        class = "info-section",
        tags$strong("How to improve: "),
        tags$span(info$how_to_improve)
      )
    )
  )
}

#' Create biomarker input group
#' 
#' @param id Input ID
#' @param label Display label
#' @param unit Unit of measurement
#' @param value Default value
#' @param min Minimum value
#' @param max Maximum value
#' @param step Step value
#' @param tooltip Optional tooltip text
#' @return HTML tags for the input group
create_biomarker_input <- function(id, label, unit, value, min, max, step = 0.1, tooltip = NULL) {
  div(
    class = "input-group",
    tags$label(
      `for` = id,
      paste0(label, " (", unit, ")"),
      if (!is.null(tooltip)) tags$span(
        class = "tooltip-icon",
        "?",
        tags$span(class = "tooltip-text", tooltip)
      )
    ),
    numericInput(id, NULL, value = value, min = min, max = max, step = step)
  )
}

#' Create the biomarker input panel
#' 
#' @return HTML tags for the input panel
create_input_panel <- function() {
  tagList(
    tags$div(
      class = "section-header",
      tags$h3("Personal Information")
    ),
    tags$div(
      class = "input-row-3col",
      div(
        class = "input-group",
        tags$label(`for` = "age", "Age (years)"),
        numericInput("age", NULL, value = 50, min = 30, max = 100)
      ),
      div(
        class = "input-group",
        tags$label(`for` = "sex", "Sex"),
        selectInput("sex", NULL,
                    choices = list("Female" = 2, "Male" = 1),
                    selected = 2)
      )
    ),
    
    tags$div(
      class = "section-header",
      tags$h3("Blood Biomarkers"),
      tags$p(class = "section-subtitle", "Enter values from your most recent blood test")
    ),
    
    # Metabolism & Organ Function
    tags$div(class = "subsection-header", "Metabolism & Organ Function"),
    tags$div(
      class = "input-row-3col",
      create_biomarker_input("albumin", "Albumin", "g/dL", 4.0, 2.0, 6.0, 0.1),
      create_biomarker_input("alp", "Alkaline Phosphatase", "U/L", 70, 20, 300, 1),
      create_biomarker_input("creatinine", "Creatinine", "mg/dL", 1.0, 0.3, 5.0, 0.1)
    ),
    
    tags$div(
      class = "input-row-3col",
      create_biomarker_input("hba1c", "HbA1c", "%", 5.5, 4.0, 14.0, 0.1)
    ),
    
    # Inflammation
    tags$div(class = "subsection-header", "Inflammation"),
    tags$div(
      class = "input-row-3col",
      div(
        class = "input-group",
        tags$label(
          `for` = "crp",
          "CRP (mg/L)",
          tags$span(
            class = "tooltip-icon",
            "?",
            tags$span(class = "tooltip-text", "High-sensitivity CRP (hs-CRP). Enter in mg/L.")
          )
        ),
        numericInput("crp", NULL, value = 1.0, min = 0.1, max = 100, step = 0.1)
      ),
      create_biomarker_input("wbc", "White Blood Cells", "1000 cells/µL", 6.5, 2.0, 20.0, 0.1)
    ),
    
    # Red Blood Cells
    tags$div(class = "subsection-header", "Red Blood Cells"),
    tags$div(
      class = "input-row-3col",
      create_biomarker_input("mcv", "MCV", "fL", 90, 60, 120, 0.1),
      create_biomarker_input("rdw", "RDW", "%", 13.0, 10, 25, 0.1),
      create_biomarker_input("lymph", "Lymphocyte %", "%", 30, 5, 60, 0.1)
    ),
    
    tags$div(
      class = "button-row",
      actionButton("calculate", "Calculate Biological Age", class = "calculate-btn")
    )
  )
}

#' Create the results panel structure
#' 
#' @return HTML tags for the results panel
create_results_panel <- function() {
  tagList(
    # Results summary
    tags$div(
      class = "results-container",
      uiOutput("results_summary")
    ),
    
    # Focus areas
    tags$div(
      id = "focus_areas_container",
      style = "display: none;",
      tags$div(
        class = "focus-areas-section",
        tags$h3(class = "focus-title", "Focus Areas"),
        tags$p(class = "focus-subtitle", "Biomarkers with the largest impact on your biological age"),
        uiOutput("focus_areas_content")
      )
    ),
    
    # Detailed results
    tags$div(
      id = "detailed_results_container",
      style = "display: none;",
      tags$div(
        class = "biomarker-section",
        tags$h3("Biomarker Analysis"),
        tags$p(class = "section-subtitle", "Comparison with population of same age and sex"),
        DTOutput("biomarker_table")
      )
    )
  )
}

#' Create tab navigation
#' 
#' @return HTML tags for tab navigation
create_tab_nav <- function() {
  tags$div(
    class = "tab-nav",
    tags$button(
      id = "tab_calculator",
      class = "tab-btn tab-active",
      onclick = "switchTab('calculator')",
      "Calculator"
    ),
    tags$button(
      id = "tab_about",
      class = "tab-btn",
      onclick = "switchTab('about')",
      "About KDM"
    )
  )
}
