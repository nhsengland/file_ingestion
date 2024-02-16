if(!require("pacman")) install.packages("pacman")
pacman::p_load(tidyverse,
               rmarkdown,
               knitr,
               kableExtra,
               writexl,
               formattable,
               odbc,
               jsonlite,
               flexdashboard,
               DT,
               plotly,
               htmltools,
               janitor,
               hms,
               readxl)

cat("package load complete")

