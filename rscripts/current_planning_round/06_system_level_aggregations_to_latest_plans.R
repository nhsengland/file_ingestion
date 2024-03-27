source('rscripts\\system_aggregations\\refs_with_system_level.R')
source('rscripts\\system_aggregations\\fn_aggregate_system_rows.R')

latest_plans_2425 <- fn_aggregate_system_rows(latest_plans_2425,refs_with_system_level)

measure_types <- unique(latest_plans_2425$measure_type)

name_list <- names(latest_plans_2425)

removed_cols_plus_key <- latest_plans_2425 |> 
  select(c(measure_id,
          planning_ref,
          measure_type,
          measure_name,
          component_type,
          component_name)) |> 
  unique() |> 
  mutate(key = paste0(planning_ref,measure_type)) |> 
  select(-c(planning_ref,measure_type))

latest_plans_2425 <- latest_plans_2425 |> 
  select(-c(measure_id,
            measure_name,
             component_type,
             component_name))

latest_plans_2425 <- pivot_wider(latest_plans_2425,
                  names_from = measure_type,
                  values_from = metric_value)

latest_plans_2425 <- latest_plans_2425 |> 
  mutate(Percentage = Numerator/Denominator)

latest_plans_2425 <- latest_plans_2425 |> 
  pivot_longer(cols = c(measure_types),
               names_to = 'measure_type',
               values_to = 'metric_value',
               values_drop_na = TRUE) |> 
  mutate(key = paste0(planning_ref,measure_type))

latest_plans_2425 <- left_join(latest_plans_2425,
                               removed_cols_plus_key,
                               by = 'key',
                               keep = FALSE) |> 
  select(all_of(name_list))

latest_plans_2425 <- latest_plans_2425 |> 
  filter(!is.na(planning_ref))

rm(removed_cols_plus_key,
   measure_types,
   name_list,
   refs_with_system_level,
   fn_aggregate_system_rows)