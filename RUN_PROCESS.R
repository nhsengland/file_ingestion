# set the name of the folder you've stored the submissions in, 
# if you are not working in a project file you will need to put in the pathway
submission_folder = 'datafiles\\03Non_functional_template2425'
# set the region code for extract. 
# This is currently not being built with multiple regions in mind so if you have
# the plans for more than one region you would need to run this process multiple
# times, and it would be best to have each region's submissions in a different
# submission folder
region_code = 'Y59'
# load libraries
source('rscripts\\00_libraries.R')

## extract current planning round data - note if you want to export the plan 
## data to CSV you will need to un-comment the export script in the script below

#source('rscripts\\current_planning_round\\00_process_current_round_data.R')

##### Uncomment this section to save a plan only CSV
#source('rscripts\\export_scripts\\export_current_plans.R')
#source('rscripts\\export_scripts\\export_historic_actuals.R')

## If you have previously exported a current planning round csv and need to reuse
## the dataframe without extracting it all over again, you can extract the csv
## created above with this:

source('rscripts\\csv_imports\\import_latest_plan.R')
source('rscripts\\csv_imports\\import_historic_actuals.R')

# extract last year's plans

## If you need to run the full extract process uncomment and run these
## they will extract the last year plan data merge it with the h2 resubmissions
## transform the structure and output a csv that can be used in future:

#source('rscripts\\may_submission_2324\\00_process_may_submissions.R')

#source('rscripts\\h2_processing\\00_process_h2_submissions.R')

#source('rscripts\\final_2324_plans\\00_restructure_last_year_plans.R')

#source('rscripts\\export_scripts\\export_historic_plans.R')

## If you have last year's plan already prepped run this:

source('rscripts\\csv_imports\\import_last_year_plan.R')

rm(region_code,submission_folder)
