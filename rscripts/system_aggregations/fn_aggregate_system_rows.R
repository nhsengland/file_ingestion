fn_aggregate_system_rows <- function(df,refs_to_exclude) {

  #excluded rows do not need aggregation, non-excluded rows do
  
  #remove excluded rows
  df2 <- df |> 
    filter(!planning_ref %in% refs_to_exclude)
  
  #list measure types
  measure_types <- unique(df2$measure_type)
  
  #widen using measure types so you can do a colwise aggregation
  df2 <- pivot_wider(df2,
                    names_from = measure_type,
                    values_from = metric_value)
  # remove identifiers that will prevent aggregation
  df2 <- df2 |> 
    select(-c(org_code,org_short_name))
  # group and aggregate
  df2 <- df2 |> 
    group_by(across(!one_of(measure_types))) |> 
    summarise(across(all_of(measure_types), 
                     ~sum(., na.rm = FALSE)),
                     .groups = 'drop')
  
  # replace identifiers with those of the groups they have been aggregated into
  df2 <- df2 |> 
    mutate(org_code = icb_code,
           org_short_name = icb_short_name)
  
  # move identifiers to where they are in the original dfs
  
  df2 <- df2 |> relocate(c(org_code,org_short_name),.after = icb_short_name)
  
  # lengthen it to match the original shape
  df2 <- df2 |> 
    pivot_longer(cols = all_of(measure_types),
                 names_to = 'measure_type',
                 values_to = 'metric_value',
                 values_drop_na = TRUE)
  
  # combine back together 
  df <- union_all(df,df2)
  

  
  return(df)
}

