# Script to read the submitted planning files and extract the three historic
# data tabs.
#
# We are doing this as a separate script to the current year submissions so that
# if the historic data fails, we will still be able to proceed with the phase 1
# i.e. current plan data.

# set the names and column types for the historic data tabs 
# at time of writing these are based on the 2023/24 submission format and are 
# not expected to change for 24/25 but can be configured here if changes are made

historic_tab_name = 'HistoricData'

provcomm_tab_name = 'HistoricData_Prov_comm'

icb_tab_name = 'HistoricData_ICB_comm'

# get all of the file names from the datafiles folder
file_names <- list.files(submission_folder,pattern = 'xlsm', ignore.case = TRUE)

# remove the file extension
file_names <- str_remove(file_names,'.xlsm')

# find out how many file names you have
n_file_names <- length(file_names)

# set up three empty lists to feed with a for loop
historic_data_list <- list()
provcomm_data_list <- list()
icb_data_list <- list()

# Set up three empty vectors for an equality check. In theory every file will 
# have all of the data for the entire country, so we need to ensure that 
# everything that is extracted has the same number of rows

historic_rowcount <- vector()
provcomm_rowcount <- vector()
icb_rowcount <- vector()
  
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
    provcomm <- read_excel(file.path(submission_folder,paste0(file,".xlsm")),
                       sheet = provcomm_tab_name ,
                       col_types = 'text',
                       na = c('','NA'))
    icbcomm <- read_excel(file.path(submission_folder,paste0(file,".xlsm")),
                           sheet = icb_tab_name ,
                           col_types = 'text',
                           na = c('','NA'))
    # put the data tables into container lists
    historic_data_list[[i]] <- historic_dt
    provcomm_data_list[[i]] <- provcomm
    icb_data_list[[i]] <- icbcomm
    # record the number of rows in each data table
    historic_rowcount[[i]] <- nrow(historic_dt)
    provcomm_rowcount[[i]] <- nrow(provcomm)
    icb_rowcount[[i]] <- nrow(icbcomm)
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

historic_prov_data <- unlist_data(historic_rowcount,historic_data_list)
historic_provcomm_data <- unlist_data(provcomm_rowcount,provcomm_data_list)
historic_icb_data <- unlist_data(icb_rowcount,icb_data_list)

# filter everything down to just the region you are interested in

historic_prov_data <- historic_prov_data |> 
  filter(RegionCode == region_code) 
historic_provcomm_data <- historic_provcomm_data |> 
  filter(RegionCode == region_code) 
historic_icb_data <- historic_icb_data |> 
  filter(RegionCode == region_code) 

# move the ISP_NHS column in the two tables that have it

historic_provcomm_data <- historic_provcomm_data |> 
  relocate(ISP_NHS,.before = MeasureType)

historic_icb_data <- historic_icb_data |> 
  relocate(ISP_NHS,.before = MeasureType)

# create an ISP_NHS column in the one that does not have it
historic_prov_data <- historic_prov_data |> 
  mutate(ISP_NHS = NA) |> 
  relocate(ISP_NHS,.before = MeasureType)

# remove unneeded columns and convert to numeric

source('rscripts\\current_planning_round\\fn_historic_df_cleanup.R')

historic_prov_data <- historic_df_cleanup(historic_prov_data)
historic_provcomm_data <- historic_df_cleanup(historic_provcomm_data)
historic_icb_data <- historic_df_cleanup(historic_icb_data)

# pivot the historic data into a tidy format

source('rscripts\\current_planning_round\\fn_historic_to_tidy.R')

historic_prov_data <- historic_to_tidy(historic_prov_data)
historic_provcomm_data <- historic_to_tidy(historic_provcomm_data)
historic_icb_data <- historic_to_tidy(historic_icb_data)

# combine the individual datafames into a single frame
historic_actuals <- union(historic_prov_data,historic_provcomm_data)
historic_actuals <- union(historic_actuals,historic_icb_data)

# merge in the metrics lookup so that we have the measure names etc.
historic_actuals <- merge(historic_actuals, metrics_lookup, 
                     by = 'MeasureID',  all.x = TRUE)

# add in the short organisation names
source('rscripts\\gen_tools_and_fns\\fn_short_org_names.R')
historic_actuals <- fn_short_org_names(historic_actuals,'OrgCode')

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
icb_data_list,
icb_rowcount,
icb_tab_name,
icbcomm,
n_file_names,
provcomm,
provcomm_data_list,
provcomm_rowcount,
provcomm_tab_name,
submission_folder,
unlist_data,
historic_df_cleanup,
historic_to_tidy,
historic_prov_data,
historic_provcomm_data,
historic_icb_data,
metrics_lookup,
fn_short_org_names
)   
