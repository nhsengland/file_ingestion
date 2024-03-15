fn_syst_col_line_list <- function(df, 
                                  p_ref,
                                  mt,
                                  system,
                                  gd = 'decrease',
                                  bad_colour = 'red',
                                  good_colour = 'skyblue',
                                  neutral_colour = 'darkgrey'){
  chart_df <- df |> 
    filter(planning_ref == p_ref &
             measure_type == mt &
             icb_code == system &
             (!is.na(actual_activity)|!is.na(planned_activity))
    )
  
  orgs <- unique(as.character(chart_df$org_short_name))
  
  chart_list <- list()
  
  for (i in 1:length(orgs)){
    
    org_name <- orgs[i]
    
    chart_obj <- chart_df |> 
      filter(org_short_name == org_name)
    
    chart_list[[i]] <- fn_col_and_line_chart(chart_obj,
                                             goal_direction = gd)
  }
return(chart_list)  
}