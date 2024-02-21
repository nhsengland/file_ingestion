# Exports the historic actuals from the backing tabs in the planning submissions
# the dataframe comes from the current planning round process and is produced in step 04

write_csv(historic_actuals,paste0('csv_exports\\historic_actuals',today(),'.csv'))