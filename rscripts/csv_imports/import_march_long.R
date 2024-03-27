#This script checks whether there is a single march_24_pva file in the csv_exports folder
#If there is, it imports the file as a dataframe, if not it raises an error warning the user
#that they have multiple copies of the previous plan file and asking them to move old copies 
#into the archive

if (length(list.files('csv_exports',pattern = 'march_24_pva', ignore.case = TRUE)) == 1) {
  file_name <- list.files('csv_exports',pattern = 'march_24_pva', ignore.case = TRUE)
  
  march_24_pva <- read_csv(paste0('csv_exports/',file_name))
 
  rm(file_name)

} else if (length(list.files('csv_exports',pattern = 'march_24_pva', ignore.case = TRUE)) > 1) {
  cat(paste0('Please ensure only one march_24_pva data file is in the csv_exports folder, ',
      'archive duplicates and old versions\nmarch_24_pva data not imported'))  
} else {
  cat('No march_24_pva data file found in csv_exports folder,\nmarch_24_pva data not imported')  
  }


