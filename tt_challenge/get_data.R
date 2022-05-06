library(tidyverse)
library(jsonlite)
library(glue)
library(crayon)


# Data isn't available for Alaska and Hawaii,
# state names have to be lowercase, and 
# - instead of a space

states <- str_to_lower(state.name)

contig <- states[!states %in% c("alaska", "hawaii")] %>%
  str_replace_all(., " ", "-")

all_states <- map_df(contig, function(x) {
  # print state progress
  cat(cyan(glue("Starting {x}")), "\n")
  
  # endpoint for each state
  link <- glue("https://storage.googleapis.com/noaa-nidis-drought-gov-data/",
               "current-conditions/json/v1/state/nclimstates/{x}.json?time=1651441500000")
  
  # take JSON from responses, add label for state
  df <- fromJSON(link) %>%
    mutate(state = x)
})

write_csv(all_states, "tt_challenge/drought.csv")
