# This script will use a function to create a set of rows that give the percentages
# for metrics that are only ingested as individual numerator and denominator rows 
# in the main dataset.

# First we create two vectors:

# planning_references is a set of the planning references that have numerator and
# denominator in the dataset, but do not have the percentages within the ingested
# data. 

# measure_names is a set of names that will be given to the new percentage rows

planning_references <- c(
  # NEL metrics
  'E.M.29',
  # UEC metrics
  'E.M.13a',
  'E.M.13b',
  'E.M.13',
  'E.M.26b',
  #Diagnostic metrics
  'E.B.28a', 
  'E.B.28b', 
  'E.B.28c', 
  'E.B.28d', 
  'E.B.28e', 
  'E.B.28f', 
  'E.B.28g', 
  'E.B.28h', 
  'E.B.28k',
  # Cancer metrics
  'E.B.27',
  'E.B.35',
  'E.B.34')

measure_names <- c(
  # NEL metrics
  'Percent occupied NCTR', 
  # UEC metrics
  'Percent less than 4 hours - Type 1',
  'Percent less than 4 hours - Other',
  'Percent less than 4 hours - All types', 
  'Average percentage of occupied AC beds',
  #Diagnostic metrics
  'Percent 6ww Magnetic resonance imaging',
  'Percent 6ww Computed tomography',
  'Percent 6ww Non-obstetric ultrasound',
  'Percent 6ww Colonoscopy',
  'Percent 6ww Flexi sigmoidoscopy',
  'Percent 6ww Gastroscopy',
  'Percent 6ww Cardiology – echocardiography',
  'Percent 6ww DEXA',
  'Percent 6ww Audiology',
  # Cancer metrics
  'Percent 28 day waits',
  'Percent First treatment standard',
  'Percent lower GI suspected cancer referrals with a FIT result')

#read in the function we are going to use
source('rscripts\\gen_tools_and_fns\\fn_create_percentage_rows.R')

# pass the historic_monthly_pva and both vectors to add percentage rows for those metrics

historic_monthly_pva <- fn_create_percentage_rows(historic_monthly_pva,planning_references,measure_names)

