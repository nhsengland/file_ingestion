fn_4_hour <- function(data,new_measure_name){
  
 trust <-  data %>%   
   group_by(across(c(-metric_value))) %>% 
   summarise(metric_value = sum(metric_value),.groups='keep') %>% 
   ungroup() %>% 
   mutate(measure_name = new_measure_name) 

 icb <- trust %>% 
   select(!c(org_code,org_name)) %>% 
   group_by(across(c(-metric_value))) %>% 
   summarise(metric_value = sum(metric_value),.groups='keep') %>% 
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
     measure_type,
     metric_name,
     metric_value,
     measure_name) 

x <- bind_rows(icb,trust)
 
x <- x %>% 
   pivot_wider(
     id_cols =c(
       ics_code,
       ics_name,
       org_code,
       org_name,
       dimension_id,
       dim_date_start,
       planning_ref,
       measure_name,
       metric_name),
     names_from = measure_type,
     values_from = metric_value
   ) %>% 
   mutate(metric_value = Numerator/Denominator) %>% 
   select(!c(Numerator,
             Denominator)) %>% 
   mutate(measure_type = 'percentage',
          measure_id = NA) %>% 
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
 
 return(x)
  
}