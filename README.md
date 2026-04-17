# DATA 550 Group Midterm Project

## Team Members
- Seiryo (Team Lead)
Coders:
- Alyssa
- Andrew
- Hyelim
- Chaaeun
- Kyria

## Project Overview
This project analyzes COVID-19 patient data to examine risk factors associated
with COVID-19 diagnosis, hospitalization, and death. The analysis includes
data cleaning, descriptive statistics, logistic regression models, and
data visualizations.

## Repository Structure
There are 6 folders: code, configuration_file data, final_code, miscellaneous, and output.
The Makefile, README, and Report. Rmd are files that are not in folders.

## R Version
The latest version of R must be used.
Required packages: tidyverse, here, gtsummary, broom.

## Install packages
install.packages(c("tidyverse", "here", "gtsummary", "broom"))

### Run scripts in this order
Rscript code/1_covid_cleaned.R
Rscript code/2_covid_tableone.R
Rscript code/02_model.R
Rscript code/03_logistic_figure.R
Rscript code/3_covid_figure1.R
Rscript code/kyria_logistic_regression.R

## Data
The data is located in the data/ folder as covid_sub.csv