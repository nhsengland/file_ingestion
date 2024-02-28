# Exports the file containing 
# The historic actuals from this year's planning submissions and 
# where there were plans created against those metrics last year we also have those
# plans, using the (merged May and H2 plan submissions with H2 overwriting May submission data) 
# File created in plan_vs_actual process and produced in file 01create_historic_monthly_pva

write_csv(historic_monthly_pva,paste0('csv_exports\\historic_monthly_pva',today(),'.csv'))