h2_data <- h2_data %>% 
  select(!c(helper_1,
            helper_2,
            helper_3,
            org_code_calc,
            dimension_name,
            region_name,
            region_code,
            value_actuals,
            value_plans,
            original_bed_core,
            original_bed_esc,
            original_bed_added_esc,
  )) %>% 
  pivot_longer(
    cols = c(
      plan_restated,
      restated_bed_core,
      restated_bed_esc,
      restated_bed_added_esc),
    names_to = 'metric_name',
    values_to = 'metric_value'
  ) %>%
  filter(!is.na(metric_value)) |> 
  mutate(metric_value = as.numeric(metric_value))

#convert dim_date_start to a date format
h2_data$dim_date_start <- excel_numeric_to_date(as.numeric(h2_data$dim_date_start))

# convert mean duration to seconds
h2_data <- h2_data |> 
  mutate(metric_value = case_when(
    measure_name == 'C2 Mean' ~ round(metric_value*86400),
    .default = metric_value
  ))


