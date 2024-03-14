# This script sources a very simple data import and plot and exports to a powerpoint slide
# The slide is based on a master .pptx file saved in the output folder
# November 2023

# load packages and data --------------------------------------------------
#source("helper/plot_file.R")
#message("Data Loaded")

# output powerpoint -------------------------------------------------------

team_str <- "South East PAT"
email_str <- "england.datasouth@nhs.net"
latest_data <- "September 2023"

doc <- read_pptx("pp_master.pptx")

# add title slide
doc <- add_slide(doc, layout = "Title Slide", master = "Custom Design")
doc <- ph_with(doc, "Example Slides", location = ph_location_label(ph_label = "Title"))
doc <- ph_with(doc, paste("Published ", format(Sys.Date(), "%d %b %y")), location = ph_location_label(ph_label = "Date"))
doc <- ph_with(doc, team_str, location = ph_location_label(ph_label = "Produced by"))
doc <- ph_with(doc, email_str, location = ph_location_label(ph_label = "Email"))

# add table slide
doc <- add_slide(doc, layout = "single_table", master = "Custom Design")
doc <- ph_with(doc, ft_em29, location = ph_location_label(ph_label = "Table"))
doc <- ph_with(doc, "NCTR table test", location = ph_location_label(ph_label = "Title"))

# add chart slide
doc <- add_slide(doc, layout = "chartx6", master = "Custom Design")
doc <- ph_with(doc, bht, location = ph_location_label(ph_label = "Chart1"))
doc <- ph_with(doc, IOW, location = ph_location_label(ph_label = "Chart2"))
doc <- ph_with(doc, HHFT, location = ph_location_label(ph_label = "Chart3"))
doc <- ph_with(doc, UHS, location = ph_location_label(ph_label = "Chart4"))
doc <- ph_with(doc, "NCTR chart test", location = ph_location_label(ph_label = "Title"))


# Save file
print(doc, target = paste0(format(Sys.Date(), "%Y%m%d"), " Powerpoint Pack.pptx", sep =""))