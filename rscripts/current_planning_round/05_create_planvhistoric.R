source('rscripts\\csv_imports\\import_historic_actuals.R')
source('rscripts\\csv_imports\\import_current_plan.R')
source('rscripts\\csv_imports\\import_metrics_lookup.R')
source('rscripts\\gen_tools_and_fns\\calendar_builder.R')
source('rscripts\\gen_tools_and_fns\\fn_short_org_names.R')
source('rscripts\\gen_tools_and_fns\\fn_icb_short_names.R')

metrics_lookup <- clean_names(metrics_lookup)

plans <- current_plan_data |> 
  filter(secondary_assoc_org == 'SYSTEM TOTAL ACTIVITY' |
           is.na(secondary_assoc_org)) |> 
  rename('icb_code' = selected_ccg,
         'org_code' = associated_org) |> 
  mutate(source = 'march24_plan') |> 
  select(measure_id,
         icb_code,
         org_code,
         measure_type,
         dimension_name,
         source,
         metric_value) |> 
  filter(metric_value != -99999999) |> 
  unique()

historic <- historic_actuals |> 
  mutate(source = 'historic_actuals') |> 
  select(measure_id,
         icb_code,
         org_code,
         measure_type,
         dimension_name,
         source,
         metric_value = value)

short_month <- calendar |> 
  select(month_year_long,
         month_year) |> 
  mutate(month_year = as.character(month_year)) |> 
  unique()

plans <- left_join(plans,
               short_month,
               by = c(dimension_name = "month_year_long"))

plans <- plans |> 
  mutate(dimension_name = case_when(
    !is.na(month_year) ~ month_year,
    .default = dimension_name))

plans <- plans |> select(-month_year)

latest_plans_2425 <- union_all(plans,historic)

rm(plans,historic)

references <- metrics_lookup |> 
  select(measure_id,
         planning_ref) |> 
  unique() 

latest_plans_2425 <- left_join(latest_plans_2425,
                      references,
                      by = 'measure_id')|>
  filter(!is.na(planning_ref))
  
latest_plans_2425 <- latest_plans_2425 |> 
  select(planning_ref,
         icb_code,
         org_code,
         measure_type,
         dimension_name,
         source,
         metric_value)

latest_plans_2425 <- latest_plans_2425 |> 
  mutate(measure_type = case_when(
    measure_type == 'Count/Total' ~ 'Count',
    measure_type == 'Total' ~ 'Count',
    .default = measure_type
  ))

latest_plans_2425 <- pivot_wider(latest_plans_2425,
                                 names_from = measure_type,
                                 values_from = metric_value) 

latest_plans_2425 <- latest_plans_2425 |> 
  filter(!is.na(org_code))
  
for_agg <- latest_plans_2425 |> 
  select(planning_ref,
         org_code) |> 
  unique() |> 
  subset(!planning_ref %in% planning_ref[str_sub(org_code,1,1)=='Q']) |> 
  select(-org_code) |> 
  unique()

trust_to_system <- latest_plans_2425 |> 
  filter(planning_ref %in% for_agg$planning_ref) |> 
  mutate(org_code = icb_code) |> 
  group_by(planning_ref,
           icb_code,
           org_code,
           dimension_name,
           source) |> 
  summarise(Count = sum(Count),
            Numerator = sum(Numerator),
            Denominator = sum(Denominator),
            Percentage = NA,
            Rate = NA,
            Mean = NA,
            .groups = 'drop') |> 
  ungroup() |> 
  filter(planning_ref != 'E.B.23c') |> 
  mutate(Percentage = Numerator/Denominator)

latest_plans_2425 <- union_all(latest_plans_2425,
                               trust_to_system)

latest_plans_2425 <- pivot_longer(latest_plans_2425,
                                  cols = c(Count,
                                           Numerator,
                                           Denominator,
                                           Percentage,
                                           Rate,
                                           Mean),
                                  names_to = 'measure_type',
                                  values_to = 'metric_value',
                                  values_drop_na = TRUE)

metrics_lookup <- metrics_lookup |> 
  mutate(measure_type = case_when(
    component_type == 'Count/Total' ~ 'Count',
    component_type == 'Total' ~ 'Count',
    .default = component_type),
    planning_ref = case_when(
    planning_ref == 'E.A.S.1' ~ 'Rate',
    planning_ref == 'E.K.1' ~ 'Percentage',
    .default = planning_ref)
    ) |> 
  mutate(key = paste0(planning_ref,measure_type)) |> 
  filter(measure_id != 1266) |> 
  select(-c(planning_ref,
            measure_type))

##### Need to create a key field then merge in the metric names etc.

latest_plans_2425 <- latest_plans_2425 |> mutate(key = paste0(planning_ref,measure_type))


latest_plans_2425 <- left_join(latest_plans_2425,
                    metrics_lookup,
                    by = 'key')

latest_plans_2425 <- fn_icb_short_names(latest_plans_2425,'icb_code')
latest_plans_2425 <- fn_short_org_names(latest_plans_2425,'org_code')

rm(calendar,
   current_plan_data,
   for_agg,
   historic_actuals,
   metrics_lookup,
   references,
   short_month,
   trust_to_system,
   fn_icb_short_names,
   fn_short_org_names)
