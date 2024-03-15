# prep data frame

# Set up factors for the organisation name and code
source('rscripts\\gen_tools_and_fns\\fn_orgs_to_factor.R')

historic_monthly_pva <- fn_orgs_to_factor(historic_monthly_pva,'org_code','org_short_name')

# create a calendar
source('rscripts\\gen_tools_and_fns\\calendar_builder.R')

# convert the date elements to factors
historic_monthly_pva <- historic_monthly_pva |> 
  mutate(fin_year = fct(fin_year,levels = unique(as.character(calendar$fin_year))),
         month_short_year = fct(month_short_year,levels = unique(as.character(calendar$month_short_year))))






trimmed_df <- historic_monthly_pva |> 
  filter(fin_year == '2023-24' & month_commencing < '2024-01-01') |> 
  select(org_short_name,
         planning_ref,
         measure_name,
         measure_type,
         month_short_year,
         planned_activity,
         actual_activity) 


hiow_df <-  historic_monthly_pva |> 
  filter(fin_year == '2023-24' & 
          # month_commencing < '2024-01-01' &
           icb_code == 'QRL'&
         !is.na(planned_activity)) |> 
  select(org_short_name,
         planning_ref,
         measure_name,
         measure_type,
         month_short_year,
         planned_activity,
         actual_activity)