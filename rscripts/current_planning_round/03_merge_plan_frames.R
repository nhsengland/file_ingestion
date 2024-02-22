# merge lookup with backing data
current_plan_data <- merge(backing_data, metrics_lookup, 
                     by = 'MeasureID',  all.x = TRUE)

# remove fields where there is no associated planning reference number
current_plan_data <- current_plan_data %>% 
  filter(!is.na(PlanningRef)) %>% 
  filter(DimensionType != 'Waterfall')

#set up the short name function
source('rscripts\\current_planning_round\\fn_short_org_names.R')

current_plan_data <- fn_short_org_names(current_plan_data,'AssociatedOrg')

current_plan_data <- current_plan_data |> 
  relocate(org_short_name,.after = AssociatedOrg)

#clean up the field names
current_plan_data <- clean_names(current_plan_data) 

current_plan_data <- current_plan_data |>   
  select(-c(collection_id_k,
            time_stamp,
            comments))



# clean up unneeded backing data object. Keeping the metrics lookup because 
# we are going to use it for adding detail to the historic dataframes we will create
rm(backing_data)