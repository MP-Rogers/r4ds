lapply(c("tidyverse", "janitor", "hexbin"), library, character.only = T)


# GGplot Basics -----------------------------------------------------------

mpg |> ggplot(aes(x = displ, y = hwy, colour = class))+
  geom_point(shape = 17, size = 2, alpha = 0.5)

# Exercises
#Create a scatterplot of hwy vs. displ where the points are pink filled in triangles.
mpg |> ggplot(aes(x = displ, y = hwy))+
  geom_point(colour = "hotpink", shape = 17)

mpg |> ggplot(aes(x = displ, y = hwy))+ # Adjusts point border. Sorta helps visibility
  geom_point(shape = 5, stroke = F) 

mpg |> ggplot(aes(x = displ, y = hwy))+ # This is useful for emphasis, especially where we have standards and critical values
  geom_point(aes(colour = displ < 4))

#Geoms
mpg |> ggplot(aes(x = displ, y = hwy))+
  geom_smooth(aes(linetype = drv, colour = drv))+ #broken into groups by aes provided
  geom_smooth(colour = "black") # overall

mpg |> ggplot(aes(x = displ, y = hwy))+
  geom_point()+
  geom_point(data = mpg |> filter(class == "2seater"), #This works well to call out points/groups of interest
             colour = "red", stroke = T)+
  geom_point(data = mpg |> filter(class == "2seater"), #This works well to call out points/groups of interest
             colour = "red", size = 5, shape = "circle open")


# Facets
mpg |> ggplot(aes(x = displ, y = hwy))+
  geom_point()+
  facet_wrap(~drv)

mpg |> ggplot(aes(x = displ, y = hwy))+
  geom_point()+
  facet_grid(drv ~ cyl, scales = "free") #scales breaks up the scales so they dont have to eb the same

mpg |> ggplot(aes(x = displ, y = hwy))+
  geom_point()+
  facet_grid(drv ~ .)

#Statistical transformations

diamonds |> ggplot(aes(x = cut))+
  geom_bar() #computes "count" as its default stat

diamonds |> ggplot(aes(x = cut, y = after_stat(prop), group = 1))+
  geom_bar()

diamonds |> ggplot()+ 
  stat_summary(aes(x = cut, y = depth), # for more detailed summaries
               fun.min = min,
               fun.max = max,
               fun = median)

diamonds |> ggplot(aes(x = cut, y = depth))+
  geom_pointrange(aes(ymin = lower, ymax = upper))


# Positioning and Coordinates -------------------------------------------------------------

mpg |> ggplot(aes(x = drv, fill = class))+
  geom_bar(alpha = 0.8) #The default stacks a bar chart

mpg |> ggplot(aes(x = drv, fill = class))+
  geom_bar(alpha = 0.8, position = "dodge")+
  labs(title = "A grouped bar chart",
       subtitle = "uses position = dodge")

mpg |> ggplot(aes(x = drv, fill = class))+
  geom_bar(alpha = 0.8, position = "fill")+
  labs(title = "A proportion bar chart",
       subtitle = "uses position = fill")

mpg |> ggplot(aes(x = drv, fill = class))+
  geom_bar(alpha = 0.8)+
  coord_polar()



# Exploratory Data Analysis -----------------------------------------------

#Ask lots of questions, write em down, you'll eventually hone in on the right one
#You learn the process by doing and asking the questions, even if questions and goals are provided:
# The good starting points are: How is this data distributed, What does Variance look like, 
# and how do variables Correlations


# Checking distributions of data
# Be curious and skeptic...a scientist

diamonds |> ggplot(aes(x = carat))+
  geom_histogram(fill = "gold", binwidth = 0.5)

diamonds |> filter(carat < 3) |>
  ggplot(aes(x = carat)) +
  geom_histogram(binwidth = 0.01)


ggplot(diamonds, aes(x = y)) + 
  geom_histogram(binwidth = 0.5) +
  coord_cartesian(ylim = c(0, 50)) # lets you trim the axes to view only what you want

# Exercises

#Investigate the distribution of price
diamonds |> ggplot(aes(x = price))+
  geom_histogram(fill = "gold", colour = "black", binwidth = 2000)
      # So lots of relatively cheap diamonds, price declines moving higher. 
      # Vast Majority below $5000 (heavy right skew)
      # Itll likely always be right skewed, but showing just how skewed changes with binwidth
      # Widening binwidths makes it look...less dramatic?

#Check how many diamonds are 0.99 carat and how many are 1
diamonds |> filter(carat == 0.99|carat == 1) |> 
  ggplot(aes(x = carat))+
  geom_bar(fill = "red", colour = "black")
    #Ok, several times more 1carat than 99 carat. This agrees with the data though, overall distribution wise
diamonds |> ggplot(aes(x = carat))+
  geom_histogram(binwidth = 0.01)+
  coord_cartesian(xlim = c(0, 3.25))
  # yeah theres always more diamonds above a peak than below. Does no one advertise "almost 1carat"?


diamonds |> slice_max(price, n = 5)


diamonds |> ggplot(aes(x = carat))+
  geom_histogram(binwidth = 0.01)+
  xlim(0,3.25)

diamonds |> ggplot(aes(x = carat))+ #Ylim will do a weird axis shrinking thing, distoring bars to fit
  geom_histogram(binwidth = 0.01)+
  ylim(0,1000)


diamonds |> ggplot(aes(x = carat))+ #cord cartesian will cut an axis, leaving bars cut off
  geom_histogram(binwidth = 0.01)+
  coord_cartesian(ylim = c(0,1000))

# Investigating covariation
diamonds |> ggplot(aes(x = price))+
  geom_freqpoly(aes(colour = cut), linewidth = 0.75)

diamonds |> ggplot(aes(x = price, y = after_stat(density)))+
  geom_freqpoly(aes(colour = cut), linewidth = 0.75)
  #after stat density compensates so the are under each polygon = 1;
  #in short it shows distribution, not actual counts

diamonds |> ggplot(aes(x = cut, y = color))+
  geom_count()

diamonds |> count(color, cut) |> 
  ggplot(aes(x = cut, y = color))+
  geom_tile(aes(fill = n))

# When comparing 2 numeric datasets....and one gets large
diamonds |> filter(carat < 3) |> 
  ggplot(aes(x = carat, y = price))+
  geom_point()

# We can introduce transparency to curb the overlap
diamonds |> filter(carat < 3) |> 
  ggplot(aes(x = carat, y = price))+
  geom_point(alpha = 0.01)

#bin and have colours corresponding to the bin filledness
diamonds |> filter(carat < 3) |> 
  ggplot(aes(x = carat, y = price))+
  geom_bin2d()

diamonds |> filter(carat < 3) |> 
  ggplot(aes(x = carat, y = price))+
  geom_hex()

# Bin a continuous variable into a categorical one/ordinal, then use it and do boxplots
diamonds |> filter(carat < 3) |> 
  ggplot(aes(x = carat, y = price))+
  geom_boxplot(aes(group = cut_width(carat, 0.1)))# divides x(carat) into bins of "width"

