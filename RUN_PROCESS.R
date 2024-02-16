# set the name of the folder you've stored the submissions in, 
# if you are not working in a project file you will need to put in the pathway
submission_folder = 'datafiles'
# set the region code for extract. 
# This is currently not being built with multiple regions in mind so if you have
# the plans for more than one region you would need to run this process multiple
# times, and it would be best to have each region's submissions in a different
# submission folder
region_code = 'Y59'
# load libraries
source('rscripts\\libraries.R')
# extract data
source('rscripts\\extract_plan_data.R')
# create metric lookup
source('rscripts\\create_metric_lookup.R')
# merge backing data with lookup, 
# this step also adds short names for systems and trusts
source('rscripts\\merge_plan_frames.R')
# export plan data for basic csv
#source('rscripts\\export_phase_1.R')
# extract the historic data
source('rscripts\\historic_data_extract.R')
