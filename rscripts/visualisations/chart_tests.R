source('rscripts\\gen_tools_and_fns\\fn_create_colour_vec.R')


chart_df <- historic_monthly_pva |> 
  filter(month_commencing < '2024-04-01') |> 
  select(icb_code,
         org_short_name,
         planning_ref,
         measure_name,
         measure_type,
         source,
         month_short_year,
         planned_activity,
         actual_activity) 

chart_obj <- chart_df |> 
  filter(planning_ref == 'E.M.29' &
           measure_type == 'Percentage' &
           org_short_name == 'BHT' &
           !is.na(actual_activity))

bad_color <- 'red'
good_color <-'skyblue'
neutral_color <- 'darkgrey'

fill_vector <- fn_create_colour_vec(chart_obj,'decrease',bad_color,good_color,neutral_color)
         
test_chart <- ggplot(chart_obj) +
  geom_col(aes(x = month_short_year, y = actual_activity), fill = fill_vector)+
  geom_line(aes(x = month_short_year, y = planned_activity, group = 1))+
  #geom_text(aes(x = month_short_year, y = planned_activity,label = round(planned_activity*100,digits = 1)))+
  scale_y_continuous(limits = c(0,max(chart_obj$actual_activity)+0.05),
                     breaks = seq(0:max(chart_obj$actual_activity)+0.05, by=0.05),
                     labels = scales::label_percent(accuracy = 1))+
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))




