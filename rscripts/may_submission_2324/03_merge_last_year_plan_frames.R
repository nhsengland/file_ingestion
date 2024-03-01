# merge lookup with backing data
last_year_plan_data <- merge(backing_data, last_year_metrics_lookup, 
                     by = 'MeasureID',  all.x = TRUE)

# remove fields where there is no associated planning reference number
last_year_plan_data <- last_year_plan_data %>% 
  filter(!is.na(PlanningRef)) %>% 
  filter(DimensionType != 'Waterfall')

## cancelled this phase because we do it downstream in the final_2324_plans process
##set up the short name function from the general tools folder
#source('rscripts\\gen_tools_and_fns\\fn_short_org_names.R')

#last_year_plan_data <- fn_short_org_names(last_year_plan_data,'AssociatedOrg')

##last_year_plan_data <- last_year_plan_data |> 
##  relocate(org_short_name,.after = AssociatedOrg)

# remove the calculated data related to planning references that are in the H2 
# resubmission but H2 did not calculate the combined a and b values.
# We are going to swap the individual a and b values with the H2 values in a later step 

last_year_plan_data <- last_year_plan_data |> 
  filter(!PlanningRef %in% c('E.M.13','E.M.30'))

# clean up unneeded backing data objects. 
rm(backing_data, last_year_metrics_lookup)