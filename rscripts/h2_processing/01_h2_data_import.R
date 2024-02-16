
submissions <- list.files("datafiles/02H2_updates_2324", pattern = '*.xlsm') %>% 
  str_remove('.xlsm')

h2_data <- data.frame()

for (file in submissions) {
  temp_df <-  read_excel(paste0("datafiles/02H2_updates_2324/",file,".xlsm"), 
                          sheet = "PlanData", 
                          col_types = 'text',
                          col_names = c('RegionName','RegionCode','ICSCode','ICSName',
                                        'OrgCode','OrgName','DimensionID','DimDateStart',
                                        'DimensionName','PlanningRef','MeasureID','MeasureName',
                                        'MeasureType','Value_Actuals','Value_Plans','OriginalBedCore',
                                        'OriginalBedEsc','OriginalBedAddedEsc','OrgCodeCalc','Plan_restated',
                                        'RestatedBedCore','RestatedBedEsc','RestatedBedAddedEsc',
                                        'helper 1','helper 2','helper 3'),
                          skip=1) %>%
           clean_names() %>% 
           filter(ics_code == file)

h2_data <- bind_rows(h2_data,temp_df)

}

rm(file,temp_df,submissions)