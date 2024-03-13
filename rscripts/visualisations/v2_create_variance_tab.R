
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
                                     under_colour = 'black',
                                     over_colour = 'black'){
  
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
  
  # changing 'variance' to 'var' in order to save on width
  
  df_x <- df_x |> 
    mutate(variance = actual-plan)
  
  # now switch months to columns and values to rows
  
 df_x <-  df_x |> 
    pivot_longer(c(plan, actual, variance),names_to = 'observation',values_to = 'metric_value') |> 
    pivot_wider(names_from = month_short_year,
                values_from = metric_value) 
   
 df_x <- df_x |> arrange(org_short_name)
 
 df_x <- df_x |> rename('Organisation' = org_short_name)

  df_ncol <- ncol(df_x)
  name_vec <- names(df_x)
  df_x <- flextable(df_x)
  
  df_x <- df_x |> 
    colformat_double(
      j = 2:df_ncol,
      digits = 1,
      na_str = '',
      suffix = '%')
  
  
  ### need to set up if else that will colour the variable rows correctly
  
    df_x <- df_x |> 
      color(j = 3:df_ncol,
            i = ~observation == 'variance',
            color = function(x){
              out <- rep('black',length(x))
              out[x < 0] <- under_colour
              out[x > 0] <- over_colour
              out
            })

  df_x <- add_header_row(df_x,
                         values = table_title,
                         colwidths = df_ncol)
  
  df_x <- theme_vanilla(df_x)
  
  return(df_x)}
  
