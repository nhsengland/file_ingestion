source('rscripts\\gen_tools_and_fns\\fn_icb_short_names.R')

latest_plans_2425 <- fn_icb_short_names(current_plan_data,'selected_ccg')

rm(fn_icb_short_names)

latest_plans_2425 <- latest_plans_2425 |> 
  rename(icb_code = selected_ccg,
         org_code = associated_org) |> 
  select(measure_id,
         icb_code,
         icb_short_name,
         org_code,
         org_short_name,
         measure_name,
         measure_type,
         planning_ref,
         measure_subject,
         activity_category,
         short_name,
         component_type,
         component_name,
         granularity,
         dimension_id,
         dimension_type,
         dimension_name,
         secondary_assoc_org,
         metric_value)
  
system_plan_total <- latest_plans_2425 |> 
  filter((secondary_assoc_org == 'System Total Activity'| is.na(secondary_assoc_org)) &
           str_sub(org_code,1,1)=='Q') 

provider_plan_total <- latest_plans_2425 |> 
  filter(str_sub(org_code,1,1)!='Q' & is.na(secondary_assoc_org))

latest_plans_2425 <- union_all(system_plan_total,provider_plan_total)

latest_plans_2425 <- latest_plans_2425 |> 
  mutate(measure_type = case_when(
    measure_type=='Count/Total' ~ 'Count',
    .default = measure_type))


# create a calendar
source('rscripts\\gen_tools_and_fns\\calendar_builder.R')

# pull out the useful date elements from calendar
# we have to do this two ways because the export to csv reformats the long dates 
# into short dates and I want this process to work from a raw import and a "restore point"

date_lkup <- calendar |> select(month_year_long,
                        month_short_year,
                        fin_year) |> 
  rename(dimension_name = month_year_long) |> 
  unique()

dl2 <- calendar |> select(month_short_year,
                          fin_year) |> 
  rename(dimension_name = month_short_year) |> 
  unique() |> 
  mutate(month_short_year = dimension_name) |> 
  select(dimension_name,
         month_short_year,
         fin_year)

date_lkup <- union_all(date_lkup,dl2)

latest_plans_2425 <- left_join(x = latest_plans_2425,
                               y = date_lkup,
                               by = 'dimension_name')
rm(date_lkup,
   calendar,
   dl2,
   provider_plan_total,
   system_plan_total)

latest_plans_2425 <- latest_plans_2425 |> 
  relocate(c(month_short_year,fin_year), .after=dimension_name) |> 
  select(-secondary_assoc_org)
