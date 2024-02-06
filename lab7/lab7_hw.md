---
title: "Lab 7 Homework"
author: "Your Name Here"
date: "2024-02-06"
output:
  html_document: 
    theme: spacelab
    keep_md: true
---



## Instructions
Answer the following questions and complete the exercises in RMarkdown. Please embed all of your code and push your final work to your repository. Your final lab report should be organized, clean, and run free from errors. Remember, you must remove the `#` for the included code chunks to run. Be sure to add your name to the author header above.  

Make sure to use the formatting conventions of RMarkdown to make your report neat and clean!  

## Load the libraries

```r
library(tidyverse)
library(janitor)
library(skimr)
library(dplyr)
```

For this assignment we are going to work with a large data set from the [United Nations Food and Agriculture Organization](http://www.fao.org/about/en/) on world fisheries. These data are pretty wild, so we need to do some cleaning. First, load the data.  

Load the data `FAO_1950to2012_111914.csv` as a new object titled `fisheries`.

```r
fisheries <- readr::read_csv(file = "data/FAO_1950to2012_111914.csv")
```

```
## Rows: 17692 Columns: 71
## ── Column specification ────────────────────────────────────────────────────────
## Delimiter: ","
## chr (69): Country, Common name, ISSCAAP taxonomic group, ASFIS species#, ASF...
## dbl  (2): ISSCAAP group#, FAO major fishing area
## 
## ℹ Use `spec()` to retrieve the full column specification for this data.
## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
```

1. Do an exploratory analysis of the data (your choice). What are the names of the variables, what are the dimensions, are there any NA's, what are the classes of the variables?  

```r
dim(fisheries)
```

```
## [1] 17692    71
```

```r
names(fisheries)
```

```
##  [1] "Country"                 "Common name"            
##  [3] "ISSCAAP group#"          "ISSCAAP taxonomic group"
##  [5] "ASFIS species#"          "ASFIS species name"     
##  [7] "FAO major fishing area"  "Measure"                
##  [9] "1950"                    "1951"                   
## [11] "1952"                    "1953"                   
## [13] "1954"                    "1955"                   
## [15] "1956"                    "1957"                   
## [17] "1958"                    "1959"                   
## [19] "1960"                    "1961"                   
## [21] "1962"                    "1963"                   
## [23] "1964"                    "1965"                   
## [25] "1966"                    "1967"                   
## [27] "1968"                    "1969"                   
## [29] "1970"                    "1971"                   
## [31] "1972"                    "1973"                   
## [33] "1974"                    "1975"                   
## [35] "1976"                    "1977"                   
## [37] "1978"                    "1979"                   
## [39] "1980"                    "1981"                   
## [41] "1982"                    "1983"                   
## [43] "1984"                    "1985"                   
## [45] "1986"                    "1987"                   
## [47] "1988"                    "1989"                   
## [49] "1990"                    "1991"                   
## [51] "1992"                    "1993"                   
## [53] "1994"                    "1995"                   
## [55] "1996"                    "1997"                   
## [57] "1998"                    "1999"                   
## [59] "2000"                    "2001"                   
## [61] "2002"                    "2003"                   
## [63] "2004"                    "2005"                   
## [65] "2006"                    "2007"                   
## [67] "2008"                    "2009"                   
## [69] "2010"                    "2011"                   
## [71] "2012"
```

```r
anyNA(fisheries)
```

```
## [1] TRUE
```

2. Use `janitor` to rename the columns and make them easier to use. As part of this cleaning step, change `country`, `isscaap_group_number`, `asfis_species_number`, and `fao_major_fishing_area` to data class factor. 

```r
new_fisheries <- clean_names(fisheries)
new_fisheries$country <- as.factor(new_fisheries$country)
new_fisheries$isscaap_group_number  <- as.factor(new_fisheries$isscaap_group_number )
new_fisheries$asfis_species_number  <- as.factor(new_fisheries$asfis_species_number )
new_fisheries$fao_major_fishing_area  <- as.factor(new_fisheries$fao_major_fishing_area )
new_fisheries$year
```

```
## Warning: Unknown or uninitialised column: `year`.
```

```
## NULL
```

We need to deal with the years because they are being treated as characters and start with an X. We also have the problem that the column names that are years actually represent data. We haven't discussed tidy data yet, so here is some help. You should run this ugly chunk to transform the data for the rest of the homework. It will only work if you have used janitor to rename the variables in question 2!  
#this cleans data, remove the hashtags

```r
 fisheries_tidy <- new_fisheries %>% 
  pivot_longer(-c(country,common_name,isscaap_group_number,isscaap_taxonomic_group,asfis_species_number,asfis_species_name,fao_major_fishing_area,measure),
               names_to = "year",
               values_to = "catch",
               values_drop_na = TRUE) %>% 
  mutate(year= as.numeric(str_replace(year, 'x', ''))) %>% 
  mutate(catch= str_replace(catch, c(' F'), replacement = '')) %>% 
  mutate(catch= str_replace(catch, c('...'), replacement = '')) %>% 
  mutate(catch= str_replace(catch, c('-'), replacement = '')) %>% 
  mutate(catch= str_replace(catch, c('0 0'), replacement = ''))

fisheries_tidy$catch <- as.numeric(fisheries_tidy$catch)
```

3. How many countries are represented in the data? Provide a count and list their names.

```r
fisheries_tidy %>%
  summarise(number_countries=n_distinct(country))
```

```
## # A tibble: 1 × 1
##   number_countries
##              <int>
## 1              203
```

4. Refocus the data only to include country, isscaap_taxonomic_group, asfis_species_name, asfis_species_number, year, catch.

```r
specific_fish <- fisheries_tidy %>%
  select(country, isscaap_taxonomic_group, asfis_species_name, asfis_species_number, year, catch)
```

5. Based on the asfis_species_number, how many distinct fish species were caught as part of these data?

```r
fisheries_tidy %>%
  summarise(number_species = n_distinct(asfis_species_number))
```

```
## # A tibble: 1 × 1
##   number_species
##            <int>
## 1           1551
```
    1551 distict fish species were caught in this dataset
    
6. Which country had the largest overall catch in the year 2000?

```r
fisheries_tidy %>%
  select(country, catch, year) %>%
  filter(year == 2000) %>%
  arrange(desc(catch))
```

```
## # A tibble: 8,793 × 3
##    country                  catch  year
##    <fct>                    <dbl> <dbl>
##  1 China                     9068  2000
##  2 Peru                      5717  2000
##  3 Russian Federation        5065  2000
##  4 Viet Nam                  4945  2000
##  5 Chile                     4299  2000
##  6 China                     3288  2000
##  7 China                     2782  2000
##  8 United States of America  2438  2000
##  9 China                     1234  2000
## 10 Philippines                999  2000
## # ℹ 8,783 more rows
```
    China had the largest catch in 2000, with a catch of 9068 tons
    
7. Which country caught the most sardines (_Sardina pilchardus_) between the years 1990-2000?

```r
fisheries_tidy %>%
  group_by(country) %>%
  select(country, asfis_species_name, catch, year) %>%
  filter(year >= 1990 & year <= 2000) %>%
  filter(asfis_species_name == "Sardina pilchardus") %>%
  summarise(total_catch= sum(catch))%>%
  arrange(desc(total_catch))
```

```
## # A tibble: 37 × 2
##    country               total_catch
##    <fct>                       <dbl>
##  1 Morocco                      7470
##  2 Spain                        3507
##  3 Russian Federation           1639
##  4 Ukraine                      1030
##  5 Portugal                      818
##  6 Greece                        528
##  7 Italy                         507
##  8 Serbia and Montenegro         478
##  9 Denmark                       477
## 10 Tunisia                       427
## # ℹ 27 more rows
```
    Morocco caught the most sardines between the years 1990-2000, with a total catch of 7470 tons caught.

8. Which five countries caught the most cephalopods between 2008-2012?

```r
fisheries_tidy %>% 
  group_by(country) %>%
  select(country, asfis_species_name, catch, year) %>%
  filter(asfis_species_name == "Cephalopoda") %>%
  filter(year >= 2008 & year <= 2012) %>%
  summarise(total_ceph = sum(catch)) %>%
  arrange(desc(total_ceph))
```

```
## # A tibble: 16 × 2
##    country                  total_ceph
##    <fct>                         <dbl>
##  1 India                           570
##  2 China                           257
##  3 Algeria                         162
##  4 France                          101
##  5 TimorLeste                       76
##  6 Italy                            66
##  7 Cambodia                         15
##  8 Taiwan Province of China         13
##  9 Madagascar                       11
## 10 Viet Nam                          0
## 11 Croatia                          NA
## 12 Israel                           NA
## 13 Mauritania                       NA
## 14 Mozambique                       NA
## 15 Somalia                          NA
## 16 Spain                            NA
```
    India (570), China (257), Algeria (162), France (101), and TimoeLeste (76) caught the most cephalapods between 2008 and 2012

9. Which species had the highest catch total between 2008-2012? (hint: Osteichthyes is not a species)

```r
fisheries_tidy %>%
  group_by(asfis_species_number) %>%
  select(year, asfis_species_number, catch, common_name) %>%
  filter(year >= 2008 & year <= 2012) %>%
  summarise(most_caught = sum(catch)) %>%
  left_join(fisheries_tidy  %>%
              filter(year >= 2008 & year <= 2012) %>%
              distinct(asfis_species_number, common_name),
            by = "asfis_species_number" ) %>%
  arrange(desc(most_caught))
```

```
## # A tibble: 1,477 × 3
##    asfis_species_number most_caught common_name                   
##    <fct>                      <dbl> <chr>                         
##  1 1480401601                 41075 Alaska pollock(=Walleye poll.)
##  2 1210600208                 35523 Anchoveta(=Peruvian anchovy)  
##  3 1470200701                  5733 Pacific saury                 
##  4 1210501204                  3849 Indian oil sardine            
##  5 1210501302                  3204 California pilchard           
##  6 1210502404                  3179 Gulf menhaden                 
##  7 2280700903                  2915 Akiami paste shrimp           
##  8 22501XXXXX                  2884 Squillids nei                 
##  9 1702300403                  2710 Japanese jack mackerel        
## 10 1720400204                  2611 Pacific sandlance             
## # ℹ 1,467 more rows
```

```r
fisheries_tidy %>%
  subset(asfis_species_number == "1480401601")
```

```
## # A tibble: 469 × 10
##    country common_name               isscaap_group_number isscaap_taxonomic_gr…¹
##    <fct>   <chr>                     <fct>                <chr>                 
##  1 Canada  Alaska pollock(=Walleye … 32                   Cods, hakes, haddocks 
##  2 Canada  Alaska pollock(=Walleye … 32                   Cods, hakes, haddocks 
##  3 Canada  Alaska pollock(=Walleye … 32                   Cods, hakes, haddocks 
##  4 Canada  Alaska pollock(=Walleye … 32                   Cods, hakes, haddocks 
##  5 Canada  Alaska pollock(=Walleye … 32                   Cods, hakes, haddocks 
##  6 Canada  Alaska pollock(=Walleye … 32                   Cods, hakes, haddocks 
##  7 Canada  Alaska pollock(=Walleye … 32                   Cods, hakes, haddocks 
##  8 Canada  Alaska pollock(=Walleye … 32                   Cods, hakes, haddocks 
##  9 Canada  Alaska pollock(=Walleye … 32                   Cods, hakes, haddocks 
## 10 Canada  Alaska pollock(=Walleye … 32                   Cods, hakes, haddocks 
## # ℹ 459 more rows
## # ℹ abbreviated name: ¹​isscaap_taxonomic_group
## # ℹ 6 more variables: asfis_species_number <fct>, asfis_species_name <chr>,
## #   fao_major_fishing_area <fct>, measure <chr>, year <dbl>, catch <dbl>
```
    Alaska Pollock, Peruvian anchovy, Pacific saury, Indian oil sardine, and California plichard were the most caught species between 2008 and 2012.
 
 
10. Use the data to do at least one analysis of your choice.
    
    I will be analzying what the country with the highest total catch amount is
    

```r
fisheries_tidy %>%
  group_by(country) %>%
  select(country, year, catch) %>%
  summarise(total_catch_country= sum(catch, na.rm =T)) %>%
  arrange(desc(total_catch_country))
```

```
## # A tibble: 203 × 2
##    country                  total_catch_country
##    <fct>                                  <dbl>
##  1 Japan                                 814843
##  2 China                                 735938
##  3 United States of America              623994
##  4 Peru                                  599508
##  5 Chile                                 366808
##  6 Un. Sov. Soc. Rep.                    360127
##  7 Norway                                300947
##  8 Russian Federation                    270219
##  9 Korea, Republic of                    253734
## 10 Indonesia                             253476
## # ℹ 193 more rows
```
    Japan has the highest total catch with an all time total of 814,843 tons of total catch.


## Push your final code to GitHub!
Please be sure that you check the `keep md` file in the knit preferences.   
