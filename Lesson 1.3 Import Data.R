library(tidyverse)
library(janitor)
library(arrow)

# Importing Data ----------------------------------------------------------

students <- read_csv("https://pos.it/r4ds-students-csv",
                     na = c("N/A"),
                     col_names = T) |> # I can pipe directly it seems
  clean_names() |> 
  mutate(age = parse_number(if_else(age == "five", "5", age)),
         meal_plan = as.factor(meal_plan)) |> 
  glimpse()


#Dealing with messy or missing columns screwing your col type
simple_csv <- "
  x
  10
  .
  -
  20
  30"

df <- read_csv(simple_csv, col_types = list(x = col_double())) # expect x to be a number and see where erros are
problems(df)

read_csv(simple_csv, na = c(".","-")) #I can specify what the missing values are using a vector

#Reading from multiple files at once
sales_files <- c(
  "https://pos.it/r4ds-01-sales",
  "https://pos.it/r4ds-02-sales",
  "https://pos.it/r4ds-03-sales"
)

sales_dataset <- read_delim(sales_files, id = "file", delim = ",") # delim reads all types of files, but using a delim of choice, guesses if you dont provide



# Writing To files --------------------------------------------------------

write_csv(students, "students.csv")
students_reentered <- read_csv("students.csv") #column types are back to read_csv defaults

write_rds(students, "students.rds")
students3 <- read_rds("students.rds") #This pair preserves R objects basically perfectly. better for interim storage


arrow::write_parquet(students, "students.parquet")
students4 <- arrow::read_parquet("students.parquet") #This pair is even faster and usable across programming alngauges

