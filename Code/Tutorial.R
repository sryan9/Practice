install.packages('arrow')
library(arrow)
library(data.table)
library(tidyverse)

setwd("~/LukeTutorial/R_Tutorial_1")

# Set input and output file paths
csv_path <- "Regions.csv"
parquet_path <- "Regions.parquet"

# Read CSV file using arrow package
df <- fread(csv_path)

table <- as_arrow_table(df)

# Write data frame to Parquet file
arrow::write_parquet(table, parquet_path)
