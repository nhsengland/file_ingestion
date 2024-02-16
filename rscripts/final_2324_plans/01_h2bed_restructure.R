# add source column to h2 and last year's plan data
# select all unique rows in h2 based on org code
# identify the rows in last years plan that match those rows
# replace last year's metric value with the values from h2
# add in any unique h2 rows that didn't have an equivalent in the original 
# submission.

h2_data <- h2_data |> 
  mutate(source = 'H2 Submission')
last_year_plan_data <- last_year_plan_data |> 
  mutate(source = 'May Submission')

# this sequence combines together all of the bed occupancy denominators for the 
# h2 submissions. This aligns the metric to a single measure ID (consistent with
# other metrics), and means that it can be mapped into the original May submissions

# we didn't do this during the earlier h2 restructure step, because in the 24/25
# submissions there is a split between core and escalation beds, which h2 had but
# may 23/24 did not


h2_data_2324_mapping <- h2_data |> 
  select(-metric_name)

col_list <- h2_data_2324_mapping |> 
  select(-metric_value) |> 
  names()

h2_data_2324_mapping <- h2_data_2324_mapping |> 
  summarise(metric_value = sum(metric_value), .by = all_of(col_list))




