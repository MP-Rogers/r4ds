lapply(c("tidyverse", "janitor", "scales", "patchwork", "ggrepel"),
       library, character.only = T)

# Labels Matter
#Be descriptive, lead them where you want them
#Use subtitiles and captions
mpg |> ggplot(aes(x = displ, y = hwy))+
  geom_point(aes(colour = class))+
  geom_smooth(se = F)+
  labs( x = "Engine displacement (L)",
        y = "Highway fuel economy (mpg)",
        color = "Car type",
        title = "Fuel efficiency generally decreases with engine size",
        subtitle = "Two seaters (sports cars) are an exception because of their light weight",
        caption = "Data from fueleconomy.gov")


#Labels can be math
df <- tibble(x = 1:10,y = cumsum(x^2))
df |> ggplot(aes(x = x, y = y))+
  geom_point()+
  geom_line()+
  labs(x = quote(x[i]),
       y = quote(sum(x[i] ^ 2, i == 1, n )))

mpg |> ggplot(aes(x = cty, y = hwy))+
  geom_point(aes(colour = drv, shape = drv))+
  labs(x = "City MPG", y = "Highway MPG", 
       colour = "Drive Train", shape = "Drive Train")

# Annotating via geom_text
label_info <- mpg |> 
  group_by(drv) |> 
  arrange(desc(displ)) |> 
  slice_head(n = 1) |> 
  mutate( drive_type = case_when(
    drv == "f" ~ "Front-Wheel Drive",
    drv == "r" ~ "Rear-Wheel Drive",
    drv == "4" ~ "4-Wheel Drive"
  )) |> 
  select(drv, hwy, displ,drive_type)

mpg |> ggplot(aes(x = displ, y = hwy, colour = drv))+
  geom_point()+
  geom_smooth(se = F)+
  geom_text(data = label_info,
            aes(x = displ, y = hwy, label = drive_type),
            hjust = "right", vjust = "bottom")

mpg |> ggplot(aes(x = displ, y = hwy, colour = drv))+
  geom_point()+
  geom_smooth(se = F)+
  geom_label_repel(data = label_info,
            aes(x = displ, y = hwy, label = drive_type),
            nudge_y = 1)

#using annottate, only use for one annototation
trend_text <- "This is sample trend text. Big engine -> lower economy" |> str_wrap(30)

mpg |> ggplot(aes(x = displ, y = hwy))+
  geom_point()+
  annotate(geom = "label", x = 5, y = 38,
           label = trend_text, colour = "red")+
  annotate(
    geom = "segment",
    x = 3, y = 35, xend = 5, yend = 25, color = "red",
    arrow = arrow(type = "closed")
  )

#Playing with scales
mpg |> ggplot(aes(x = displ, y = hwy, colour = drv))+
  geom_point()+
  scale_y_continuous(breaks = seq(10, 50, by = 5)) #does not include upper and lower bound

mpg |> ggplot(aes(x = displ, y = hwy, colour = drv))+
  geom_point()+
  scale_y_continuous(labels = NULL)

diamonds |> ggplot(aes(x = price, y = cut)) +
  geom_boxplot()+
  scale_x_continuous(labels = dollar_format(scale = 1/1000, suffix = "K"),
                     breaks = seq(1000, 25000, by  = 6000)) #Takes new scale

diamonds |> ggplot(aes(x = cut, fill = clarity))+
  geom_bar(position = "fill")+
  scale_y_continuous(name = "Percentage...xxx", #Good substitute for labs if you changing format
                     labels = percent_format())


  
