fn_syst_chart_slide <- function(df, 
                                  ppt_doc,
                                  p_ref,
                                  mt,
                                  system,
                                  gd = 'decrease',
                                  bad_colour,
                                  good_colour,
                                  neutral_colour){
  
  source('rscripts\\visualisations\\fn_col_and_line_chart.R')
  df <- df |> 
    filter(planning_ref == p_ref &
             measure_type == mt &
             icb_code == system &
             (!is.na(actual_activity)|!is.na(planned_activity))
    )
  
  orgs <- unique(as.character(df$org_short_name))
  slide_title <- paste0(unique(df$planning_ref),": ",unique(df$measure_name)," providers in ",unique(df$icb_short_name))
  
  chart_list <- list()
  
#create charts  
  for (i in 1:length(orgs)){
    org_name <- orgs[i]
    chart_obj <- df |> 
      filter(org_short_name == org_name)
    chart_list[[i]] <- fn_col_and_line_chart(chart_obj,
                                             mt = mt,
                                             bad_colour = bad_colour,
                                             good_colour = good_colour,
                                             neutral_colour = neutral_colour,
                                             goal_direction = gd)
  }
#create slide blank
  ppt_doc <- add_slide(ppt_doc, 
                       layout = paste0('chartx',length(chart_list)),
                       master = "Custom Design")
#add title
  ppt_doc <- ph_with(ppt_doc, 
                     value = slide_title, 
                     location = ph_location_label(ph_label = "Title"))
#add charts  
  for (i in 1:length(chart_list)){
    chart <- chart_list[[i]]
    ppt_doc <- ph_with(ppt_doc,
                       value = chart,
                       location = ph_location_label(ph_label = paste0("Chart",i)))
  }
  
  ppt_doc
}