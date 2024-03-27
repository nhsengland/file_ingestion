# Exports the dataframe with plan data as submitted, plus additional transformations 
# produced in the plan vs actual process stage 03 "merge latest and historic"

write_csv(march_24_pva,paste0('csv_exports\\march_24_pva',today(),'.csv'))


write_csv(m24_for_customers,paste0('csv_exports\\march_24_plan_pivot',today(),'.csv'))

