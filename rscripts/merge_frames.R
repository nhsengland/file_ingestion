# merge lookup with backing data
merged_data <- merge(backing_data, metrics_lookup, 
                     by = 'MeasureID',  all.x = TRUE)

# remove fields where there is no associated planning reference number
merged_data <- merged_data %>% 
  filter(!is.na(PlanningRef))