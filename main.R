library(tidyverse)
library(jsonlite)
library(glue)
library(lubridate)
library(showtext)
library(ggtext)

states <- str_to_lower(state.name)

contig <- states[!states %in% c("alaska", "hawaii")] %>%
  str_replace_all(., " ", "-")

all_states <- map_df(contig, function(x) {
  cat(crayon::cyan(glue("Starting {x}")), "\n")
  link <- glue("https://storage.googleapis.com/noaa-nidis-drought-gov-data/",
               "current-conditions/json/v1/state/nclimstates/{x}.json?time=1651441500000")
  
  df <- fromJSON(link) %>%
    mutate(state = x)
})

names(all_states) <- str_to_lower(names(all_states))

long <- all_states %>%
  filter(`-9` != 100) %>%
  mutate(good_date = ymd(str_sub(date, 3, 10))) %>%
  pivot_longer(cols = c(3:13), names_to = "cat") %>%
  select(-c(1:2)) %>%
  filter(cat != "-9") %>%
  mutate(cat = factor(cat, levels = c(glue("d{0:4}"),
                                      glue("w{0:4}"))))

c <- c(
  "d0" = "#FCFF00",
  "d1" = "#FFCC99",
  "d2" = "#FF6600",
  "d3" = "#FF0000",
  "d4" = "#660000",
  "w0" = "#AAFF55",
  "w1" = "#01FFFF",
  "w2" = "#04A9FF",
  "w3" = "#0000FF",
  "w4" = "#0000AA"
)

# Invert colors because I want to use a black background

c_neg <- c(rev(c[1:5]), rev(c[6:10]))
names(c_neg) <- NULL

# Create df for custom axis labels

ylabs <- tibble(
  x = c("1895-09-01",
        glue("{seq(from = 1920, to = 2000, by = 20)}-01-01"),
        "2022-03-01")
) %>%
  mutate(x = ymd(x),
         y = 125,
         yend = -125,
         lab = year(x),
         hjust = c(0,0,0,.5,1,1,1),
         vjust = c(-.5, .5,.5, 1, 1, .5, -.5))

# Load fonts

font_add_google("Atkinson Hyperlegible", "fo")
font_add_google("K2D", "fo")
showtext_auto()

long %>%
  #filter(good_date < ymd("1900-01-01")) %>%
  mutate(value = ifelse(str_detect(cat, "^w"), value * -1, value)) %>%
  ggplot(aes(good_date, value, fill = cat)) +
  geom_area(position = "identity") +
  scale_y_continuous(labels = function(x) glue("{abs(x)}%"),
                     limits = c(-200, NA)) +
  scale_x_date(expand = c(.05, 0)) +
  scale_fill_manual(values = c_neg,
                    labels = c(rep("", 4), "Driest",
                               rep("", 4), "Wettest")) +
  #coord_polar(clip = "off") +
  facet_wrap(~ state, ncol = 8) +
  theme_void() +
  theme(text = element_text(family = "fo"),
        legend.position = "none") 

ggsave(filename = "plots/full.png", bg = "black", w = 11, h = 9)
