if(!require("pacman")) install.packages("pacman")
pacman::p_load(tidyverse,
               rmarkdown,
               knitr,
               writexl,
               formattable,
               odbc,
               jsonlite,
               gt,
               gtsummary,
               plotly,
               htmltools,
               janitor,
               hms,
               readxl)

message("package load complete")

