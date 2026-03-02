# =============================================================================
# UI DEFINITION
# =============================================================================
# Main user interface for the Biological Age Calculator
# =============================================================================

ui <- fluidPage(
  
  tags$head(
    tags$style(HTML(apple_css)),
    tags$meta(name = "viewport", content = "width=device-width, initial-scale=1")
  ),
  
  div(class = "container-fluid",
      
      # Header with Navigation
      div(class = "app-header",
          h1(class = "app-title", "TrueAge"),
          p(class = "app-subtitle", 
            "Discover your biological age using the Klemera-Doubal method"),
          
          # Navigation tabs inside header
          div(class = "header-tabs",
              tabsetPanel(
                id = "main_tabs",
                type = "tabs",
                
                # =================================================================
                # CALCULATE TAB
                # =================================================================
                tabPanel(
                  "Calculate",
                  div(style = "padding-top: 16px;",
                  
                      fluidRow(
                        # Input Column - narrower
                        column(3,
                               div(class = "apple-card",
                                   h3(class = "apple-card-title", "Your Information"),
                               
                                   # Demographics - side by side
                                   fluidRow(
                                     column(6, numericInput("age", "Age", value = 34, min = 20, max = 100)),
                                     column(6, selectInput("sex", "Sex", choices = c("Female" = 2, "Male" = 1)))
                                   ),
                               
                               hr(style = "border-color: #f5f5f7; margin: 12px 0;"),
                               
                               h4(style = "font-size: 13px; font-weight: 600; color: #86868b; margin-bottom: 10px; text-transform: uppercase; letter-spacing: 0.5px;", 
                                  "Blood Chemistry"),
                               
                               fluidRow(
                                 column(6, numericInput("albumin", "Albumin (g/dL)", value = 4.4, min = 1, max = 7, step = 0.1)),
                                 column(6, numericInput("alp", "ALP (U/L)", value = 47, min = 10, max = 500, step = 1))
                               ),
                               fluidRow(
                                 column(6, numericInput("creatinine", "Creatinine (mg/dL)", value = 0.7, min = 0.1, max = 5, step = 0.1)),
                                 column(6, numericInput("hba1c", "HbA1c (%)", value = 5.6, min = 3, max = 15, step = 0.1))
                               ),
                               
                               numericInput("crp", "C-Reactive Protein (CRP) (mg/L)", value = 0.9, min = 0, max = 100, step = 0.1),
                               
                               hr(style = "border-color: #f5f5f7; margin: 12px 0;"),
                               
                               h4(style = "font-size: 13px; font-weight: 600; color: #86868b; margin-bottom: 10px; text-transform: uppercase; letter-spacing: 0.5px;", 
                                  "Complete Blood Count"),
                               
                               fluidRow(
                                 column(6, numericInput("wbc", "WBC (10³/µL)", value = 4.7, min = 1, max = 30, step = 0.1)),
                                 column(6, numericInput("mcv", "MCV (fL)", value = 92, min = 50, max = 130, step = 0.1))
                               ),
                               fluidRow(
                                 column(6, numericInput("rdw", "RDW (%)", value = 12.8, min = 8, max = 25, step = 0.1)),
                                 column(6, numericInput("lymph", "Lymph (%)", value = 42, min = 5, max = 80, step = 0.1))
                               ),
                               
                               actionButton("calculate", "Calculate", class = "btn-calculate")
                           )
                    ),
                    
                    # Results Column - wider
                    column(9,
                           uiOutput("resultsUI")
                    )
                  )
              )
            ),
            
            # =================================================================
            # LEARN TAB
            # =================================================================
            tabPanel(
              "Learn",
              div(style = "padding-top: 16px;",
                  
                  h2(class = "section-header", "Understanding Your Biomarkers"),
                  p(class = "section-subheader", 
                    "Each biomarker tells a story about your health. Learn what they mean and how to optimize them."),
                  
                  div(class = "info-grid",
                      lapply(names(biomarker_info), function(bm) {
                        info <- biomarker_info[[bm]]
                        div(class = "apple-card",
                            h4(class = "apple-card-title", info$name),
                            p(style = "color: #86868b; font-size: 13px; margin-bottom: 10px;", info$description),
                            
                            div(style = "background: #f5f5f7; border-radius: 8px; padding: 10px; margin-bottom: 10px;",
                                p(style = "margin: 0; font-size: 12px;",
                                  tags$strong("Optimal: "), info$optimal_range)
                            ),
                            
                            p(style = "font-size: 12px; margin-bottom: 4px;",
                              tags$strong(style = "color: #C4622D;", "↑ "), info$higher_means),
                            p(style = "font-size: 12px; margin-bottom: 10px;",
                              tags$strong(style = "color: #2D7A5F;", "↓ "), info$lower_means),
                            
                            h5(style = "font-size: 12px; font-weight: 600; margin-bottom: 6px;", "Tips"),
                            tags$ul(class = "recommendation-list",
                                    lapply(info$how_to_improve[1:3], function(tip) tags$li(tip))
                            )
                        )
                      })
                  )
              )
            ),
            
            # =================================================================
            # ABOUT TAB
            # =================================================================
            tabPanel(
              "About",
              div(style = "padding-top: 16px; max-width: 800px; margin: 0 auto;",
                  
                  div(class = "apple-card",
                      h2(class = "apple-card-title", "What is Biological Age?"),
                      p(style = "font-size: 14px; color: #1d1d1f; line-height: 1.6; margin-bottom: 12px;",
                        "Biological age reflects how well your body is functioning compared to others your chronological age. 
                        Unlike chronological age (years since birth), biological age can be influenced by lifestyle, diet, 
                        exercise, and other factors."),
                      
                      p(style = "font-size: 14px; color: #1d1d1f; line-height: 1.6;",
                        "This calculator uses the ", tags$strong("Klemera-Doubal Method (KDM)"), 
                        ", a scientifically validated approach that estimates biological age by analyzing how your 
                        biomarkers compare to age-related changes observed in a large reference population.")
                  ),
                  
                  div(class = "apple-card",
                      h3(class = "apple-card-title", "How to Interpret"),
                      
                      fluidRow(
                        column(4,
                          div(class = "stat-card", style = "background: linear-gradient(135deg, rgba(45, 122, 95, 0.15) 0%, rgba(45, 122, 95, 0.05) 100%);",
                              p(style = "font-size: 14px; margin: 0;",
                                tags$strong(style = "color: #2D7A5F;", "Biological < Chronological"),
                                tags$br(),
                                span(style = "color: #86868b; font-size: 12px;", "Aging slower"))
                          )
                        ),
                        column(4,
                          div(class = "stat-card", style = "background: linear-gradient(135deg, rgba(140, 140, 140, 0.15) 0%, rgba(140, 140, 140, 0.05) 100%);",
                              p(style = "font-size: 14px; margin: 0;",
                                tags$strong(style = "color: #8C8C8C;", "Biological ≈ Chronological"),
                                tags$br(),
                                span(style = "color: #86868b; font-size: 12px;", "Typical pace"))
                          )
                        ),
                        column(4,
                          div(class = "stat-card", style = "background: linear-gradient(135deg, rgba(196, 98, 45, 0.15) 0%, rgba(196, 98, 45, 0.05) 100%);",
                              p(style = "font-size: 14px; margin: 0;",
                                tags$strong(style = "color: #C4622D;", "Biological > Chronological"),
                                tags$br(),
                                span(style = "color: #86868b; font-size: 12px;", "Consider changes"))
                          )
                        )
                      )
                  ),
                  
                  div(class = "apple-card",
                      h3(class = "apple-card-title", "References"),
                      p(style = "font-size: 12px; color: #86868b; line-height: 1.5; margin-bottom: 8px;",
                        tags$a(href = "https://pubmed.ncbi.nlm.nih.gov/16318865/", target = "_blank", style = "color: #1C4A3E;",
                               "Klemera P, Doubal S. A new approach to the concept and computation of biological age. Mech Ageing Dev. 2006;127(3):240-248.")),
                      p(style = "font-size: 12px; color: #86868b; line-height: 1.5; margin-bottom: 8px;",
                        tags$a(href = "https://pubmed.ncbi.nlm.nih.gov/23213031/", target = "_blank", style = "color: #1C4A3E;",
                               "Levine ME. Modeling the rate of senescence: can estimated biological age predict mortality more accurately than chronological age? J Gerontol A Biol Sci Med Sci. 2013;68(6):667-674.")),
                      p(style = "font-size: 12px; color: #86868b; line-height: 1.5;",
                        tags$a(href = "https://pmc.ncbi.nlm.nih.gov/articles/PMC8602613/", target = "_blank", style = "color: #1C4A3E;",
                               "Kwon D, Belsky DW. A toolkit for quantification of biological age from blood chemistry and organ function test data: BioAge. GeroScience. 2021;43(6):2795-2808.")),
                      p(style = "font-size: 11px; color: #86868b; text-align: center; margin-top: 12px;",
                        "Built with R Shiny and the BioAge package. For educational purposes only.")
                  )
              )
            )
          ) # End tabsetPanel
      ) # End header-tabs div
      ), # End app-header div
      
      # Footer
      div(class = "app-footer",
          p("By Filipa Santos Rodrigues · ", 
            tags$a(href = "https://medium.com/@filipacsr", target = "_blank", "Explore more on Medium"))
      )
  )
)
