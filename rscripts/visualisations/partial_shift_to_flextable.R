

df <- trimmed_df
plan_ref <- 'E.M.29'
m_type <- 'Percentage'
over_colour <- 'red'
under_colour <- 'blue'

# Filter the plan vs actual data to that grouping and rename the activity columns
df_x <- df |> 
  filter(planning_ref == plan_ref,
         measure_type == m_type) |>
  select(-c(planning_ref,measure_type)) |> 
  rename('plan' = planned_activity,
         'actual' = actual_activity)

# If the data is percentages or rates multiply by 100
# If the data is mean time ############JOHN ADD THIS IN #########
# Otherwise present as submitted
if (m_type %in% c('Percentage','Rate')){
 df_x <-  df_x |> mutate(plan = plan*100,
                 actual = actual*100)
} else {df_x}


# create an object to be the table title
table_title <- paste0(plan_ref,": ",unique(df_x$measure_name))

# we don't need row level measure names any more

df_x <- df_x |> select(-c(measure_name))

# now creating the variance and pivoting, we need to use the names_glue so that 
# the month is a prefix and not a suffix after pivoting
# this will allow separate header to work properly

df_x <- df_x |> 
  mutate(variance = actual-plan) |> 
  pivot_wider(names_from = month_short_year,
              values_from = c(plan, actual, variance),
              names_vary = 'slowest',
              names_glue = "{month_short_year}_{.value}") |> 
  arrange(org_short_name) |> 
  rename('Organisation' = org_short_name)

df_ncol <- ncol(df_x)

df_x <- flextable(df_x)

df_x <- df_x |> 
  colformat_double(
    j = 2:df_ncol,
    digits = 1,
    na_str = '',
    suffix = '%')

variance_locations <- grep('variance$', names(df_x$header$dataset))

for (i in 1:length(variance_locations)){
location_id <- variance_locations[i]  
location <- pull(df_x$header$dataset[location_id])
df_x <- df_x |> 
  color(
    i = df_x$body$dataset[location_id] <0,
    j = location,
    color = under_colour
  ) |> 
  color(
    i = df_x$body$dataset[location_id] >0,
    j = location,
    color = over_colour)
}

df_x <- separate_header(df_x) |> 
  align(align = 'left', part = 'all') |> 
  autofit()


df_x <- add_header_row(df_x,
                       values = table_title,
                       colwidths = df_ncol)

theme_vanilla(df_x)