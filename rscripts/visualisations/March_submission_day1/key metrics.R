#list of key metrics provided by Grace

key_metrics <- c(
# Primary care and community services
'E.D.19','E.D.21',
#UEC
'E.M.13a','E.M.13b',
# Elective - NB E.B.20 end date sept
'E.B.3a','E.B.20',
# Cancer
'E.B.27','E.B.35',
# Diagnostics
'E.B.28a','E.B.28b','E.B.28c','E.B.28d','E.B.28e','E.B.28f',
'E.B.28g','E.B.28h','E.B.28k',
# Mental Health
'E.A.5','E.H.15','E.H.9','E.H.31')


metric_types <- c(
  # Primary care and community services
  'Count','Percentage',
  #UEC
  'Percentage','Percentage',
  # Elective - NB E.B.20 end date sept
  'Count','Count',
  # Cancer
  'Percentage','Percentage',
  # Diagnostics
  rep('Percentage',9),
  # Mental Health
  rep('Count',4))


latest_dates <- c(
  # Primary care and community services
  'Dec-23','Dec-23',
  #UEC
  'Jan-24','Jan-24',
  # Elective - NB E.B.20 end date sept
  'Nov-23','Nov-23',
  # Cancer
  'Nov-23','Nov-23',
  # Diagnostics
  rep('Dec-23',9),
  # Mental Health
  'Nov-23','Sep-23','Sep-23','Nov-23'
  )
  

plan_months <- c(rep('Mar-25',5),'Sep-24',rep('Mar-25',num_metrics-6))
  
  
dfs_actuals <- list()
dfs_plans <- list()




num_metrics <- length(key_metrics)

for (i in 1:num_metrics) {
  date <- latest_dates[i]
  metric_id <- key_metrics[i]
  metric_type <- metric_types[i]
  plan_month <- plan_months[i]  
  
  df <-  m24_for_customers |> 
    filter(activity_type == 'actual'&
             month_short_year == date &
             planning_ref == metric_id &
             measure_type == metric_type)
  
  dfs_actuals[[i]] <- df

  df2 <-  m24_for_customers |> 
    filter(activity_type == 'plan'&
             month_short_year == plan_month &
             planning_ref == metric_id &
             measure_type == metric_type)
  
  dfs_plans[[i]] <- df2
}

plans_df <- bind_rows(dfs_plans)

key_metric_df <- bind_rows(dfs_actuals,dfs_plans)

# Set up factors for the organisation name and code
source('rscripts\\gen_tools_and_fns\\fn_orgs_to_factor.R')

key_metric_df <- fn_orgs_to_factor(key_metric_df,'org_code','org_short_name')

# create a calendar
source('rscripts\\gen_tools_and_fns\\calendar_builder.R')

# convert the date elements to factors
key_metric_df <- key_metric_df |> 
  mutate(fin_year = fct(fin_year,levels = unique(as.character(calendar$fin_year))),
         month_short_year = fct(month_short_year,levels = unique(as.character(calendar$month_short_year))))

key_metric_df <- key_metric_df |> 
  mutate(metric_value = case_when(measure_type == 'Percentage' ~ metric_value*100,
                                  .default = metric_value))

measure_names <- key_metric_df |> filter(activity_type == 'plan') |> select(planning_ref,measure_name) |> unique()

key_metric_df <- key_metric_df |> select(-measure_name)

key_metric_df <- left_join(key_metric_df,
          measure_names,
          by = 'planning_ref')

key_metric_icb <- key_metric_df |> 
  filter(str_sub(org_code,1,1) == 'Q') |> 
  select(-c(measure_id,
            icb_code,
            icb_short_name,
            org_code,
            measure_short_name,
            source,
            measure_subject,
            activity_category,
            component_type,
            component_name,
            granularity,
            month_name,
            fin_year))


icb_vis <- key_metric_icb |> relocate(org_short_name,.before = activity_type)
icb_vis <- icb_vis |> relocate(measure_name,.after = planning_ref)

dates_table <- key_metric_icb |> select(measure_name, planning_ref, activity_type, month_short_year) |> unique()
dates_table <- dates_table |>  pivot_wider(names_from = activity_type,
                                          values_from = month_short_year)

icb_vis <- icb_vis |> 
  select(-c(month_short_year)) |> 
  pivot_wider(names_from = c(org_short_name,activity_type),
              values_from = metric_value,
              names_sort = TRUE)

  
  
  
  df2 <-  m24_for_customers |> 
  filter(activity_type == 'plan'&
           month_short_year == 'Sep-24' &
           planning_ref == 'E.B.20' &
           measure_type == 'Count')  