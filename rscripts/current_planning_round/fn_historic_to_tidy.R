#' This function takes in a historic data frame created by fn_historic_df_cleanup.R 
#' then removes the Latest_actuals column and pivots everything to longer and 
#' returns the pivoted dataframe
#' 
#' @param df the dataframe to be tidied
#' @returns the tidied dataframe

historic_to_tidy <- function(df){
# Remove latest actuals column because not needed
df <- df |> 
  select(!c(Latest_actuals))

# Get the number of columns in the dataframe
col_count <- ncol(df)

# Measure type is the last column before the activity months start 
# So we want the index of that 

mtype_index <- which(names(df) == 'MeasureType')

# pivot the historic dataframe from wide to long
df <- df |> 
  pivot_longer(cols = !c(1:all_of(mtype_index)),
               names_to = 'dimension_name',
               values_to = 'value')
return(df)
}