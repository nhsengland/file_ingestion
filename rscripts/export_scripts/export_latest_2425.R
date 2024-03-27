# Exports the dataframe with plan data as submitted, plus additional transformations 
# produced in the current planning round process stage 06 "system level aggregations to latest plans"

write_csv(latest_plans_2425,paste0('csv_exports\\latest_2425_plans',today(),'.csv'))