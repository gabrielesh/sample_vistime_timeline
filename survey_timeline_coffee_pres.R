# How to use the vistime package to create a timeline.

# Sample data is from a draft survey of digital humanities projects related to local cinema 
# histories. Data was created by Elizabeth Peterson, Michael Aronson, and Gabriele Hayden.
# Our first paper using this data set is under review at Iluminace: Journal for Film Theory, 
# History, and Aesthetics (https://www.iluminace.cz/index.php/en/about-iluminace). Data
# and code are licensed CC-BY and will soon be archived through the University of Oregon's
# Scholars' Bank: Data archive (https://dataverse.harvard.edu/dataverse/scholarsbankdata) 
# with a final version of the data set and more complete metadata.

# This code creates a timeline showing the time period covered by a particular digital 
# humanities project. A second timeline shows the same timeline, but broken out by the
# continent(s) each project covers.

library(tidyverse)
library(vistime)

### Load data and select columns 
survey_timeline <- read_csv("data/survey_content_202010901.csv") %>% 
  select(identifier, title, short_title, continents, time_coverage_start, time_coverage_end)

survey_timeline

### convert columns containing start and end years to dates in ymd format
survey_timeline$time_coverage_start <- 
  as.Date(ISOdate(survey_timeline$time_coverage_start, 1, 1))
survey_timeline$time_coverage_end <- 
  as.Date(ISOdate(survey_timeline$time_coverage_end, 12, 31))

survey_timeline

### remove rows with NAs and sort by start date
survey_timeline <- survey_timeline[complete.cases(survey_timeline),] %>% 
  arrange(time_coverage_start)

survey_timeline

### plot by date
gg_vistime(survey_timeline, 
           col.event = "short_title", 
           col.start = "time_coverage_start",
           col.end = "time_coverage_end",
           optimize_y = FALSE,
           linewidth = 6)
ggsave("survey_timeline_no_group.png", width = 7, height = 6)

### plot by date and grouped by continent
gg_vistime(survey_timeline, 
           col.event = "short_title", 
           col.start = "time_coverage_start",
           col.end = "time_coverage_end",
           col.group = "continents",
           optimize_y = FALSE,
           linewidth = 5)
ggsave("survey_timeline_short.png", width = 7.5, height = 6)

