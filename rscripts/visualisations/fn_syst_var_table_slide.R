fn_syst_var_table_slide <- function(df,
                                    ppt_doc,
                                    p_ref,
                                    mt,
                                    system,
                                    gd = 'decrease'){
  

  df <- df |> 
    filter(planning_ref == p_ref &
             measure_type == mt &
             icb_code == system &
             !is.na(planned_activity))
  
  slide_title <- paste0(unique(df$planning_ref),": ",unique(df$measure_name)," ",unique(df$icb_short_name))
  
# create table
  var_table <- if(gd == 'decrease') {
    fn_create_variance_table(df,
                             plan_ref = p_ref,
                             measure_type = mt,
                             under_colour = 'blue',
                             over_colour = 'red')} else if (gd == 'increase') {
      fn_create_variance_table(df,
                               plan_ref = p_ref,
                               measure_type = mt,
                               under_colour = 'red',
                               over_colour = 'blue')  
    }

#create slide blank
  ppt_doc <- add_slide(ppt_doc, 
                       layout = 'tablex1',
                       master = "Custom Design")
#add title
  ppt_doc <- ph_with(ppt_doc, 
                     value = slide_title, 
                     location = ph_location_label(ph_label = "Title"))
#add table
    ppt_doc <- ph_with(ppt_doc,
                       value = var_table,
                       location = ph_location_label(ph_label = 'Table1'))
    ppt_doc
}