# For monthly metrics we are going to create a framework of the unique values for 
# the historic actuals. Then a set of dates relevant to the period.
# 
# Run a Cartesian join so that every metric has a space for either actuals 
# or plan values

# I've removed the ISP NHS column so that if we are looking at anything where 
# that is split in the historic actuals we will filter to the NAs and get the 
# overall view, for providers this should not matter


matrix_a <- historic_actuals |> 
  select(measure_id,
         org_code,
         org_type,
         icb_code,
         region_code,
         measure_name,
         measure_type,
         planning_ref,
         measure_subject,
         activity_category,
         short_name,
         component_type,
         component_name,
         granularity,
         org_short_name) |> 
  unique()

month_list <- calendar |> 
  select(month_short_year,
         month_commencing,
         fin_year) |> 
  unique() |> 
  filter(fin_year %in% c('2019-20','2021-22','2022-23','2023-24'))


framework <- cross_join(matrix_a,
                       month_list)

framework <- framework |> 
  mutate(key = paste0(planning_ref,
                      measure_type,
                      measure_id,
                      org_code,
                      month_short_year))

#historic_actuals can use the same key but change the last field to dimension_name
#final 2324 plans needs to have an additional field because the way that dimension 
#name was structured last year is different. 

final_2324_plans_monthly <- final_2324_plans |> 
  filter(dimension_id < 1123) |> 
  mutate(dimension_name = paste0(str_sub(dimension_name,1,3),
                                 '-',
                                 str_sub(dimension_name,
                                         str_length(dimension_name)-1,
                                         str_length(dimension_name)))) |> 
  mutate(key = paste0(planning_ref,
                      measure_type,
                      measure_id,
                      org_code,
                      dimension_name)) |> 
  rename(planned_activity = metric_value) 

# we need to deal with the mess of secondary associated orgs so we can show how 
# the plans aligned to what happened

system_plan_total <- final_2324_plans_monthly |> 
  filter((secondary_assoc_org == 'System Total Activity'| is.na(secondary_assoc_org)) &
           str_sub(org_code,1,1)=='Q') 

provider_plan_total <- final_2324_plans_monthly |> 
  filter(str_sub(org_code,1,1)!='Q' & is.na(secondary_assoc_org))

sys_prov_monthly_plans_2324 <- union_all(system_plan_total,provider_plan_total)

# now limit it down to just the planned activity because everything else is in
# the framework and identified by the key 

sys_prov_monthly_plans_2324 <- sys_prov_monthly_plans_2324 |> 
  select(key,
         source,
         planned_activity)

# as above, get rid of the isp/nhs split, create key, filter.
monthly_historic_actuals <- historic_actuals |> 
  filter(is.na(isp_nhs)) |> 
  mutate(key = paste0(planning_ref,
                      measure_type,
                      measure_id,
                      org_code,
                      dimension_name)) |> 
  rename(actual_activity = value) |> 
  select(key,
         actual_activity)

# merge everything together

monthly_pva <- left_join(framework,
                         sys_prov_monthly_plans_2324,
                         by = 'key')

monthly_pva <- left_join(monthly_pva,
                         monthly_historic_actuals,
                         by = 'key')

monthly_pva <- monthly_pva |> rename(measure_short_name = short_name)

# cleaning up unneeded objects
rm(monthly_working_days,
   monthly_historic_actuals,
   system_plan_total,
   provider_plan_total,
   sys_prov_monthly_plans_2324,
   month_list,
   metric_list_just_2425,
   matrix_a,
   framework,
   final_2324_plans_monthly,
   calendar)