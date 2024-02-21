#This script checks whether there is a single previous year plans file in the csv_exports folder
#If there is, it imports the file as a dataframe, if not it raises an error warning the user
#that they have multiple copies of the previous plan file and asking them to move old copies 
#into the archive

if (length(list.files('csv_exports',pattern = 'historic_actuals', ignore.case = TRUE)) == 1) {
  file_name <- list.files('csv_exports',pattern = 'historic_actuals', ignore.case = TRUE)
  
  historic_actuals <- read_csv(paste0('csv_exports/',file_name),
                               col_types = cols(month_commencing = col_date(format = '%Y-%m-%d')))
  rm(file_name)
} else if (length(list.files('csv_exports',pattern = 'historic_actuals', ignore.case = TRUE)) > 1) {
  cat(paste0('Please ensure only one historic_actuals file is in the csv_exports folder, ',
      'archive duplicates and old versions\nhistoric actuals not imported'))  
} else {
  cat('No historic_actuals file found in csv_exports folder,\nhistoric_actuals not imported')  
  }