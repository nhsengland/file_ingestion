if(!require("pacman")) install.packages("pacman")
pacman::p_load(tidyverse,
               rmarkdown,
               knitr,
               tinytex,
               kableExtra,
               writexl,
               stringr,
               formattable,
               odbc,
               ggplot2,
               jsonlite,
               flexdashboard,
               DT,
               plotly,
               htmltools,
               janitor,
               hms,
               readxl)

cat("package load complete")