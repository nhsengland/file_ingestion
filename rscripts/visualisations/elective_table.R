# to do - set up icb and provider as factors


demo_table <- monthly_pva |> 
  filter(fin_year == '2023-24' & 
           month_commencing < '2024-01-01' &
           measure_id != 2055 &
           measure_type == 'Count'&
           activity_category == 'Electives') |> 
  select(icb_code,
         org_short_name,
         activity_category,
         planning_ref,
         measure_name,
         measure_type,
         month_commencing,
         planned_activity,
         actual_activity) |> 
  mutate(variance = planned_activity-actual_activity) |> 
  pivot_wider(names_from = month_commencing,
              values_from = c(planned_activity, actual_activity, variance),
              names_vary = 'slowest')

