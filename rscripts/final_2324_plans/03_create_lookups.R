##measure source is all Activity or NA so we can remove it
#unique(final_2324_plans$measure_source)
#unique(final_2324_plans$comments)
#unique(final_2324_plans$measure_subject)
#unique(final_2324_plans$activity_category)
#unique(final_2324_plans$component_type)
#unique(final_2324_plans$measure_type)

#Get the unique short names from the planning dataframe

short_name_lookup <- final_2324_plans |> 
  select(c(planning_ref,short_name)) |> 
  unique()

# Append the list so that the references that were created in h2 and don't have
# short names get some

short_name_lookup$short_name[short_name_lookup$planning_ref == 'E.B.21'] <- 'RTT 78ww'
short_name_lookup$short_name[short_name_lookup$planning_ref == 'ERF'] <- 'ERF'
short_name_lookup$short_name[short_name_lookup$planning_ref == 'AmbHandover'] <- 'Avg Handover'
short_name_lookup$short_name[short_name_lookup$planning_ref == 'AmbHours'] <- 'Amb Deployed Hours'

short_name_lookup <- rename(short_name_lookup,measure_short_name = 'short_name')

# Same for measure subjects

measure_subject_lookup <- final_2324_plans |> 
  select(c(planning_ref,measure_subject)) |> 
  unique()

measure_subject_lookup$measure_subject[measure_subject_lookup$planning_ref == 'E.B.21'] <- 'Elective'
measure_subject_lookup$measure_subject[measure_subject_lookup$planning_ref == 'ERF'] <- 'Elective'
measure_subject_lookup$measure_subject[measure_subject_lookup$planning_ref == 'AmbHandover'] <- 'Ambulance'
measure_subject_lookup$measure_subject[measure_subject_lookup$planning_ref == 'AmbHours'] <- 'Ambulance'

# org name lookup

org_name_lookup <- final_2324_plans |> 
  select(org_code,org_name) |> 
  unique() |> 
  filter(!is.na(org_name))

# ics name lookup

ics_name_lookup <- final_2324_plans |> 
  select(ics_code,ics_name) |> 
  unique() |> 
  filter(!is.na(ics_name))

