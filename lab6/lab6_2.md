---
title: "dplyr Superhero"
date: "2024-01-30"
output:
  html_document: 
    theme: spacelab
    toc: yes
    toc_float: yes
    keep_md: yes
---

## Learning Goals  
*At the end of this exercise, you will be able to:*    
1. Develop your dplyr superpowers so you can easily and confidently manipulate dataframes.  
2. Learn helpful new functions that are part of the `janitor` package.  

## Instructions
For the second part of lab today, we are going to spend time practicing the dplyr functions we have learned and add a few new ones. This lab doubles as your homework. Please complete the lab and push your final code to GitHub.  

## Load the libraries

```r
library("tidyverse")
```

```
## ── Attaching core tidyverse packages ──────────────────────── tidyverse 2.0.0 ──
## ✔ dplyr     1.1.4     ✔ readr     2.1.4
## ✔ forcats   1.0.0     ✔ stringr   1.5.1
## ✔ ggplot2   3.4.4     ✔ tibble    3.2.1
## ✔ lubridate 1.9.3     ✔ tidyr     1.3.0
## ✔ purrr     1.0.2     
## ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
## ✖ dplyr::filter() masks stats::filter()
## ✖ dplyr::lag()    masks stats::lag()
## ℹ Use the conflicted package (<http://conflicted.r-lib.org/>) to force all conflicts to become errors
```

```r
library("janitor")
```

```
## 
## Attaching package: 'janitor'
## 
## The following objects are masked from 'package:stats':
## 
##     chisq.test, fisher.test
```

## Load the superhero data
These are data taken from comic books and assembled by fans. The include a good mix of categorical and continuous data.  Data taken from: https://www.kaggle.com/claudiodavi/superhero-set  

Check out the way I am loading these data. If I know there are NAs, I can take care of them at the beginning. But, we should do this very cautiously. At times it is better to keep the original columns and data intact.  

```r
superhero_info <- read_csv("data/heroes_information.csv", na = c("", "-99", "-")) #this tells R what you want to interpret as an NA, wait until you understand that data before mutating it and chnaging studd
```

```
## Rows: 734 Columns: 10
## ── Column specification ────────────────────────────────────────────────────────
## Delimiter: ","
## chr (8): name, Gender, Eye color, Race, Hair color, Publisher, Skin color, A...
## dbl (2): Height, Weight
## 
## ℹ Use `spec()` to retrieve the full column specification for this data.
## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
```

```r
superhero_powers <- read_csv("data/super_hero_powers.csv", na = c("", "-99", "-"))
```

```
## Rows: 667 Columns: 168
## ── Column specification ────────────────────────────────────────────────────────
## Delimiter: ","
## chr   (1): hero_names
## lgl (167): Agility, Accelerated Healing, Lantern Power Ring, Dimensional Awa...
## 
## ℹ Use `spec()` to retrieve the full column specification for this data.
## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
```

## Data tidy
1. Some of the names used in the `superhero_info` data are problematic so you should rename them here. Before you do anything, first have a look at the names of the variables. You can use `rename()` or `clean_names()`.    

## `tabyl`
The `janitor` package has many awesome functions that we will explore. Here is its version of `table` which not only produces counts but also percentages. Very handy! Let's use it to explore the proportion of good guys and bad guys in the `superhero_info` data.  

```r
superhero_info %>%
  mutate_all(tolower)
```

```
## # A tibble: 734 × 10
##    name      Gender `Eye color` Race  `Hair color` Height Publisher `Skin color`
##    <chr>     <chr>  <chr>       <chr> <chr>        <chr>  <chr>     <chr>       
##  1 a-bomb    male   yellow      human no hair      203    marvel c… <NA>        
##  2 abe sapi… male   blue        icth… no hair      191    dark hor… blue        
##  3 abin sur  male   blue        unga… no hair      185    dc comics red         
##  4 abominat… male   green       huma… no hair      203    marvel c… <NA>        
##  5 abraxas   male   blue        cosm… black        <NA>   marvel c… <NA>        
##  6 absorbin… male   blue        human no hair      193    marvel c… <NA>        
##  7 adam mon… male   blue        <NA>  blond        <NA>   nbc - he… <NA>        
##  8 adam str… male   blue        human blond        185    dc comics <NA>        
##  9 agent 13  female blue        <NA>  blond        173    marvel c… <NA>        
## 10 agent bob male   brown       human brown        178    marvel c… <NA>        
## # ℹ 724 more rows
## # ℹ 2 more variables: Alignment <chr>, Weight <chr>
```

```r
# superhero_info <- tidy_names(superhero_info)
tabyl(superhero_info, Alignment)
```

```
##  Alignment   n     percent valid_percent
##        bad 207 0.282016349    0.28473177
##       good 496 0.675749319    0.68225585
##    neutral  24 0.032697548    0.03301238
##       <NA>   7 0.009536785            NA
```

1. Who are the publishers of the superheros? Show the proportion of superheros from each publisher. Which publisher has the highest number of superheros?  

