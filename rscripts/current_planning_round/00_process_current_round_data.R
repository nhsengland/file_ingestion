# extract data
source('rscripts\\current_planning_round\\01_extract_plan_data.R')

# create metric lookup
source('rscripts\\current_planning_round\\02_create_metric_lookup.R')

# merge backing data with lookup, 
# this step also adds short names for systems and trusts
source('rscripts\\current_planning_round\\03_merge_plan_frames.R')

# extract the historic data
source('rscripts\\current_planning_round\\04_historic_data_extract_v2.R')

# transform plans and aggregate system level metrics where not available in source
source('rscripts\\current_planning_round\\05_create_planvhistoric.R')
