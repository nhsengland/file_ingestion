# going to need to pull the dimension IDs out of the final 2324 plans and match them to the dimension names in the 
# historic actuals

dim_ids <- final_2324_plans |> 
  select(dimension_id,
         dimension_name) |> 
  unique() |> 
  filter(dimension_id < 1123)

dim_ids <-  dim_ids |>   
  mutate(dimension_name = paste0(str_sub(dimension_name,1,3),
                       '-',
                       str_sub(dimension_name,
                               str_length(dimension_name)-1,
                               str_length(dimension_name))))
# now we are merging these dimension ids with the historic actuals
p_vs_a <- left_join(historic_actuals,
                    dim_ids,
                    by = 'dimension_name')
rm(dim_ids)
# now we want to create key fields so we will be able to blend the historic actuals 
# with last year's plans 

p_vs_a <- p_vs_a |> 
  mutate(key = paste0(planning_ref,
                      measure_type,
                      measure_id,
                      org_code,
                      dimension_id))

final_2324_plans <-  final_2324_plans |> 
  mutate(key = paste0(planning_ref,
                      measure_type,
                      measure_id,
                      org_code,
                      dimension_id))

# we need to deal with the mess of secondary associated orgs so we can show how 
# the plans aligned to what happened

system_plan_total <- final_2324_plans |> 
  filter((secondary_assoc_org == 'System Total Activity'| is.na(secondary_assoc_org)) &
           str_sub(org_code,1,1)=='Q') 

provider_plan_total <- final_2324_plans |> 
  filter(str_sub(org_code,1,1)!='Q' & is.na(secondary_assoc_org))

sys_prov_total_plans_2324 <- union_all(system_plan_total,provider_plan_total)

#renaming tne metric value for clarity
sys_prov_total_plans_2324 <- sys_prov_total_plans_2324 |> 
  rename('plan_value' = metric_value)

to_bind <- sys_prov_total_plans_2324 |> 
  select(key,
         dimension_type,
         measure_short_name,
         source,
         plan_value)
rm(system_plan_total,
   provider_plan_total,
   sys_prov_total_plans_2324)
# now we can blend the plans with the actuals

p_vs_a <- left_join(p_vs_a,
          to_bind,
          by = 'key')

rm(to_bind)

