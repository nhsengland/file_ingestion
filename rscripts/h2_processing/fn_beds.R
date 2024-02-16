fn_beds <- function(data,metric_name_1,metric_name_2,new_measure_name){
  trust <- data %>% 
    filter(planning_ref %in% c('E.M.30a','E.M.30b') & 
             metric_name %in% c(metric_name_1,metric_name_2)) %>% 
    select(!c(measure_id,measure_name,planning_ref)) %>% 
    group_by(across(c(-metric_value))) %>% 
    summarise(metric_value = sum(metric_value),.groups ="keep") %>% 
    ungroup() %>%   
    mutate(metric_name = case_when(metric_name == metric_name_1 ~ 'value_plans',
                                   metric_name == metric_name_2 ~ 'plan_restated'),
           planning_ref = 'E.M.30',
           measure_name = new_measure_name,
           measure_id = NA) 
  
icb <- trust %>% 
    select(!c(org_code,org_name)) %>% 
    group_by(across(c(-metric_value))) %>% 
    summarise(metric_value = sum(metric_value),.groups ="keep") %>% 
    ungroup() %>% 
    mutate(org_code = ics_code,
           org_name = ics_name) %>% 
    select(
      ics_code,
      ics_name,
      org_code,
      org_name,
      dimension_id,
      dim_date_start,
      planning_ref,
      measure_id,
      measure_name,
      measure_type,
      metric_name,
      metric_value
    )
  
  x <- bind_rows(icb,trust)  
  
  return(x)
}