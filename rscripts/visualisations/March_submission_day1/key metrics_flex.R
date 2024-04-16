source('rscripts\\csv_imports\\import_march_pivot.R')
source('rscripts\\csv_imports\\import_latest_2425_plan.R')
source('rscripts\\visualisations\\March_submission_day1\\EM13reshape.R')

#list of key metrics provided by Grace

key_metrics <- c(
# Primary care and community services
'E.D.19','E.D.21',
#UEC
'E.M.13','E.M.13a','E.M.13b',
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
  'Percentage','Percentage','Percentage',
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
  'Jan-24','Jan-24','Jan-24',
  # Elective - NB E.B.20 end date sept
  'Nov-23','Nov-23',
  # Cancer
  'Nov-23','Nov-23',
  # Diagnostics
  rep('Dec-23',9),
  # Mental Health
  'Nov-23','Sep-23','Sep-23','Nov-23'
  )

num_metrics <- length(key_metrics)

plan_months <- c(rep('Mar-25',6),'Sep-24',rep('Mar-25',num_metrics-6))
  
dfs_actuals <- list()
dfs_plans <- list()

for (i in 1:num_metrics) {
  date <- latest_dates[i]
  metric_id <- key_metrics[i]
  metric_type <- metric_types[i]
  plan_month <- plan_months[i]  
  
  df <-  m24_df |> 
    filter(activity_type == 'actual'&
             month_short_year == date &
             planning_ref == metric_id &
             measure_type == metric_type)
  
  dfs_actuals[[i]] <- df

  df2 <-  m24_df |> 
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
  select(-c(icb_code,
            icb_short_name,
            org_code,
            measure_short_name,
            source,
            measure_subject,
            activity_category,
            month_name,
            fin_year))


icb_vis <- key_metric_icb |> relocate(org_short_name,.before = activity_type)
icb_vis <- icb_vis |> relocate(measure_name,.after = planning_ref)

dates_table <- key_metric_icb |> select(planning_ref, measure_name, activity_type, month_short_year) |> unique()
dates_table <- dates_table |>  pivot_wider(names_from = activity_type,
                                          values_from = month_short_year)
dates_table <- dates_table |> rename('Latest actual' = actual,
                                     'Plan month' = plan,
                                     'Reference' = planning_ref,
                                     'Measure Name' = measure_name)

icb_vis <- icb_vis |> 
  select(-c(month_short_year)) |> 
  mutate(activity_type = case_when(activity_type == 'actual' ~ 'latest actual',
                                   .default = activity_type)) |> 
  pivot_wider(names_from = c(org_short_name,activity_type),
              values_from = metric_value,
              names_sort = TRUE)

icb_vis <- icb_vis |> rename('Ref' = planning_ref,
                             'Name' = measure_name)

visible_cols <- icb_vis |> select(-c(measure_type)) |> names()

ft_col <- length(visible_cols)

#need to make it smaller

icb_vis1 <- icb_vis |> filter(!Ref %in% c('E.B.27',
                                          'E.B.35',
                                          'E.B.28a',
                                          'E.B.28b',
                                          'E.B.28c',
                                          'E.B.28d',
                                          'E.B.28e',
                                          'E.B.28f',
                                          'E.B.28g',
                                          'E.B.28h',
                                          'E.B.28k'))

icb_vis1 <- icb_vis1 |> 
  arrange(Ref)

icb_vis2 <- icb_vis |> filter(Ref %in% c('E.B.27',
                                          'E.B.35',
                                          'E.B.28a',
                                          'E.B.28b',
                                          'E.B.28c',
                                          'E.B.28d',
                                          'E.B.28e',
                                          'E.B.28f',
                                          'E.B.28g',
                                          'E.B.28h',
                                          'E.B.28k'))

icb_flex1 <- flextable(icb_vis1,
                      col_keys = visible_cols)

icb_flex1 <- icb_flex1 |> 
    colformat_double(
      j = 2:ft_col,
      i = ~measure_type == 'Percentage',
      digits = 1,
      na_str = '',
      suffix = '%')
  
icb_flex1 <- icb_flex1 |> 
  colformat_double(
    j = 2:ft_col,
    i = ~measure_type == 'Count',
    digits = 0,
    na_str = '')

icb_flex1 <- separate_header(icb_flex1)

icb_flex1 <- theme_box(icb_flex1) |> 
  align(align = 'center',
        part = 'header')

icb_flex1 <- fontsize(icb_flex1,size = 10, part = 'all') 
icb_flex1 <- hrule(icb_flex1,rule = 'exact', part = 'body') 
icb_flex1 <- padding(icb_flex1,padding.top = 0,padding.bottom = 0, part = 'all')
icb_flex1 <- width(icb_flex1,j = 1, width = 1.5, unit = 'cm')
icb_flex1 <- width(icb_flex1,j = 2, width = 5, unit = 'cm')
icb_flex1 <- width(icb_flex1,j = c(3:ft_col),width = 1.7, unit = 'cm')
icb_flex1 <- bg(icb_flex1,bg = '#005eb8', part = 'header')
icb_flex1 <- color(icb_flex1,color = 'white', part = 'header')

######

icb_flex2 <- flextable(icb_vis2,
                       col_keys = visible_cols)

icb_flex2 <- icb_flex2 |> 
  colformat_double(
    j = 2:ft_col,
    i = ~measure_type == 'Percentage',
    digits = 1,
    na_str = '',
    suffix = '%')

icb_flex1 <- icb_flex1 |> 
  colformat_double(
    j = 2:ft_col,
    i = ~measure_type == 'Count',
    digits = 0,
    na_str = '')

icb_flex2 <- separate_header(icb_flex2)

icb_flex2 <- theme_box(icb_flex2) |> 
  align(align = 'center',
        part = 'header')

icb_flex2 <- fontsize(icb_flex2,size = 10, part = 'all') 
icb_flex2 <- hrule(icb_flex2,rule = 'exact', part = 'body') 
icb_flex2 <- padding(icb_flex2,padding.top = 0,padding.bottom = 0, part = 'all')
icb_flex2 <- width(icb_flex2,j = 1, width = 1.5, unit = 'cm')
icb_flex2 <- width(icb_flex2,j = 2, width = 7, unit = 'cm')
icb_flex2 <- width(icb_flex2,j = c(3:ft_col),width = 1.7, unit = 'cm')
icb_flex2 <- bg(icb_flex2,bg = '#005eb8', part = 'header')
icb_flex2 <- color(icb_flex2,color = 'white', part = 'header')

######
dates_flex <- flextable(dates_table)
dates_flex <- fontsize(dates_flex,size = 10, part = 'all') 
dates_flex <- padding(dates_flex,padding.top = 0,padding.bottom = 0, part = 'all')
dates_flex <- width(dates_flex,j = 2, width = 10, unit = 'cm')
dates_flex <- theme_box(dates_flex)
dates_flex <- bg(dates_flex,bg = '#005eb8', part = 'header')
dates_flex <- color(dates_flex,color = 'white', part = 'header')