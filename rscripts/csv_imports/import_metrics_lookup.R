#This script checks whether there is a single previous year plans file in the csv_exports folder
#If there is, it imports the file as a dataframe, if not it raises an error warning the user
#that they have multiple copies of the previous plan file and asking them to move old copies 
#into the archive

if (length(list.files('csv_exports',pattern = 'metrics_lookup', ignore.case = TRUE)) == 1) {
  file_name <- list.files('csv_exports',pattern = 'metrics_lookup', ignore.case = TRUE)
  
  metrics_lookup <- read_csv(paste0('csv_exports/',file_name))

  rm(file_name)
  
} else if (length(list.files('csv_exports',pattern = 'metrics_lookup', ignore.case = TRUE)) > 1) {
  cat(paste0('Please ensure only one metrics_lookup data file is in the csv_exports folder, ',
      'archive duplicates and old versions\nmetrics_lookup not imported'))  
} else {
  cat('No metrics_lookup file found in csv_exports folder,\nmetrics_lookup data not imported')  
  }


