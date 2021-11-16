# An optional custom script to run before Hugo builds your site.
# You can delete it if you do not need it.
library(tidyverse)
library(stringr)
rust_dat<- read_csv(file = "https://www.apsnet.org/edcenter/disimpactmngmnt/topc/EcologyAndEpidemiologyInR/DiseaseProgress/Documents/FungicideExample.csv")

rust_dat %>% gather(key = "trt", value = "measuement", -Julian.Date) %>% 
  ggplot(aes(x = Julian.Date, y = measuement, color = trt)) + geom_point() + geom_line()

rust_dat %>% 
  gather(key = "trt", value = "measuement", -Julian.Date) %>% 
  filter(str_detect(trt, "Cutter")) %>% 
  ggplot(aes(x = Julian.Date, y = measuement, color = trt)) + geom_point() + geom_line()

rust_dat %>% 
  gather(key = "trt", value = "measuement", -Julian.Date) %>% 
  filter(str_detect(trt, "Jagger")) %>% 
  ggplot(aes(x = Julian.Date, y = measuement, color = trt)) + geom_point() + geom_line()

rust_dat %>% 
  gather(key = "trt", value = "measuement", -Julian.Date) %>% 
  filter(str_detect(trt, "Twenty")) %>% 
  ggplot(aes(x = Julian.Date, y = measuement, color = trt)) + geom_point() + geom_line()

rust_dat %>% 
  gather(key = "trt", value = "measuement", -Julian.Date) %>% 
  filter(!str_detect(trt, "rt$")) %>% 
  ggplot(aes(x = Julian.Date, y = measuement, color = trt)) + geom_point() + geom_line()


