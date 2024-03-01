# The goal here is to combine the original plans and the h2 plans
# and where there were values submitted for the same metric in both collections
# we are going to overwrite the original plan value with the h2 value

# we are going to do this by:
# creating a common key between both dataframes, it's going to need to be a compound
# key because there isn't a single unique field
# we will use that to merge the two dataframes which will give us two columns with
# values

# we will then mutate a column with an ifelse or a case_when to give us a single
# column with the relevant merged values
# we will also use a similar mutate to generate a second column that has the 
# source of the value

# add source column to h2 and last year's plan data

h2_data_2324_mapping <- h2_data_2324_mapping |> 
  mutate(source = 'H2 Submission')
last_year_plan_data <- last_year_plan_data |> 
  mutate(source = 'May Submission')

# cleaning up the planning data a bit by running the dataframe through 
# janitor::clean_names for consistent column names 
# (probably should have done this earlier!) and removing the empty values 
# (flagged using -99999999)

last_year_plan_data <- last_year_plan_data |> 
  clean_names() |> 
  filter(metric_value > -99999999)  
 

# next up we will create a key field for both tables. It's not required, we 
# merge based on multiple fields but this helps keep the joins less cluttered
# in my opinion. 

last_year_plan_data <- last_year_plan_data |> 
  mutate(key_field = paste0(associated_org,
                            dimension_id,
                            planning_ref,
                            measure_id))

h2_data_2324_mapping <- h2_data_2324_mapping |> 
  mutate(key_field = paste0(org_code,
                            dimension_id,
                            planning_ref,
                            measure_id))

# now to combine the frames together

final_2324_plans <- full_join(last_year_plan_data,
               h2_data_2324_mapping,
               by = 'key_field')

# now coalesce the shared fields with the h2 data taking primacy 
# then remove the columns that held the coalesced data and some other 
# unneeded columns

final_2324_plans <- final_2324_plans |> mutate(
  org_code = coalesce(org_code,associated_org),
  metric_value = coalesce(metric_value.y,metric_value.x),
  measure_id = coalesce(measure_id.y,measure_id.x),
  dimension_id = coalesce(dimension_id.y,dimension_id.x),
  measure_type = coalesce(measure_type.y,measure_type.x),
  source = coalesce(source.y,source.x),
  ics_code = coalesce(ics_code,selected_ccg),
  planning_ref = coalesce(planning_ref.y,planning_ref.x),
  measure_name = coalesce(measure_name.y,measure_name.x)) |> 
  select(-c(associated_org,
            metric_value.y,
            metric_value.x,
            measure_id.y,
            measure_id.x,
            dimension_id.y,
            dimension_id.x,
            measure_type.y,
            measure_type.x,
            source.y,
            source.x,
            selected_ccg,
            planning_ref.y,
            planning_ref.x,
            measure_name.y,
            measure_name.x,
            key_field,
            collection_id_k,
            time_stamp)) 

# now we need a lookup to sort out the date field for monthly data

date_lookup <- final_2324_plans |> 
  select(dimension_name,
         dimension_id) |>
  unique() |> 
  filter(dimension_id < 1123 & !is.na(dimension_name)) |> 
  mutate(month_commencing = as.Date(paste0('01',dimension_name),
                                    format = '%d %B %Y')) 

# merge that with the dataframe to give us a consistent date field for 
# monthly metrics

final_2324_plans <- left_join(final_2324_plans,
                              date_lookup,
                              by = "dimension_id") |> 
  select(-dim_date_start)

rm(date_lookup)

# coalesce the dimension names to have consistent names for monthly, quarterly 
# and annual

final_2324_plans <- final_2324_plans |> 
  mutate(dimension_name = coalesce(dimension_name.y,dimension_name.x)) |> 
  select(-c(dimension_name.y,dimension_name.x))

# now we need to rework the dimension type field to account for the additional 
# monthly metrics from H2

final_2324_plans <- final_2324_plans |> 
  mutate(dimension_type = case_when(
    !is.na(dimension_type) ~ dimension_type,
    !is.na(month_commencing) ~ 'Month'
    ))

#remove the old org short name column and replace it because the current one has 
# gaps. 
# Since we are tidying up we might as well do a thorough job of it:

# measure_source is all activity or NA so we can remove that
# comments is not null but they're so outdated that we are not going to use them
# in our final output
# component type does the same job as measure type so we will get rid of it
# likewise activity category is a less populated measure subject

final_2324_plans <- final_2324_plans |> 
  select(-c(measure_source,
            comments,
            component_type,
            activity_category))

# now we add in the org short name 

source('rscripts\\gen_tools_and_fns\\fn_short_org_names.R')

final_2324_plans <- fn_short_org_names(final_2324_plans,'org_code')


