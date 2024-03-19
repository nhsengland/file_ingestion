source('rscripts\\gen_tools_and_fns\\fn_icb_short_names.R')

latest_plans_2425 <- fn_icb_short_names(current_plan_data,'selected_ccg')

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

# create a calendar
source('rscripts\\gen_tools_and_fns\\calendar_builder.R')

#pull out the useful date elements from calendar
date_lkup <- calendar |> select(month_year_long,
                        month_short_year,
                        fin_year) |> 
  rename(dimension_name = month_year_long) |> 
  unique()

latest_plans_2425 <- left_join(x = latest_plans_2425,
               y = date_lkup,
               by = 'dimension_name')

rm(date_lkup,
   calendar)

latest_plans_2425 <- latest_plans_2425 |> 
  relocate(c(month_short_year,fin_year), .after=dimension_name)


