# measure subject and short name need some tidying up 
# because we have blanks from H2 but we will probably want them 
# as useful ways to divide the data up.
# we are going to want to rename short name to make it more meaningful

final_2324_plans <- left_join(final_2324_plans,
                              short_name_lookup,
                              by = 'planning_ref') |> 
  select(-short_name)

rm(short_name_lookup)

final_2324_plans <- left_join(final_2324_plans,
                              measure_subject_lookup,
                              by = 'planning_ref') |> 
  select(-measure_subject.x) |> 
  rename(measure_subject = measure_subject.y)

rm(measure_subject_lookup)

# we are also going to need to redo the org name and ics name columns, because 
# they have gaps from inconsistencies between h2 and may

final_2324_plans <- left_join(final_2324_plans,
                              ics_name_lookup,
                              by = 'ics_code') |> 
  select(-ics_name.x) |> 
  rename(ics_name = ics_name.y)

rm(ics_name_lookup)

final_2324_plans <- left_join(final_2324_plans,
                              org_name_lookup,
                              by = 'org_code') |> 
  select(-org_name.x) |> 
  rename(org_name = org_name.y)

rm(org_name_lookup)

# there was an inconsistency between h2 and the main submissions for E.B.23c 
# measure type and measure name don't match, this needs to be fixed

final_2324_plans <- final_2324_plans |> 
  mutate(measure_type = case_when(planning_ref == 'E.B.23c' ~ 'Mean',
                                  .default = measure_type),
         measure_name = case_when(planning_ref == 'E.B.23c' ~ 'Ambulance Response Times - Category 2 (minutes)',
                                  .default = measure_name))


# finally we move the field names around so that the dataframe makes sense to 
# my brain

final_2324_plans <- final_2324_plans |> 
  select(ics_code,
         ics_name,
         icb_short_name,
         org_code,
         org_name,
         org_short_name,
         secondary_assoc_org,
         dimension_id,
         dimension_name,
         month_commencing,
         dimension_type,
         measure_id,
         planning_ref,
         measure_subject,
         measure_short_name,
         measure_name,
         component_name,
         granularity,
         source,         
         measure_type,
         metric_value)

#cleanup remaining objects

rm(
  h2_data,
  h2_data_2324_mapping,
  col_list,
  submission_folder,
  fn_short_org_names,
  last_year_plan_data)
