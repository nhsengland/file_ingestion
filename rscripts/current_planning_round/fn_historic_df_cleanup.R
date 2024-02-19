#' This function is used to clean up the data frames that were created from the
#' three "Historic" tabs in the icb submission files. 
#' 
#' It removes columns that are there for used in the planning team's processing 
#' workflow and some columns created during the import process itself.
#' 
#' It then converts the monthly, quarterly and annual data to numeric, having 
#' been imported as text to allow for a consistent import process
#' 
#' @param df A dataframe created from the historic tabs in the icb submission
#' files
#' 
#' @return Returns the same dataframe with some columns removed and activity
#' values converted from text to numeric



historic_df_cleanup <- function(df) {
  # Remove unneeded columns
  df <- df |> 
    select(!matches("^\\.{3}")) |> 
    select(!matches("^Concat")) 
  
  # Convert everything after the latest actuals column to numeric. This will get 
  # a warning about introducing NA values due to conversion, but comparing the 
  # before and after files this does not appear to change the count of valid values 
  # or the totals
  col_count <- ncol(df)
  col_index <-  which(names(df) == 'Latest_actuals')
  df <- df |> 
    mutate(across(all_of(col_index:col_count), as.numeric))
  return(df)
}



