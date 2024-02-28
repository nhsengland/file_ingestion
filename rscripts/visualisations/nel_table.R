# NEL metrics
# Counts

# E.M.11 # Total NEL
# E.M.11a # Total NEL 0 LOS 
# E.M.11b # Total NEL >=1 LOS
# E.M.25 # avg no. patients with LOS >=21

# Percentages  

# E.M.29  # % occupied by NCTR 

# Identify the planning references relevant to NELs and what measure type you need

count_references <- c('E.M.11','E.M.11a','E.M.11b','E.M.25')
perc_references <- c('E.M.29')

# Filter the plan vs actual data to that grouping

nel <- historic_monthly_pva |> 
  filter(((planning_ref %in% count_references & measure_type == 'Count')|
           (planning_ref %in% perc_references & measure_type == 'Percentage')) &
           fin_year == '2023-24' & 
           month_commencing < '2024-01-01') |> 
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
              names_vary = 'slowest') |> 
  arrange(planning_ref,
          icb_code,
          org_short_name)


nel |> 
  gt() |> 
  fmt_number(
    columns = starts_with(c('planned','actual','variance')),
    rows = measure_type == 'Count',
    decimals = 0) |> 
  fmt_percent(
    columns = starts_with(c('planned','actual','variance')),
    rows = measure_type == 'Percentage',
    decimals = 1
  )