```r
tabyl(superhero_info$Publisher)
```

```
##  superhero_info$Publisher   n     percent valid_percent
##               ABC Studios   4 0.005449591   0.005563282
##                 DC Comics 215 0.292915531   0.299026426
##         Dark Horse Comics  18 0.024523161   0.025034771
##              George Lucas  14 0.019073569   0.019471488
##             Hanna-Barbera   1 0.001362398   0.001390821
##             HarperCollins   6 0.008174387   0.008344924
##            IDW Publishing   4 0.005449591   0.005563282
##               Icon Comics   4 0.005449591   0.005563282
##              Image Comics  14 0.019073569   0.019471488
##             J. K. Rowling   1 0.001362398   0.001390821
##          J. R. R. Tolkien   1 0.001362398   0.001390821
##             Marvel Comics 388 0.528610354   0.539638387
##                 Microsoft   1 0.001362398   0.001390821
##              NBC - Heroes  19 0.025885559   0.026425591
##                 Rebellion   1 0.001362398   0.001390821
##                  Shueisha   4 0.005449591   0.005563282
##             Sony Pictures   2 0.002724796   0.002781641
##                South Park   1 0.001362398   0.001390821
##                 Star Trek   6 0.008174387   0.008344924
##                      SyFy   5 0.006811989   0.006954103
##              Team Epic TV   5 0.006811989   0.006954103
##               Titan Books   1 0.001362398   0.001390821
##         Universal Studios   1 0.001362398   0.001390821
##                 Wildstorm   3 0.004087193   0.004172462
##                      <NA>  15 0.020435967            NA
```

2. Notice that we have some neutral superheros! Who are they? List their names below.  

```r
superhero_info %>% 
  filter(Alignment == "neutral") %>%
  arrange(name)
```

```
## # A tibble: 24 × 10
##    name      Gender `Eye color` Race  `Hair color` Height Publisher `Skin color`
##    <chr>     <chr>  <chr>       <chr> <chr>         <dbl> <chr>     <chr>       
##  1 Bizarro   Male   black       Biza… Black           191 DC Comics white       
##  2 Black Fl… Male   <NA>        God … <NA>             NA DC Comics <NA>        
##  3 Captain … Male   brown       Human Brown            NA DC Comics <NA>        
##  4 Copycat   Female red         Muta… White           183 Marvel C… blue        
##  5 Deadpool  Male   brown       Muta… No Hair         188 Marvel C… <NA>        
##  6 Deathstr… Male   blue        Human White           193 DC Comics <NA>        
##  7 Etrigan   Male   red         Demon No Hair         193 DC Comics yellow      
##  8 Galactus  Male   black       Cosm… Black           876 Marvel C… <NA>        
##  9 Gladiator Male   blue        Stro… Blue            198 Marvel C… purple      
## 10 Indigo    Female <NA>        Alien Purple           NA DC Comics <NA>        
## # ℹ 14 more rows
## # ℹ 2 more variables: Alignment <chr>, Weight <dbl>
```

## `superhero_info`
3. Let's say we are only interested in the variables name, alignment, and "race". How would you isolate these variables from `superhero_info`?

```r
superhero_info %>%
  select(name, Alignment, Race)
```

```
## # A tibble: 734 × 3
##    name          Alignment Race             
##    <chr>         <chr>     <chr>            
##  1 A-Bomb        good      Human            
##  2 Abe Sapien    good      Icthyo Sapien    
##  3 Abin Sur      good      Ungaran          
##  4 Abomination   bad       Human / Radiation
##  5 Abraxas       bad       Cosmic Entity    
##  6 Absorbing Man bad       Human            
##  7 Adam Monroe   good      <NA>             
##  8 Adam Strange  good      Human            
##  9 Agent 13      good      <NA>             
## 10 Agent Bob     good      Human            
## # ℹ 724 more rows
```

## Not Human
4. List all of the superheros that are not human.

```r
superhero_info %>%
  filter(Race == "Human")
```

```
## # A tibble: 208 × 10
##    name      Gender `Eye color` Race  `Hair color` Height Publisher `Skin color`
##    <chr>     <chr>  <chr>       <chr> <chr>         <dbl> <chr>     <chr>       
##  1 A-Bomb    Male   yellow      Human No Hair         203 Marvel C… <NA>        
##  2 Absorbin… Male   blue        Human No Hair         193 Marvel C… <NA>        
##  3 Adam Str… Male   blue        Human Blond           185 DC Comics <NA>        
##  4 Agent Bob Male   brown       Human Brown           178 Marvel C… <NA>        
##  5 Alex Mer… Male   <NA>        Human <NA>             NA Wildstorm <NA>        
##  6 Alfred P… Male   blue        Human Black           178 DC Comics <NA>        
##  7 Ammo      Male   brown       Human Black           188 Marvel C… <NA>        
##  8 Animal M… Male   blue        Human Blond           183 DC Comics <NA>        
##  9 Ant-Man   Male   blue        Human Blond           211 Marvel C… <NA>        
## 10 Ant-Man … Male   blue        Human Blond           183 Marvel C… <NA>        
## # ℹ 198 more rows
## # ℹ 2 more variables: Alignment <chr>, Weight <dbl>
```

