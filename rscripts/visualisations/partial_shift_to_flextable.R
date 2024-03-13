install.packages('flextable')
library(flextable)

df <- trimmed_df
plan_ref <- 'E.M.29'
m_type <- 'Percentage'

# Filter the plan vs actual data to that grouping
df_x <- df |> 
  filter(planning_ref == plan_ref,
         measure_type == m_type) |>
  select(-c(planning_ref,measure_type))

# now we set up a list of unique month-years
month_list <- as.character(unique(df_x$month_short_year))

# create an object to be the table title
table_title <- unique(df_x$measure_name)

# we don't need row level measure names any more

df_x <- df_x |> select(-c(measure_name))

# now we set up a vector of column headers we will put in to replace the 
# concatenated headers the pivot is about to create
col_heads <- c(rep(c('planned','actual','variance'),length(month_list)))

# now creating the variance and pivoting
df_x <- df_x |> 
  mutate(variance = actual_activity-planned_activity) |> 
  pivot_wider(names_from = month_short_year,
              values_from = c(planned_activity, actual_activity, variance),
              names_vary = 'slowest') |> 
  arrange(org_short_name)

# now we store the number of columns so that we can reference it when creating 
# a header row

df_x_ncol <- ncol(df_x)

df_x <- flextable(df_x)

df_x <- add_header_row(df_x,
                       values = table_title,
                       colwidths = df_x_ncol)

# now get a list of where the variance columns are

variance_locations <- grep('^variance', names(df_x$header$dataset))

