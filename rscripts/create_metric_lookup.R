# The control tab has multiple columns where a planning ref is collected as 
# numerator, denominator, count, etc. 
# In order to merge these with the backing data these need to be collapsed into long data

# Create a variable with the number of columns that are being merged
num_sets <- 4

# Create an empty list to store the dataframes
metrics_lookup_list <- list()

# Loop through each set of columns
# Removed measure name and dimension type at this stage,
# those fields exist in the backing data and I am giving them precedence
for (i in 1:num_sets) {
  columns_to_select <- c(
    'PlanningRef',
    'MeasureSubject',
   # 'MeasureName',
    'ActivityCategory',
    'ShortName',
    paste0('ComponentType', i),
    paste0('ComponentName', i),
    paste0('MeasureID', i),
   # 'DimensionType',
    'Granularity')
  
  # Create a new dataframe with selected columns
  current_df <- subset(control_tab, select = columns_to_select)
  
  # Rename columns by removing the number suffix
  colnames(current_df) <- sub(paste0(i, "$"), "", colnames(current_df))
  
  # Filter rows where MeasureID is not null
  current_df <- current_df[!is.na(current_df$MeasureID), ]
  
  # Store the dataframe in the list
  metrics_lookup_list[[i]] <- current_df
}

# Bind all dataframes together
metrics_lookup <- bind_rows(metrics_lookup_list)

rm(current_df,
   metrics_lookup_list,
   i,
   num_sets,
   columns_to_select,
   control_tab)

