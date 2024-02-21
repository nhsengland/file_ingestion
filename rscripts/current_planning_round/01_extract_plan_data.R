
# Script to read the submitted planning files and extract the backing data
# and the control tabs.

# set the names and column types for the control tabs and the backing data
# at time of writing these are based on the 2023/24 submission format and are 
# not expected to change for 24/25 but can be configured here if changes are made

backing_tab_name = 'BackSheet'

control_tab_name = 'ControlTable'

backing_data_col_types <- c("text","text","text","text","numeric",
                            "text","text","text","numeric","text",
                            "text","numeric","text","date")

control_col_types <- c("text", "text", "text", "text", "text", "text", 
                       "text", "text", "text", "text", "text", 
                       "text", "text", "text", "text", "text", 
                       "text", "numeric", "numeric", "numeric", 
                       "numeric", "text", "numeric", "text", 
                       "text", "text", "text", "text", "text", 
                       "text")

# get all of the file names from the datafiles folder
file_names <- list.files(submission_folder,pattern = 'xlsm', ignore.case = TRUE)

# remove the file extension
file_names <- str_remove(file_names,'.xlsm')

# find out how many file names you have
n_file_names <- length(file_names)

# set up two empty lists to feed with a for loop
backing_data_list <- list()
control_tab_list <- list()

# set up a loop to extract the backing data and the control table from each file
# put the extracted tabs into the two lists
for (i in 1:n_file_names) {
  file <- file_names[[i]]
  # added error handing in case the structure of the file has changed since 
  # preparing this script
  tryCatch({
  back_dt <- read_excel(file.path(submission_folder,paste0(file,".xlsm")),
                        sheet = backing_tab_name , 
                        col_types = backing_data_col_types,
                        na = c('','NA'))
  ctrl <- read_excel(file.path(submission_folder,paste0(file,".xlsm")),
                     sheet = control_tab_name ,
                     col_types = control_col_types,
                     na = c('','NA'))
  backing_data_list[[i]] <- back_dt
  control_tab_list[[i]] <- ctrl}, error = function(e){
    warning(paste("Warning: Error reading data from file",file,":", e$message))
  })
}

# now we're combining the individual dataframes in the list into a single frame
# we are doing this outside the loop because binding rows is resource hungry so
# it is much faster to do it once rather than every time the loop runs

backing_data <- bind_rows(backing_data_list)
control_tab <- unique(bind_rows(control_tab_list))

#rename the values column because its weird at the moment
backing_data <- backing_data |>  dplyr::rename(metric_value = `Data:N`)

cat(n_file_names,"Excel files processed. Backing tabs and control tab data extracted.\n")

# clean up unneeded objects
rm(back_dt,
   backing_data_list,
   control_tab_list,
   ctrl,
   backing_data_col_types,
   backing_tab_name,
   control_col_types,
   control_tab_name,
   file,
   file_names,
   i,
   n_file_names)