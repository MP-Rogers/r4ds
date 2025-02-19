#Intro to R4DS

lapply(c ("tidyverse", "janitor", "palmerpenguins"), library, character.only = T)
glimpse(penguins)



# Baby's First Visualisation ----------------------------------------------


penguins |> ggplot(aes(x = flipper_length_mm, y = body_mass_g))+
  theme_minimal()+
  geom_point(aes(shape = species, colour = species))+
  geom_smooth(method = "lm", se = T )+
  labs(title = "Penguin Plot",
       x = "Flipper Length (mm)", y = "Body Mass(g)",
       colour = "Species", shape = "Species", caption = "Data from Palmer Penguins")
  


# Exercises ---------------------------------------------------------------

#How many rows are in penguins? How many columns?
dim(penguins)
  
#What does the bill_depth_mm variable in the penguins data frame describe? Read the help for ?penguins to find out.
?penguins

#Make a scatterplot of bill_depth_mm vs. bill_length_mm. That is, make a scatterplot with bill_depth_mm on the y-axis and bill_length_mm on the x-axis. Describe the relationship between these two variables.
penguins |> ggplot(aes(x =  bill_length_mm, y = bill_depth_mm))+
  theme_minimal()+
  geom_point(aes(colour = species, shape = sex), na.rm = T)+
  labs(title = "Penguin plot 2")

#What happens if you make a scatterplot of species vs. bill_depth_mm? What might be a better choice of geom?
penguins |> ggplot(aes(x = species, y = bill_depth_mm))+
  geom_boxplot(aes(fill = species))


# Visualising Distributions -----------------------------------------------

penguins |> ggplot(aes(x = fct_infreq(species)))+
  geom_bar(fill = "darkgreen") #dont use AES, its not mapped to anything underlying the data

penguins |> ggplot(aes(x = body_mass_g))+
  geom_histogram(binwidth = 200, fill = "darkblue")

penguins |> ggplot(aes(x = body_mass_g)) +
  geom_density()

# Visualising Relationships between multiple variables --------------------

penguins |> ggplot(aes(x = species, y = body_mass_g))+
  geom_boxplot()

penguins |> ggplot(aes(x = body_mass_g))+
  geom_density(aes(fill = species, colour = species), alpha = 0.5)

penguins |> ggplot(aes(x = island, fill = species))+
  geom_bar(position = "fill") #position = fill makes this proportionate nd disregards differences in no penguins per island

penguins |> ggplot(aes(x = body_mass_g, y = flipper_length_mm))+
  geom_point(aes(colour = species, shape = island))+
  facet_wrap(~island)

# Exercises 2 -------------------------------------------------------------

glimpse(mpg)

mpg |> ggplot(aes(x = displ, y = hwy))+
  geom_point(aes(colour = cyl)) #Shape wont take a continues variable
ggsave("mpg_plot1.png") #Saves last plot


# Tidying Data
library(nycflights13)

# dplyr basics ------------------------------------------------------------

glimpse(flights)

# Works on Rows using col values as a criterion 
flights |> filter(dep_delay > 120)
flights |> filter(day == 1 & month == 1)
flights |> filter(month %in% c(1,2)) #combinations of "or" for the same variable

flights |> arrange(desc(dep_delay))
flights |> distinct() # removes duplicate rows on its own
flights |> distinct(origin, dest) #Leaves only the unique combos of these variables
flights |> distinct(origin, dest, .keep_all = T) # leaves the rest of the row info, discards after the first
flights |> count(origin, dest, sort = T)

# Exercises

flights |>
  filter(arr_delay >= 120) |>
  filter(dest %in% c("HOU", "IAH")) |>
  filter(carrier %in% c("AA", "DL", "UA")) |>
  filter(month %in% c(7,8,9)) |>
  filter(arr_delay >= 120 & dep_delay <= 0) |>
  filter(dep_delay >  60 & dep_delay - arr_delay = 30)

flights |> arrange(dep_delay, sched_dep_time)
flights |> arrange(dep_time - arr_time)
flights |> filter(year == 2013) |> distinct(day, month)

# Works on columns
flights |> mutate(gain = dep_delay - arr_delay,
                  speed = distance/air_time,
                    #.before = 1, 
                  .keep = "used")

flights |> select(day:year) |> #Select all columns btw day and year inclusive
  distinct() |>
  glimpse()

flights |> select(!day:year) # selects all columns except those btw day and year

flights |> select(where(is.character))
flights |> select(starts_with("arr"))
flights |> select(ends_with("delay"))
flights |> select(contains("car"))

#Select can be combined with rename as below(new = old)

flights |> select(tail_number = tailnum)

## Exercises

#Compare dep_time, sched_dep_time, and dep_delay. How would you expect those three numbers to be related?
flights |> select(contains("dep"))

## Brainstorm as many ways as possible to select dep_time, dep_delay, arr_time, and arr_delay from flights
flights |> select(contains("time")|contains("delay"))
flights |> select(dep_time,dep_delay, arr_time, arr_delay)
flights |> select(starts_with("arr")|starts_with("dep"))

#Rename air_time to air_time_min to indicate units of measurement and move it to the beginning of the data frame.
flights |> rename(air_time_min = air_time) |>
  relocate(air_time_min)



# Grouping functions ------------------------------------------------------

flights |> group_by(month)
flights |> group_by(month) |> 
  summarise( mean_delay = mean(dep_delay, na.rm = T), n = n())

flights |> summarise(n = n(),
                     .by = carrier) # The by operater lets you group in 1 operation

flights |> group_by(dest) |>
  slice_max(dep_delay, n = 3) |> #selects highest delay, 3 rows
  relocate(dest)


# Exercises
#Which carrier has the worst average delays? Challenge: can you disentangle the effects of bad airports vs. bad carriers? Why/why not? (Hint: think about flights |> group_by(carrier, dest) |> summarize(n()))
flights |> group_by(carrier,dest) |> 
  summarise(avg_delay = mean(dep_delay, na.rm = T)) |> 
  arrange(desc(avg_delay))

#Find the flights that are most delayed upon departure from each destination.
flights |> group_by(dest) |> 
  slice_max(dep_delay, n = 1)

#How do delays vary over the course of the day? Illustrate your answer with a plot.
flights |> group_by(hour) |> 
  summarise(mean_delay = mean(dep_delay, na.rm = T)) |> 
  ggplot(aes(x = hour, y = mean_delay))+
  theme_minimal()+
  geom_col(fill = "red")+
  labs(title = "Mean delays across the day",
       x = "Hour", y = "Average Delay(min)",
       caption = "From nycflights13 dataset")