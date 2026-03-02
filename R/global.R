# =============================================================================
# GLOBAL CONFIGURATION
# =============================================================================
# Libraries, constants, and shared data
# =============================================================================

# Load required packages
library(shiny)
library(BioAge)
library(dplyr)
library(ggplot2)
library(DT)

# =============================================================================
# COLOR PALETTE
# =============================================================================

COLORS <- list(
  navy = "#1B3A5C",
  brand_green = "#1C4A3E",
  bright_green = "#2D7A5F",
  neutral_gray = "#8C8C8C",
  dark_orange = "#C4622D",
  background = "#F8F7F4",
  card_border = "#EBEBEB",
  text_primary = "#1d1d1f",
  text_secondary = "#86868b"
)

# =============================================================================
# APP CONFIGURATION
# =============================================================================

APP_CONFIG <- list(
  title = "Biological Age",
  subtitle = "Discover your biological age using the Klemera-Doubal method",
  author = "Filipa Santos Rodrigues",
  author_link = "https://medium.com/@filipacsr"
)

# =============================================================================
# BIOMARKER DEFINITIONS
# =============================================================================

BIOMARKERS <- c("albumin", "alp", "lymph", "mcv", "lncreat", "lncrp", "hba1c", "wbc", "rdw")

BIOMARKER_DISPLAY_NAMES <- c(
  albumin = "Albumin",
  alp = "ALP",
  creatinine = "Creat",
  hba1c = "HbA1c",
  crp = "CRP",
  wbc = "WBC",
  mcv = "MCV",
  rdw = "RDW",
  lymph = "Lymph"
)
