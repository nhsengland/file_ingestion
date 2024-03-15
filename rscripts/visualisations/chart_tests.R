chart_df <- historic_monthly_pva |> 
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
           org_short_name == 'UHS' &
           !is.na(actual_activity))


UHS <- fn_col_and_line_chart(chart_obj)

