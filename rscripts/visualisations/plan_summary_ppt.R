
# load in required locally created functions
source('rscripts\\visualisations\\fn_syst_chart_slide.R')
source('rscripts\\visualisations\\fn_syst_var_table_slide.R')
source('rscripts\\visualisations\\fn_col_and_line_chart.R')
source('rscripts\\gen_tools_and_fns\\fn_create_colour_vec.R')
source('rscripts\\visualisations\\fn_create_variance_table.R')

p_refs <- c('E.M.11', 
            'E.M.11a',
            'E.M.11b',
            'E.M.25',
            'E.M.29')
mts <- c(rep('Count',4),'Percentage')
gd <- 'decrease'
bad_colour = 'red'
good_colour = 'skyblue'
neutral_colour = 'darkgrey'

slide_df <- historic_monthly_pva |> 
  filter(icb_code == 'QU9') |> 
  select(icb_code,
         icb_short_name,
         org_short_name,
         planning_ref,
         measure_name,
         measure_type,
         source,
         month_short_year,
         planned_activity,
         actual_activity) 

icb_list <- unique(slide_df$icb_code)

team_str <- "South East PAT"
email_str <- "england.datasouth@nhs.net"


doc <- read_pptx("pp_master.pptx")

doc <- ph_with(doc, "Non-Elective Care Plan vs Actual", location = ph_location_label(ph_label = "Title"))
doc <- ph_with(doc, team_str, location = ph_location_label(ph_label = "Produced by"))
doc <- ph_with(doc, email_str, location = ph_location_label(ph_label = "Email"))

for(j in 1:length(p_refs)) {
  
  p_ref <- p_refs[[j]]
  mt = mts[[j]]
  
  for (i in 1:length(icb_list)){
    # add table slide
    doc <- fn_syst_var_table_slide(slide_df,
                                   ppt_doc = doc,
                                   p_ref = p_ref,
                                   mt = mt,
                                   system = icb_list[[i]])  
    # add chart slide
    doc <- fn_syst_chart_slide(slide_df,
                               ppt_doc = doc,
                               p_ref = p_ref,
                               mt = mt,
                               system = icb_list[[i]],
                               bad_colour = bad_colour,
                               good_colour = good_colour,
                               neutral_colour = neutral_colour)
  }
}

# save powerpoint doc
suppressWarnings(print(doc, target = paste0(format(Sys.Date(), "%Y%m%d"), " Powerpoint Pack system.pptx", sep ="")))



