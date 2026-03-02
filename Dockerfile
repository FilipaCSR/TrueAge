FROM rocker/shiny:4.3.2

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libfontconfig1-dev \
    libfreetype6-dev \
    libpng-dev \
    libtiff5-dev \
    libjpeg-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    && rm -rf /var/lib/apt/lists/*

# Install R packages
RUN R -e "install.packages(c('shiny', 'dplyr', 'DT', 'ggplot2', 'remotes'), repos='https://cran.rstudio.com/')"

# Install BioAge from GitHub
RUN R -e "remotes::install_github('dayoonkwon/BioAge')"

# Create app directory
RUN mkdir -p /srv/shiny-server/app/R

# Copy the app (modular structure)
COPY app.R /srv/shiny-server/app/
COPY R/ /srv/shiny-server/app/R/

# Set permissions
RUN chown -R shiny:shiny /srv/shiny-server

# Expose port 7860 (Hugging Face default)
EXPOSE 7860

# Run the app
CMD ["R", "-e", "shiny::runApp('/srv/shiny-server/app/app.R', host='0.0.0.0', port=7860)"]
