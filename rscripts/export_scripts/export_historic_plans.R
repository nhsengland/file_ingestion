# Exports the plans from last year (merged May and H2 plan submissions with 
# H2 overwriting May submission data) produced in
# the series of processes for last years plans. The final dataframe comes from 
# final_2324_plans process and is produced in step 04

write_csv(historic_actuals,paste0('csv_exports\\historic_actuals',today(),'.csv'))