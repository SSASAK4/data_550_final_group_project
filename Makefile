report.html: Report.Rmd output/covid_cleaned.rds output/table_one.rds \
	output/figure1.rds output/forest_plot.png output/marginal_effects.png \
	output/kyria_intubation_plot.png
	Rscript -e "rmarkdown::render('Report.Rmd')"

output/covid_cleaned.rds: code/1_covid_cleaned.R data/covid_sub.csv
	Rscript code/1_covid_cleaned.R

output/table_one.rds: code/2_covid_tableone.R output/covid_cleaned.rds
	Rscript code/2_covid_tableone.R

output/model_df.rds output/covid_model.rds: code/02_model.R output/covid_cleaned.rds
	Rscript code/02_model.R

output/forest_plot.png output/marginal_effects.png: code/03_logistic_figure.R \
	output/covid_model.rds output/model_df.rds
	Rscript code/03_logistic_figure.R

output/figure1.rds: code/3_covid_figure1.R output/covid_cleaned.rds
	Rscript code/3_covid_figure1.R

output/kyria_intubation_plot.png output/kyria_model.rds: \
	code/03_kyria_regression.R output/covid_cleaned.rds
	Rscript code/03_kyria_regression.R

.PHONY: clean
clean:
	rm -f output/*.rds && rm -f output/*.png && rm -f report.html rm -f *.pdf