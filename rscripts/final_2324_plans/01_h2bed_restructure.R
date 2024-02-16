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




