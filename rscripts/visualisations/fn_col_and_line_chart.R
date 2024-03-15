source('rscripts\\gen_tools_and_fns\\fn_create_colour_vec.R')

### JOHN SCALES Lable percent will need to be flexible

fn_col_and_line_chart <- function(chart_obj,
                                  bad_colour = 'red',
                                  good_colour = 'skyblue',
                                  neutral_colour = 'darkgrey',
                                  goal_direction = 'decrease'){
  
  title <- paste0(unique(chart_obj$planning_ref),": ",unique(chart_obj$measure_name)," - ",unique(as.character(chart_obj$org_short_name)))
  
  fill_vector <- fn_create_colour_vec(chart_obj,goal_direction,bad_colour,good_colour,neutral_colour)
  
  ggplot(chart_obj) +
  geom_col(aes(x = month_short_year, y = actual_activity), fill = fill_vector)+
  geom_line(aes(x = month_short_year, y = planned_activity, group = 1))+
  scale_y_continuous(limits = c(0,max(pmax(chart_obj$actual_activity, chart_obj$planned_activity, na.rm = TRUE))+0.05),
                     breaks = seq(0:max(pmax(chart_obj$actual_activity, chart_obj$planned_activity, na.rm = TRUE))+0.05, by=0.05),
                     labels = scales::label_percent(accuracy = 1))+
  ggtitle(title)+  
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
}




