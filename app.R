# =============================================================================
# BIOLOGICAL AGE CALCULATOR
# =============================================================================
# A Shiny app to calculate biological age using the Klemera-Doubal method (KDM)
# Based on the BioAge R package by Dayoon Kwon
#
# Modular Structure:
#   R/global.R         - Libraries, constants, color palette
#   R/biomarker_data.R - Biomarker information database
#   R/styles.R         - CSS styling (Apple-inspired design)
#   R/calculations.R   - KDM calculation functions
#   R/extraction.R     - Lab report parsing (PDF/image)
#   R/ui_components.R  - Reusable UI helper functions
#   R/ui.R             - Main user interface
#   R/server.R         - Server-side logic
# =============================================================================

# Source all module files
source("R/global.R")
source("R/biomarker_data.R")
source("R/styles.R")
source("R/calculations.R")
source("R/extraction.R")
source("R/ui_components.R")
source("R/ui.R")
source("R/server.R")

# =============================================================================
# RUN THE APP
# =============================================================================

shinyApp(ui = ui, server = server)
