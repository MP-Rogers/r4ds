lapply(c("tidyverse", "janitor"), library, character.only = T)


# Pivot longer (col name is a variable of its own) ------------------------

billboard |> pivot_longer(cols = starts_with("wk"),
                          names_to = "week",
                          values_to = "rank",
                          values_drop_na = T) |> # Take columns start w week, names become part of week, col values become rank
  mutate(week = parse_number(week)) |>  #parse out week to number
  ggplot(aes(x = week, y = rank, group = track))+ #I can group up here without assigning an aesthetic
  theme_minimal()+
  geom_line(alpha = 0.2)+
  labs(title = "Weekly Billboard Rankings", caption = "from 2000s Billboard Database")+
  scale_y_reverse()

# Test to build some intuition
df <- tribble(
  ~id,  ~bp1, ~bp2,
  "A",  100,  120,
  "B",  140,  115,
  "C",  120,  125
)

df |> pivot_longer(cols = !id,
                   names_to = "measurement",
                   values_to = "value")

# Now with something more complex
who2 |> pivot_longer(cols = !(country|year),
                     names_to = c("method", "sex", "age"),
                     names_sep = "_",
                     values_to = "count")

household |> pivot_longer(cols = !family,
                          names_to = c(".value", "child"),
                          names_sep = "_",
                          values_drop_na = T)




# Pivot wider (observation spread across rows) ----------------------------


cms_patient_experience |> pivot_wider(names_from = measure_cd,
                                      values_from = prf_rate,
                                      id_cols = starts_with("org"))

# Simple example to build intuition

df2 <- tribble(
  ~id, ~measurement, ~value,
  "A",        "bp1",    100,
  "B",        "bp1",    140,
  "B",        "bp2",    115, 
  "A",        "bp2",    120,
  "A",        "bp3",    105)

df2 |> pivot_wider(names_from = measurement,
                   values_from = value,
                   id_cols = id)
  
  