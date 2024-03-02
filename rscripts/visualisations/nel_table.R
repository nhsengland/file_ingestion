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

over_good <- c()
under_good <- c('E.M.11','E.M.11a','E.M.11b','E.M.25','E.M.29')



# Set up factors for the organisation name and code
source('rscripts\\gen_tools_and_fns\\fn_orgs_to_factor.R')

historic_monthly_pva <- fn_orgs_to_factor(historic_monthly_pva,'org_code','org_short_name')

# create a calendar
source('rscripts\\gen_tools_and_fns\\calendar_builder.R')

# convert the date elements to factors
historic_monthly_pva <- historic_monthly_pva |> 
  mutate(fin_year = fct(fin_year,levels = unique(as.character(calendar$fin_year))),
         month_short_year = fct(month_short_year,levels = unique(as.character(calendar$month_short_year))))

# Filter the plan vs actual data to that grouping
nel <- historic_monthly_pva |> 
  filter(((planning_ref %in% count_references & measure_type == 'Count')|
           (planning_ref %in% perc_references & measure_type == 'Percentage')) &
           fin_year == '2023-24' & 
           month_commencing < '2024-01-01') |> 
  select(icb_code,
         org_short_name,
         planning_ref,
         measure_name,
         measure_type,
         month_short_year,
         planned_activity,
         actual_activity) 
# now we set up a list of unique month-years
month_list <- as.character(unique(nel$month_short_year))
# now we set up a vector of column headers we will put in to replace the 
# concatenated headers the pivot is about to create
col_heads <- c(rep(c('planned','actual','variance'),length(month_list)))

# now creating the variance and pivoting
  nel <- nel |> 
  mutate(variance = actual_activity-planned_activity) |> 
  pivot_wider(names_from = month_short_year,
              values_from = c(planned_activity, actual_activity, variance),
              names_vary = 'slowest') |> 
  arrange(planning_ref,
          icb_code,
          org_short_name)

# now we create the GT object and use the month list and col heads to create 
# spanner column labels and replace the current messy column labels
  
  ### tab style isn't working, something in the way I'm identifying rows is not happy
  
gt_obj <- nel |>
  gt(groupname_col = 'measure_name',
     rowname_col = 'icb_code') |> 
  tab_options(table.font.size = 12) |> 
  tab_style(
    style = list(
      cell_text(color = 'red')),
      locations = cells_body(
        columns = starts_with('variance'),
        rows = planning_ref %in% under_good & starts_with('variance') > 0|
                  planning_ref %in% over_good & starts_with('variance')< 0)
  ) |> 
#  tab_style(
#    style = list(
#      cell_text(color = 'blue'),
#      locations = cells_body(
#        columns = starts_with('variance'),
#        rows = ((planning_ref %in% under_good & starts_with('variance') < 0)|
#                  (planning_ref %in% over_good & starts_with('variance')> 0))
#      ))) |> 
  fmt_number(
    columns = starts_with(c('planned','actual','variance')),
    rows = measure_type == 'Count',
    decimals = 0) |> 
  fmt_percent(
    columns = starts_with(c('planned','actual','variance')),
    rows = measure_type == 'Percentage',
    decimals = 1)
# now we add a tab_spanner for each month  
for (i in 1:length(month_list)){
  gt_obj <- gt_obj |> 
    tab_spanner(label = month_list[i],
                columns = ends_with(month_list[i]))
}

# change the individual column names to something shorter
nel <- nel |> 
  cols_label(
    starts_with('planned') ~ 'Planned',
    starts_with('actual') ~ 'Actual',
    starts_with('variance') ~ 'Variance') 


gt_obj
