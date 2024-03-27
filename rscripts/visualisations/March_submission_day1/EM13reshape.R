source('rscripts\\csv_imports\\import_march_pivot.R')
source('rscripts\\csv_imports\\import_latest_2425_plan.R')
#source('rscripts\\system_aggregations\\fn_aggregate_system_rows.R')

m24_df <- m24_for_customers |> 
  select(-c(
    component_type,
    component_name,
    granularity,
    measure_id))

EM13s <- m24_df |> 
  filter(planning_ref %in% c('E.M.13a','E.M.13b')&
           !is.na(metric_value))

EM13names <- EM13s |> 
  filter(source == 'March24 plan') |> 
  select(planning_ref,
         measure_name,
         measure_type) |> 
  unique()

EM13p <- EM13s |> 
  filter(activity_type == 'plan')

EM13s <- EM13s |> 
  filter(activity_type == 'actual')

#list measure types
measure_types <- unique(EM13s$measure_type)

EM13s <- EM13s |> select(-c(measure_name))

#widen using measure types so you can do a colwise aggregation
EM13s <- pivot_wider(EM13s,
                   names_from = measure_type,
                   values_from = metric_value)
# remove identifiers that will prevent aggregation
EM13syst <- EM13s |> 
  select(-c(org_code,org_short_name))
# group and aggregate
EM13syst <- EM13syst |> 
  group_by(across(!one_of(measure_types))) |> 
  summarise(across(all_of(measure_types), 
                   ~sum(., na.rm = FALSE)),
            .groups = 'drop')

# replace identifiers with those of the groups they have been aggregated into
EM13syst <- EM13syst |> 
  mutate(org_code = icb_code,
         org_short_name = icb_short_name)

# move identifiers to where they are in the original dfs
EM13syst <- EM13syst |> relocate(c(org_code,org_short_name),.after = icb_short_name)

EM13syst <- EM13syst |> 
  mutate(Percentage = Numerator/Denominator)

# combine back together 
EM13ab <- union_all(EM13s,EM13syst)

# lengthen it to match the original shape
EM13ab <- EM13ab |> 
  pivot_longer(cols = all_of(measure_types),
               names_to = 'measure_type',
               values_to = 'metric_value',
               values_drop_na = TRUE)

EM13names <- EM13names |> 
  mutate(key = paste0(planning_ref,measure_type))

EM13ab <- EM13ab |> mutate(key = paste0(planning_ref,measure_type))

EM13ab <- left_join(EM13ab,
                    EM13names,
                    by = 'key',
                    keep = FALSE)

EM13ab <- EM13ab |> 
  select(!c(planning_ref.y,
            measure_type.y,
            key)) |> 
  rename(planning_ref = planning_ref.x,
         measure_type = measure_type.x)

#
m24_df <- m24_df |> 
  filter(!planning_ref %in% c('E.M.13a','E.M.13b'))

name_vec <- names(m24_df)

EM13ab <- EM13ab |> select(all_of(name_vec))
EM13p <- EM13p |> select(all_of(name_vec))

EM13 <- union_all(EM13ab,EM13p)

m24_df <- union_all(m24_df,EM13)

rm(measure_types,
   name_vec,
   EM13,
   EM13ab,
   EM13names,
   EM13s,
   EM13syst,
   EM13p)

