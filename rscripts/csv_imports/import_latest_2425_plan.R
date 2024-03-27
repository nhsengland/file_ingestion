#This script checks whether there is a single latest 2425 plans file in the csv_exports folder
#If there is, it imports the file as a dataframe, if not it raises an error warning the user
#that they have multiple copies of the latest 2425 plans file and asking them to move old copies 
#into the archive

if (length(list.files('csv_exports',pattern = 'latest_2425_plans', ignore.case = TRUE)) == 1) {
  file_name <- list.files('csv_exports',pattern = 'latest_2425_plans', ignore.case = TRUE)
  
  latest_plans_2425 <- read_csv(paste0('csv_exports/',file_name))

  rm(file_name)
  
} else if (length(list.files('csv_exports',pattern = 'latest_2425_plans', ignore.case = TRUE)) > 1) {
  cat(paste0('Please ensure only one latest 2425 plan data file is in the csv_exports folder, ',
      'archive duplicates and old versions\nlatest 2425 plan data not imported'))  
} else {
  cat('No latest 2425 plan data file found in csv_exports folder,\nlatest 2425 plan data not imported')  
  }


