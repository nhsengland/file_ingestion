narrative1 <- 'This slide shows some key metrics taken from the March 2024 planning submissions. Where the 
data is available at a system level it has been presented as such. Where it was submitted exclusively at trust 
level this has been aggregated to give an overview for the ICB. Please note that the plan corresponds to the 
planned position for March 2025 in all cases except E.B.20, which is the planned position for Sept. 24.
HIOW and Frimley do not plan to reach zero 65ww in 2024/25, K&M plans for 0 by March 25.'

narrative3 <- 'This slide shows the months represented by the latest actual and plan columns 
in the tables on the previous slides. The latest actual matches the data presented to the systems as part of 
their planning submission documentation.'


team_str <- "South East PAT"
email_str <- "england.datasouth@nhs.net"

doc <- read_pptx("pp_master.pptx")

doc <- add_slide(doc, layout = "Title Slide", master = "Custom Design")
doc <- ph_with(doc, "March 2024 SE Region Plan", location = ph_location_label(ph_label = "Title"))
doc <- ph_with(doc, "Summary of key metrics", location = ph_location_label(ph_label = "Date"))
doc <- ph_with(doc, team_str, location = ph_location_label(ph_label = "Produced by"))
doc <- ph_with(doc, email_str, location = ph_location_label(ph_label = "Email"))

doc <- add_slide(doc, layout = "tablex1", master = "Custom Design")
doc <- ph_with(doc, narrative1, location = ph_location_label(ph_label = 'Narrative'))
doc <- ph_with(doc, icb_flex1, location = ph_location_label(ph_label = "Table1"))
doc <- ph_with(doc, "ICB metric summary 1", location = ph_location_label(ph_label = "Title"))

doc <- add_slide(doc, layout = "tablex1", master = "Custom Design")
doc <- ph_with(doc, icb_flex2, location = ph_location_label(ph_label = "Table1"))
doc <- ph_with(doc, "ICB metric summary 2", location = ph_location_label(ph_label = "Title"))

doc <- add_slide(doc, layout = "tablex1", master = "Custom Design")
doc <- ph_with(doc, narrative3, location = ph_location_label(ph_label = 'Narrative'))
doc <- ph_with(doc, dates_flex, location = ph_location_label(ph_label = "Table1"))
doc <- ph_with(doc, "Appendix - dates of actuals and plan months", location = ph_location_label(ph_label = "Title"))


print(doc, target = paste0("Key Metrics SE Region ",format(Sys.Date(), "%Y%m%d"), ".pptx", sep =""))