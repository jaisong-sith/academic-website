library(rnaturalearth)

world <- ne_countries(type = 'countries', 
                      scale = 'small', 
                      returnclass = "sf")
#One of the main advantages of the sf object that it is also a data.frame object. Therefore, it is strightforward to work and manipulate the data with dplyr (or anything similar):


class(world)
library(sf)
plot(world)
thailand <- ne_states(country = "Thailand", 
                      returnclass = "sf")

#if cant install
#devtools::install_github("ropensci/rnaturalearthhires")
head(thailand)
plot(thailand$geometry, 
     col = sf.colors(37, categorical = TRUE), 
     border = 'grey', axes = TRUE, main = "Thailand")


library(coronavirus)
covid19_daily <- refresh_coronavirus_jhu()
head(covid19_daily)

library(tidyverse)
df <- covid19_daily %>%
  filter(location_type == "country") %>%
  group_by(location, location_code, data_type) %>%
  summarise(cases = sum(value),
            .groups = "drop") %>%
  pivot_wider(names_from = data_type, values_from = cases) %>%
  setNames(c("country", "country_code", "total_cases", "total_death"))
head(df)


library(rvest)
url <- "https://en.wikipedia.org/wiki/Provinces_of_Thailand"
page <- read_html(url)
tables <- html_node(page, ".wikitable")
pop_table <- html_table(tables, fill = TRUE)

pop_table <- pop_table  %>%
  select(province = Name, pop_2019 = `Population (2019)[1]`) %>%
  mutate(pop_2019 = as.numeric(gsub(",", "", pop_2019)))

thailand_pop <- thailand %>% 
  left_join(pop_table, by = c("name" = "province"))

plot(thailand_pop["pop_2019"], key.pos = 1, 
     axes = TRUE, main = "Thailand Population by Province",
     key.width = lcm(1.3), key.length = 1.0)

library(tmap)

tmap_mode("plot")

TH_pop_plot  <- tm_shape(thailand_pop) +
  tm_polygons(col = "pop_2019", 
              style = "order",
              title = "Population",
              palette = "Blues") +
  tm_style("cobalt") + 
  tm_text("name", size = 0.5) +
  tm_credits("Source: Wikipedia - Provinces_of_Thailand",
             position = c("LEFT", "BOTTOM")) + 
  tm_layout(title= "Thailand Population by Province", 
            title.position = c('right', 'top') ,
            inner.margins = c(0.02, .02, .1, .15))



TH_pop_plot_facets <- tm_shape(thailand_pop) + 
  tm_polygons(col = "pop_2019",  
              n = 5,
              title = "Total Population",
              palette = "Greens") + 
  tmap_options(limits = c(facets.view = 13)) + 
  tm_facets(by = "name")
TH_pop_plot_facets


library(viridis)
p1 <- ggplot(data = thailand_pop, aes(fill = pop_2019)) + 
  geom_sf() + 
  scale_fill_viridis_b()
p1


p2 <- ggplot(data = thailand_pop, aes(fill = pop_2019)) + 
  geom_sf(size = 0.1) + 
  scale_fill_viridis(alpha = 0.9,
                     begin = 0.01,
                     discrete = FALSE,
                     end = 0.9) + 
  geom_sf_label(aes(label = name)) + 
  labs(fill = "Population",
       title = "Population by State",
       caption = "Source: https://en.wikipedia.org/wiki/List_of_Nigerian_states_by_population") + 
  theme_void()
p2
