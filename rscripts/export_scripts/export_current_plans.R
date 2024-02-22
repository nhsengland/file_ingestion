# Exports current plans from the latest submissions produced in
# the current planning round process stage 03 "merge plan frames"

write_csv(current_plan_data,paste0('csv_exports\\current_plan_data',today(),'.csv'))