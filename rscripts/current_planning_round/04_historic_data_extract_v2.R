# Script to read the submitted planning files and extract the historic
# data tabs.
#
# We are doing this as a separate script to the current year submissions so that
# if the historic data fails, we will still be able to proceed with the phase 1
# i.e. current plan data.

historic_tab_name = 'HistoricData'

# get all of the file names from the datafiles folder
file_names <- list.files(submission_folder,pattern = 'xlsm', ignore.case = TRUE)

# remove the file extension
file_names <- str_remove(file_names,'.xlsm')

# find out how many file names you have
n_file_names <- length(file_names)

# set up three empty lists to feed with a for loop
historic_data_list <- list()

# Set up three empty vectors for an equality check. In theory every file will 
# have all of the data for the entire country, so we need to ensure that 
# everything that is extracted has the same number of rows

historic_rowcount <- vector()

# set up a loop to extract the backing data and the control table from each file
# put the extracted tabs into the two lists
for (i in 1:n_file_names) {
  file <- file_names[[i]]
  # added error handing in case the structure of the file has changed since 
  # preparing this script
  tryCatch({
    historic_dt <- read_excel(file.path(submission_folder,paste0(file,".xlsm")),
                          sheet = historic_tab_name , 
                          col_types = 'text',
                          na = c('','NA'))
    # put the data tables into container lists
    historic_data_list[[i]] <- historic_dt
    # record the number of rows in each data table
    historic_rowcount[[i]] <- nrow(historic_dt)
    },
    error = function(e){
      warning(paste("Warning: Error reading data from file",file,":", e$message))
    })
}

# Here we are checking that the dataframes of the same type are all the same length
# In theory all of the historic data tabs are the same, so what the function
# does is extract all of the dataframes and then binding the unique rows.
# So if df[1] in the list is the same as all of the others, the script 
# will just drop the remaining dataframes. If they are not unique it will throw 
# an error.

source('rscripts\\gen_tools_and_fns\\fn_unlist_data.R')

historic_actuals <- unlist_data(historic_rowcount,historic_data_list)

# filter everything down to just the region you are interested in

historic_actuals <- historic_actuals |> 
  filter(RegionCode == region_code) 

# remove unneeded columns and convert to numeric

source('rscripts\\current_planning_round\\fn_historic_df_cleanup.R')

historic_actuals <- historic_df_cleanup(historic_actuals)

# pivot the historic data into a tidy format

source('rscripts\\current_planning_round\\fn_historic_to_tidy.R')

historic_actuals <- historic_to_tidy(historic_actuals)

# merge in the metrics lookup so that we have the measure names etc.
historic_actuals <- merge(historic_actuals, metrics_lookup, 
                     by = 'MeasureID',  all.x = TRUE)

# add in the short organisation names
source('rscripts\\gen_tools_and_fns\\fn_short_org_names.R')
historic_actuals <- fn_short_org_names(historic_actuals,'OrgCode')

# and the ICB short name

source('rscripts\\gen_tools_and_fns\\fn_icb_short_names.R')

historic_actuals <- fn_icb_short_names(historic_actuals,'ICBCode')

# clean up column names
historic_actuals <- clean_names(historic_actuals)

# cleanup unneeded objects

rm(
file,
file_names,
historic_data_list,
historic_dt,
historic_rowcount,
historic_tab_name,
i,
n_file_names,
submission_folder,
unlist_data,
historic_df_cleanup,
historic_to_tidy,
#metrics_lookup,
fn_short_org_names,
fn_icb_short_names
)   
