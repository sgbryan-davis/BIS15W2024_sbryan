---
title: "`mutate()`, and `if_else()`"
date: "2024-01-30"
output:
  html_document: 
    theme: spacelab
    toc: yes
    toc_float: yes
    keep_md: yes
  pdf_document:
    toc: yes
---

## Learning Goals
*At the end of this exercise, you will be able to:*    
1. Use `mutate()` to add columns in a dataframe.  
2. Use `mutate()` and `if_else()` to replace values in a dataframe.  

## Load the libraries

```r
library("tidyverse")
library("janitor")
```

## Load the data
For this lab, we will use the following two datasets:  

1. 1. Gaeta J., G. Sass, S. Carpenter. 2012. Biocomplexity at North Temperate Lakes LTER: Coordinated Field Studies: Large Mouth Bass Growth 2006. Environmental Data Initiative.   [link](https://portal.edirepository.org/nis/mapbrowse?scope=knb-lter-ntl&identifier=267)  

2. S. K. Morgan Ernest. 2003. Life history characteristics of placental non-volant mammals. Ecology 84:3402.   [link](http://esapubs.org/archive/ecol/E084/093/)  

## Pipes `%>%` 
Recall that we use pipes to connect the output of code to a subsequent function. This makes our code cleaner and more efficient. One way we can use pipes is to attach the `clean_names()` function from janitor to the `read_csv()` output.  

```r
fish <- readr::read_csv("data/Gaeta_etal_CLC_data.csv") %>% clean_names()
```

```
## Rows: 4033 Columns: 6
## ── Column specification ────────────────────────────────────────────────────────
## Delimiter: ","
## chr (2): lakeid, annnumber
## dbl (4): fish_id, length, radii_length_mm, scalelength
## 
## ℹ Use `spec()` to retrieve the full column specification for this data.
## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
```


```r
mammals <- read_csv("data/mammal_lifehistories_v2.csv") %>% clean_names() #automatically cleans names when reading the .csv's
```

```
## Rows: 1440 Columns: 13
## ── Column specification ────────────────────────────────────────────────────────
## Delimiter: ","
## chr (4): order, family, Genus, species
## dbl (9): mass, gestation, newborn, weaning, wean mass, AFR, max. life, litte...
## 
## ℹ Use `spec()` to retrieve the full column specification for this data.
## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
```

```r
names(mammals)
```

```
##  [1] "order"        "family"       "genus"        "species"      "mass"        
##  [6] "gestation"    "newborn"      "weaning"      "wean_mass"    "afr"         
## [11] "max_life"     "litter_size"  "litters_year"
```

## `mutate()`  
Mutate allows us to create a new column from existing columns in a data frame. We are doing a small introduction here and will add some additional functions later. Let's convert the length variable from cm to millimeters and create a new variable called length_mm.  

```r
fish %>% 
  mutate(length_mm = length*10) %>% #creates new columns within the data frame 
  select(fish_id, length, length_mm)
```

```
## # A tibble: 4,033 × 3
##    fish_id length length_mm
##      <dbl>  <dbl>     <dbl>
##  1     299    167      1670
##  2     299    167      1670
##  3     299    167      1670
##  4     300    175      1750
##  5     300    175      1750
##  6     300    175      1750
##  7     300    175      1750
##  8     301    194      1940
##  9     301    194      1940
## 10     301    194      1940
## # ℹ 4,023 more rows
```

## Practice
1. Use `mutate()` to make a new column that is the half length of each fish: length_half = length/2. Select only fish_id, length, and length_half.

```r
fish %>%
  mutate(half_length=length/2)%>%
  select(fish_id, length, half_length)
```

```
## # A tibble: 4,033 × 3
##    fish_id length half_length
##      <dbl>  <dbl>       <dbl>
##  1     299    167        83.5
##  2     299    167        83.5
##  3     299    167        83.5
##  4     300    175        87.5
##  5     300    175        87.5
##  6     300    175        87.5
##  7     300    175        87.5
##  8     301    194        97  
##  9     301    194        97  
## 10     301    194        97  
## # ℹ 4,023 more rows
```

## `mutate_all()`
This last function is super helpful when cleaning data. With "wild" data, there are often mixed entries (upper and lowercase), blank spaces, odd characters, etc. These all need to be dealt with before analysis.  

Here is an example that changes all entries to lowercase (if present).  

```r
mammals
```

```
## # A tibble: 1,440 × 13
##    order  family genus species   mass gestation newborn weaning wean_mass    afr
##    <chr>  <chr>  <chr> <chr>    <dbl>     <dbl>   <dbl>   <dbl>     <dbl>  <dbl>
##  1 Artio… Antil… Anti… americ… 4.54e4      8.13   3246.    3         8900   13.5
##  2 Artio… Bovid… Addax nasoma… 1.82e5      9.39   5480     6.5       -999   27.3
##  3 Artio… Bovid… Aepy… melamp… 4.15e4      6.35   5093     5.63     15900   16.7
##  4 Artio… Bovid… Alce… busela… 1.5 e5      7.9   10167.    6.5       -999   23.0
##  5 Artio… Bovid… Ammo… clarkei 2.85e4      6.8    -999  -999         -999 -999  
##  6 Artio… Bovid… Ammo… lervia  5.55e4      5.08   3810     4         -999   14.9
##  7 Artio… Bovid… Anti… marsup… 3   e4      5.72   3910     4.04      -999   10.2
##  8 Artio… Bovid… Anti… cervic… 3.75e4      5.5    3846     2.13      -999   20.1
##  9 Artio… Bovid… Bison bison   4.98e5      8.93  20000    10.7     157500   29.4
## 10 Artio… Bovid… Bison bonasus 5   e5      9.14  23000.    6.6       -999   30.0
## # ℹ 1,430 more rows
## # ℹ 3 more variables: max_life <dbl>, litter_size <dbl>, litters_year <dbl>
```


```r
mammals %>%
  mutate_all(tolower) #makes all observations lowercase
```

```
## # A tibble: 1,440 × 13
##    order    family genus species mass  gestation newborn weaning wean_mass afr  
##    <chr>    <chr>  <chr> <chr>   <chr> <chr>     <chr>   <chr>   <chr>     <chr>
##  1 artioda… antil… anti… americ… 45375 8.13      3246.36 3       8900      13.53
##  2 artioda… bovid… addax nasoma… 1823… 9.39      5480    6.5     -999      27.27
##  3 artioda… bovid… aepy… melamp… 41480 6.35      5093    5.63    15900     16.66
##  4 artioda… bovid… alce… busela… 1500… 7.9       10166.… 6.5     -999      23.02
##  5 artioda… bovid… ammo… clarkei 28500 6.8       -999    -999    -999      -999 
##  6 artioda… bovid… ammo… lervia  55500 5.08      3810    4       -999      14.89
##  7 artioda… bovid… anti… marsup… 30000 5.72      3910    4.04    -999      10.23
##  8 artioda… bovid… anti… cervic… 37500 5.5       3846    2.13    -999      20.13
##  9 artioda… bovid… bison bison   4976… 8.93      20000   10.71   157500    29.45
## 10 artioda… bovid… bison bonasus 5e+05 9.14      23000.… 6.6     -999      29.99
## # ℹ 1,430 more rows
## # ℹ 3 more variables: max_life <chr>, litter_size <chr>, litters_year <chr>
```

Using the across function we can specify individual columns.

```r
mammals %>% 
  mutate(across(c("order", "family"), tolower)) #makes certain columns lowercase
```

```
## # A tibble: 1,440 × 13
##    order  family genus species   mass gestation newborn weaning wean_mass    afr
##    <chr>  <chr>  <chr> <chr>    <dbl>     <dbl>   <dbl>   <dbl>     <dbl>  <dbl>
##  1 artio… antil… Anti… americ… 4.54e4      8.13   3246.    3         8900   13.5
##  2 artio… bovid… Addax nasoma… 1.82e5      9.39   5480     6.5       -999   27.3
##  3 artio… bovid… Aepy… melamp… 4.15e4      6.35   5093     5.63     15900   16.7
##  4 artio… bovid… Alce… busela… 1.5 e5      7.9   10167.    6.5       -999   23.0
##  5 artio… bovid… Ammo… clarkei 2.85e4      6.8    -999  -999         -999 -999  
##  6 artio… bovid… Ammo… lervia  5.55e4      5.08   3810     4         -999   14.9
##  7 artio… bovid… Anti… marsup… 3   e4      5.72   3910     4.04      -999   10.2
##  8 artio… bovid… Anti… cervic… 3.75e4      5.5    3846     2.13      -999   20.1
##  9 artio… bovid… Bison bison   4.98e5      8.93  20000    10.7     157500   29.4
## 10 artio… bovid… Bison bonasus 5   e5      9.14  23000.    6.6       -999   30.0
## # ℹ 1,430 more rows
## # ℹ 3 more variables: max_life <dbl>, litter_size <dbl>, litters_year <dbl>
```

## `if_else()`
We will briefly introduce `if_else()` here because it allows us to use `mutate()` but not have the entire column affected in the same way. In a sense, this can function like find and replace in a spreadsheet program. With `ifelse()`, you first specify a logical statement, afterwards what needs to happen if the statement returns `TRUE`, and lastly what needs to happen if it's  `FALSE`.  

Have a look at the data from mammals below. Notice that the values for newborn include `-999.00`. This is sometimes used as a placeholder for NA (but, is a really bad idea). We can use `if_else()` to replace `-999.00` with `NA`.  
# super good for cleaning data 

```r
mammals %>% 
  select(genus, species, newborn) %>% 
  arrange(newborn)
```

```
## # A tibble: 1,440 × 3
##    genus       species        newborn
##    <chr>       <chr>            <dbl>
##  1 Ammodorcas  clarkei           -999
##  2 Bos         javanicus         -999
##  3 Bubalus     depressicornis    -999
##  4 Bubalus     mindorensis       -999
##  5 Capra       falconeri         -999
##  6 Cephalophus niger             -999
##  7 Cephalophus nigrifrons        -999
##  8 Cephalophus natalensis        -999
##  9 Cephalophus leucogaster       -999
## 10 Cephalophus ogilbyi           -999
## # ℹ 1,430 more rows
```


```r
mammals %>% 
  select(genus, species, newborn) %>%
  mutate(newborn_new = ifelse(newborn == -999.00, NA, newborn))%>% # "if = -999.00 it will put NA, if anything but -999.00, it will leave newborn data
  arrange(newborn) #neveroverwrite old data, always make a new variable 
```

```
## # A tibble: 1,440 × 4
##    genus       species        newborn newborn_new
##    <chr>       <chr>            <dbl>       <dbl>
##  1 Ammodorcas  clarkei           -999          NA
##  2 Bos         javanicus         -999          NA
##  3 Bubalus     depressicornis    -999          NA
##  4 Bubalus     mindorensis       -999          NA
##  5 Capra       falconeri         -999          NA
##  6 Cephalophus niger             -999          NA
##  7 Cephalophus nigrifrons        -999          NA
##  8 Cephalophus natalensis        -999          NA
##  9 Cephalophus leucogaster       -999          NA
## 10 Cephalophus ogilbyi           -999          NA
## # ℹ 1,430 more rows
```

## Practice
1. We are interested in the family, genus, species and max life variables. Because the max life span for several mammals is unknown, the authors have use -999 in place of NA. Replace all of these values with NA in a new column titled `max_life_new`. Finally, sort the date in descending order by max_life_new. Which mammal has the oldest known life span?

```r
names(mammals)
```

```
##  [1] "order"        "family"       "genus"        "species"      "mass"        
##  [6] "gestation"    "newborn"      "weaning"      "wean_mass"    "afr"         
## [11] "max_life"     "litter_size"  "litters_year"
```

```r
mammals %>%
  select(family, genus, species, max_life) %>%
  mutate(max_life_new = ifelse(max_life == -999.00, NA, max_life )) %>% 
  arrange(max_life_new)
```

```
## # A tibble: 1,440 × 5
##    family    genus    species        max_life max_life_new
##    <chr>     <chr>    <chr>             <dbl>        <dbl>
##  1 Muridae   Myopus   schisticolor         12           12
##  2 Soricidae Sorex    longirostris         14           14
##  3 Muridae   Microtus longicaudus          14           14
##  4 Soricidae Myosorex varius               16           16
##  5 Muridae   Microtus pennsylvanicus       16           16
##  6 Soricidae Sorex    fumeus               17           17
##  7 Soricidae Sorex    arcticus             18           18
##  8 Soricidae Sorex    ornatus              18           18
##  9 Soricidae Sorex    monticolus           18           18
## 10 Soricidae Sorex    trowbridgii          18           18
## # ℹ 1,430 more rows
```

## That's it! Let's take a break and then move on to part 2! 

-->[Home](https://jmledford3115.github.io/datascibiol/)  
