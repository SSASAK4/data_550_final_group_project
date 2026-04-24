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

## How to Generate Report
1. Clone the repository: `git clone https://github.com/SSASAK4/data_550_final_group_project.git`
2. Run `make install` to set up the R package environment
3. Run `make all` or `make build` to run the analysis and generate the report

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