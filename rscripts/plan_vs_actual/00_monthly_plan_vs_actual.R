# reshape the h2 bed data to match how it was collected in 2324
source('rscripts\\plan_vs_actual\\01_create_historic_monthly_pva.R')
# merge the may and h2 submissions
source('rscripts\\final_2324_plans\\02_create_percentage_rows.R')