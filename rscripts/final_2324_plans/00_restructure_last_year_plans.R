# reshape the h2 bed data to match how it was collected in 2324
source('rscripts\\final_2324_plans\\01_h2bed_restructure.R')
# merge the may and h2 submissions
source('rscripts\\final_2324_plans\\02_merge_may_and_h2.R')
# create a set of lookup tables for tidying the merged product
source('rscripts\\final_2324_plans\\03_create_lookups.R')
# add in the missing names using the lookups and restructure the fields into a
# sensible order 
source('rscripts\\final_2324_plans\\04_cleanup_final_2324.R')
