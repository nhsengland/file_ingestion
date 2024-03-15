fn_syst_chart_slide <- function(df, 
                                  ppt_doc,
                                  p_ref,
                                  mt,
                                  system,
                                  gd = 'decrease',
                                  bad_colour = 'red',
                                  good_colour = 'skyblue',
                                  neutral_colour = 'darkgrey'){
  df <- df |> 
    filter(planning_ref == p_ref &
             measure_type == mt &
             icb_code == system &
             (!is.na(actual_activity)|!is.na(planned_activity))
    )
  
  orgs <- unique(as.character(df$org_short_name))
  
  chart_list <- list()
  
  for (i in 1:length(orgs)){
    
    org_name <- orgs[i]
    
    chart_obj <- df |> 
      filter(org_short_name == org_name)
    
    chart_list[[i]] <- fn_col_and_line_chart(chart_obj,
                                             goal_direction = gd)
  }

  ppt_doc <- add_slide(ppt_doc, 
                       layout = paste0('chartx',length(chart_list)),
                       master = "Custom Design")
  
  for (i in 1:length(chart_list)){
    chart <- chart_list[[i]]
    
  ppt_doc <- ph_with(ppt_doc,chart, 
                     location = ph_location_label(ph_label = paste0("Chart",i)))
    
  }
  
  ppt_doc
}