---
title: TrueAge - Biological Age Calculator
emoji: 🧬
colorFrom: green
colorTo: blue
sdk: docker
pinned: false
license: mit
---

# Biological Age Calculator

A Shiny web application that calculates biological age using the **Klemera-Doubal Method (KDM)**, based on the [BioAge R package](https://github.com/dayoonkwon/BioAge).

![Biological Age Calculator](https://img.shields.io/badge/R-Shiny-blue)
![License](https://img.shields.io/badge/license-MIT-green)

## What is Biological Age?

Biological age reflects how well your body is functioning compared to others of your chronological age. Unlike chronological age (years since birth), biological age can be influenced by lifestyle, diet, exercise, and other factors.

This calculator uses the **Klemera-Doubal Method (KDM)**, a scientifically validated approach that estimates biological age by analyzing how your biomarkers compare to age-related changes observed in a large reference population (NHANES III).

## Features

- **Calculate Biological Age** using 9 blood biomarkers
- **Visual comparison** of your biomarkers vs population averages
- **Focus Areas** highlighting biomarkers adding years to your biological age
- **Educational content** about each biomarker and how to optimize them

## Biomarkers Used

| Category | Biomarkers |
|----------|------------|
| **Metabolism & Organ Function** | Albumin, Alkaline Phosphatase (ALP), Creatinine, HbA1c |
| **Inflammation** | C-Reactive Protein (CRP), White Blood Cells (WBC) |
| **Red Blood Cells** | Mean Corpuscular Volume (MCV), Red Cell Distribution Width (RDW), Lymphocyte % |

## Project Structure

```
BioAge/
├── app.R                  # Entry point
├── R/
│   ├── global.R           # Libraries, constants, color palette
│   ├── biomarker_data.R   # Biomarker information database
│   ├── styles.R           # CSS styling
│   ├── calculations.R     # KDM calculation functions
│   ├── ui_components.R    # Reusable UI components
│   ├── ui.R               # Main user interface
│   └── server.R           # Server-side logic
├── Dockerfile             # Docker config for deployment
└── README.md
```

## Running Locally

### Prerequisites

- R (>= 4.0.0)
- Required packages: `shiny`, `BioAge`, `dplyr`, `ggplot2`, `DT`

### Installation

```r
# Install required packages
install.packages(c("shiny", "dplyr", "ggplot2", "DT", "remotes"))
remotes::install_github("dayoonkwon/BioAge")
```

### Run the App

```r
shiny::runApp("app.R")
```

## Deployment

### Hugging Face Spaces (Docker)

1. Create a new Space on [huggingface.co/spaces](https://huggingface.co/spaces)
2. Choose **Docker** as the SDK
3. Upload `app.R`, `R/` folder, `Dockerfile`, and rename `README_HF.md` to `README.md`

### Posit Connect / shinyapps.io

Deploy using the standard Shiny deployment workflow.

## How to Interpret Results

| Result | Meaning |
|--------|---------|
| **Biological < Chronological** | 🌟 You're aging slower than average |
| **Biological ≈ Chronological** | 👍 You're aging at a typical pace |
| **Biological > Chronological** | ⚠️ Consider lifestyle improvements |

## Scientific References

1. [Klemera P, Doubal S. A new approach to the concept and computation of biological age. Mech Ageing Dev. 2006;127(3):240-248.](https://pubmed.ncbi.nlm.nih.gov/16318865/)

2. [Levine ME. Modeling the rate of senescence. J Gerontol A Biol Sci Med Sci. 2013;68(6):667-674.](https://pubmed.ncbi.nlm.nih.gov/23213031/)

3. [Kwon D, Belsky DW. A toolkit for quantification of biological age from blood chemistry and organ function test data: BioAge. GeroScience. 2021;43(6):2795-2808.](https://pmc.ncbi.nlm.nih.gov/articles/PMC8602613/)

## Disclaimer

This calculator is for **educational purposes only** and should not be used as a substitute for professional medical advice. Always consult with healthcare providers for medical decisions.

## Author

**Filipa Santos Rodrigues**  
[Medium](https://medium.com/@filipacsr)

If you enjoy it, [Buy Me a Coffee](https://buymeacoffee.com/filipacsr) ☕

## License

MIT License - see [LICENSE](LICENSE) for details.