## Good and Evil
5. Let's make two different data frames, one focused on the "good guys" and another focused on the "bad guys".

```r
good <- superhero_info %>%
  filter(Alignment == "good")
bad <- superhero_info %>%
  filter(Alignment == "bad")
```

6. For the good guys, use the `tabyl` function to summarize their "race".

```r
tabyl(good, Race)
```

```
##               Race   n     percent valid_percent
##              Alien   3 0.006048387   0.010752688
##              Alpha   5 0.010080645   0.017921147
##             Amazon   2 0.004032258   0.007168459
##            Android   4 0.008064516   0.014336918
##             Animal   2 0.004032258   0.007168459
##          Asgardian   3 0.006048387   0.010752688
##          Atlantean   4 0.008064516   0.014336918
##         Bolovaxian   1 0.002016129   0.003584229
##              Clone   1 0.002016129   0.003584229
##             Cyborg   3 0.006048387   0.010752688
##           Demi-God   2 0.004032258   0.007168459
##              Demon   3 0.006048387   0.010752688
##            Eternal   1 0.002016129   0.003584229
##     Flora Colossus   1 0.002016129   0.003584229
##        Frost Giant   1 0.002016129   0.003584229
##      God / Eternal   6 0.012096774   0.021505376
##             Gungan   1 0.002016129   0.003584229
##              Human 148 0.298387097   0.530465950
##    Human / Altered   2 0.004032258   0.007168459
##     Human / Cosmic   2 0.004032258   0.007168459
##  Human / Radiation   8 0.016129032   0.028673835
##         Human-Kree   2 0.004032258   0.007168459
##      Human-Spartoi   1 0.002016129   0.003584229
##       Human-Vulcan   1 0.002016129   0.003584229
##    Human-Vuldarian   1 0.002016129   0.003584229
##      Icthyo Sapien   1 0.002016129   0.003584229
##            Inhuman   4 0.008064516   0.014336918
##    Kakarantharaian   1 0.002016129   0.003584229
##         Kryptonian   4 0.008064516   0.014336918
##            Martian   1 0.002016129   0.003584229
##          Metahuman   1 0.002016129   0.003584229
##             Mutant  46 0.092741935   0.164874552
##     Mutant / Clone   1 0.002016129   0.003584229
##             Planet   1 0.002016129   0.003584229
##             Saiyan   1 0.002016129   0.003584229
##           Symbiote   3 0.006048387   0.010752688
##           Talokite   1 0.002016129   0.003584229
##         Tamaranean   1 0.002016129   0.003584229
##            Ungaran   1 0.002016129   0.003584229
##            Vampire   2 0.004032258   0.007168459
##     Yoda's species   1 0.002016129   0.003584229
##      Zen-Whoberian   1 0.002016129   0.003584229
##               <NA> 217 0.437500000            NA
```

7. Among the good guys, Who are the Vampires?

```r
good %>%
  select(name, Race) %>%
  filter(Race == "Vampire")
```

```
## # A tibble: 2 × 2
##   name  Race   
##   <chr> <chr>  
## 1 Angel Vampire
## 2 Blade Vampire
```

8. Among the bad guys, who are the male humans over 200 inches in height?

```r
bad %>%
  filter(Gender== "Male") %>%
  filter(Race== "Human") %>%
  filter(Height > 200)
```

```
## # A tibble: 5 × 10
##   name       Gender `Eye color` Race  `Hair color` Height Publisher `Skin color`
##   <chr>      <chr>  <chr>       <chr> <chr>         <dbl> <chr>     <chr>       
## 1 Bane       Male   <NA>        Human <NA>            203 DC Comics <NA>        
## 2 Doctor Do… Male   brown       Human Brown           201 Marvel C… <NA>        
## 3 Kingpin    Male   blue        Human No Hair         201 Marvel C… <NA>        
## 4 Lizard     Male   red         Human No Hair         203 Marvel C… <NA>        
## 5 Scorpion   Male   brown       Human Brown           211 Marvel C… <NA>        
## # ℹ 2 more variables: Alignment <chr>, Weight <dbl>
```

9. Are there more good guys or bad guys with green hair?  

10. Let's explore who the really small superheros are. In the `superhero_info` data, which have a weight less than 50? Be sure to sort your results by weight lowest to highest.  

11. Let's make a new variable that is the ratio of height to weight. Call this variable `height_weight_ratio`.    

12. Who has the highest height to weight ratio?  

## `superhero_powers`
Have a quick look at the `superhero_powers` data frame.  

13. How many superheros have a combination of agility, stealth, super_strength, stamina?

## Your Favorite
14. Pick your favorite superhero and let's see their powers!  

15. Can you find your hero in the superhero_info data? Show their info!  

## Push your final code to GitHub!
Please be sure that you check the `keep md` file in the knit preferences.  
