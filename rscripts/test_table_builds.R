table1 <- final_2324_plans |> ungroup()


metric_list <-  final_2324_plans |> 
  select(measure_subject,
         planning_ref,
         measure_short_name,
         measure_name,
         measure_type) |> 
  unique() |> 
  arrange(measure_subject,
          planning_ref)

#lets pull out a list of planning refs from 2324 and see what's in the historic actuals

final_2324_plan_refs <- unique(final_2324_plans$planning_ref)

a <- historic_actuals |> 
  filter(PlanningRef %in% final_2324_plan_refs)
  

# going to need to pull the dimension IDs out of the final 2324 plans and match them to the dimension names in the 
# historic actuals