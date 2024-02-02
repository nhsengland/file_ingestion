# merge lookup with backing data
plan_data <- merge(backing_data, metrics_lookup, 
                     by = 'MeasureID',  all.x = TRUE)

# remove fields where there is no associated planning reference number
plan_data <- plan_data %>% 
  filter(!is.na(PlanningRef)) %>% 
  filter(DimensionType != 'Waterfall')

#set up the short name function
source('rscripts\\fn_short_org_names.R')

plan_data <- fn_short_org_names(plan_data,'AssociatedOrg')

plan_data <- plan_data |> 
  relocate(org_short_name,.after = AssociatedOrg)

# clean up unneeded backing data object. Keeping the metrics lookup because 
# we are going to use it for adding detail to the historic dataframes we will create
rm(backing_data)