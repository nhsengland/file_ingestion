
# first we ensure that the names are consistent between the two dataframes and 
# that latest plans has entries for the columns that it is missing from the 
# historic PVA

latest_plans_2425 <- latest_plans_2425 |> 
  rename('measure_short_name' = short_name,
         'planned_activity' = metric_value) |> 
  select(-c(dimension_id,
            dimension_type,
            dimension_name)) |> 
  mutate('source' = 'March24 plan',
         'actual_activity' = NA)

# next we put the columns into the order we want the final df to have
latest_plans_2425 <- latest_plans_2425 |> 
  relocate(c(source,actual_activity),.after=measure_type) |> 
  relocate(measure_short_name, .after=measure_name)

# now we pull a list of those names out
col_order <- names(latest_plans_2425)

# now we select just those columns from the historic pva. This will also reorder
# the columns so that they match the latest plans order
historic_monthly_pva <- historic_monthly_pva |> 
  select(all_of(col_order)) |> 
  filter(fin_year == '2023-24' & !is.na(planning_ref))

# next we union the two dataframes together
march_24_pva <- union_all(historic_monthly_pva,
                          latest_plans_2425)

march_24_pva <- march_24_pva |> 
  filter(!is.na(month_short_year))

#finally we drop the objects we don't need

rm(#historic_monthly_pva,
   #latest_plans_2425,
   col_order)

m24_for_customers <- march_24_pva |> 
  rename(plan = planned_activity,
         actual = actual_activity) |> 
  pivot_longer(cols = c(plan,actual),
               names_to = 'activity_type',
               values_to = 'metric_value') |> 
  mutate(month_name = str_sub(month_short_year,1,3)) |> 
  relocate(month_name, .after = month_short_year)