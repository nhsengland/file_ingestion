# This function will create a conditionally formatted table showing variance 
# between plan and activity for a specific planning reference.
#
# It takes in a data frame,
# then filters it to the selected planning reference and measure type. 
# Calculates the variance between plan and actual.
# Widens it so that there is a column for each month of planned 
# and actual activity and the variance.

fn_create_variance_table <- function(df,
                                     planning_ref,
                                     measure_type,
                                     font_size = 12,
                                     under_colour = 'black',
                                     over_colour = 'black'){
plan_ref <- planning_ref
m_type <- measure_type
  
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

# now we create the GT object and use the month list and col heads to create 
# spanner column labels and replace the current messy column labels

gt_obj <- df_x |>
  gt(rowname_col = 'icb_code') |> 
  tab_header(title = table_title) |> 
  opt_align_table_header(align = 'left') |> 
  tab_options(table.font.size = font_size)

# now get a list of where the variance columns are

variance_locations <- grep('^variance', names(gt_obj$`_data`))

# now we conditionally format the variance locations 

for (location in 1:length(variance_locations)){
  variance_location <- variance_locations[location]
  col_name <- names(gt_obj$`_data`[variance_location])
  
  gt_obj <- gt_obj |> 
    tab_style(
      cell_text(color = over_colour),
      locations = cells_body(
        columns = col_name,
        rows = !!sym(col_name) > 0
      )
    )
  gt_obj <- gt_obj |> 
    tab_style(
      cell_text(color = under_colour),
      locations = cells_body(
        columns = col_name,
        rows = !!sym(col_name) < 0
      )
    )
}

# now we format the numbers according to the measure_type 

if (m_type == 'Count'){
gt_obj <- gt_obj |> 
  fmt_number(
    columns = starts_with(c('planned','actual','variance')),
    decimals = 0)} else if (m_type == 'Percentage') { 
      gt_obj <- gt_obj |>       
        fmt_percent(  
          columns = starts_with(c('planned','actual','variance')),
          decimals = 1)
      }

# now we add a tab_spanner for each month  
for (i in 1:length(month_list)){
  gt_obj <- gt_obj |> 
    tab_spanner(label = month_list[i],
                columns = ends_with(month_list[i]))
}

# change the individual column names to something shorter
gt_obj <- gt_obj |> 
  cols_label(
    starts_with('planned') ~ 'Planned',
    starts_with('actual') ~ 'Actual',
    starts_with('variance') ~ 'Variance',
    org_short_name = 'Organisation') 

return(gt_obj)
}
