---
title: "BIS 15L Midterm 2"
output:
  html_document: 
    theme: spacelab
    keep_md: true
---



## Instructions
Answer the following questions and complete the exercises in RMarkdown. Please embed all of your code and push your final work to your repository. Your code should be organized, clean, and run free from errors. Remember, you must remove the `#` for any included code chunks to run. Be sure to add your name to the author header above.  

Make sure to use the formatting conventions of RMarkdown to make your report neat and clean! Use the tidyverse and pipes unless otherwise indicated. To receive full credit, all plots must have clearly labeled axes, a title, and consistent aesthetics. This exam is worth a total of 35 points. 

Please load the following libraries.

```r
library("tidyverse")
library("janitor")
library("naniar")
library(ggplot2)
```

## Data
These data are from a study on surgical residents. The study was originally published by Sessier et al. “Operation Timing and 30-Day Mortality After Elective General Surgery”. Anesth Analg 2011; 113: 1423-8. The data were cleaned for instructional use by Amy S. Nowacki, “Surgery Timing Dataset”, TSHS Resources Portal (2016). Available at https://www.causeweb.org/tshs/surgery-timing/.

Descriptions of the variables and the study are included as pdf's in the data folder.  

Please run the following chunk to import the data.

```r
surgery <- read_csv("data/surgery.csv")
```

1. Use the summary function(s) of your choice to explore the data and get an idea of its structure. Please also check for NA's.


```r
glimpse(surgery)
```

```
## Rows: 32,001
## Columns: 25
## $ ahrq_ccs            <chr> "<Other>", "<Other>", "<Other>", "<Other>", "<Othe…
## $ age                 <dbl> 67.8, 39.5, 56.5, 71.0, 56.3, 57.7, 56.6, 64.2, 66…
## $ gender              <chr> "M", "F", "F", "M", "M", "F", "M", "F", "M", "F", …
## $ race                <chr> "Caucasian", "Caucasian", "Caucasian", "Caucasian"…
## $ asa_status          <chr> "I-II", "I-II", "I-II", "III", "I-II", "I-II", "IV…
## $ bmi                 <dbl> 28.04, 37.85, 19.56, 32.22, 24.32, 40.30, 64.57, 4…
## $ baseline_cancer     <chr> "No", "No", "No", "No", "Yes", "No", "No", "No", "…
## $ baseline_cvd        <chr> "Yes", "Yes", "No", "Yes", "No", "Yes", "Yes", "Ye…
## $ baseline_dementia   <chr> "No", "No", "No", "No", "No", "No", "No", "No", "N…
## $ baseline_diabetes   <chr> "No", "No", "No", "No", "No", "No", "Yes", "No", "…
## $ baseline_digestive  <chr> "Yes", "No", "No", "No", "No", "No", "No", "No", "…
## $ baseline_osteoart   <chr> "No", "No", "No", "No", "No", "No", "No", "No", "N…
## $ baseline_psych      <chr> "No", "No", "No", "No", "No", "Yes", "No", "No", "…
## $ baseline_pulmonary  <chr> "No", "No", "No", "No", "No", "No", "No", "No", "N…
## $ baseline_charlson   <dbl> 0, 0, 0, 0, 0, 0, 2, 0, 1, 2, 0, 1, 0, 0, 0, 0, 0,…
## $ mortality_rsi       <dbl> -0.63, -0.63, -0.49, -1.38, 0.00, -0.77, -0.36, -0…
## $ complication_rsi    <dbl> -0.26, -0.26, 0.00, -1.15, 0.00, -0.84, -1.34, 0.0…
## $ ccsmort30rate       <dbl> 0.0042508, 0.0042508, 0.0042508, 0.0042508, 0.0042…
## $ ccscomplicationrate <dbl> 0.07226355, 0.07226355, 0.07226355, 0.07226355, 0.…
## $ hour                <dbl> 9.03, 18.48, 7.88, 8.80, 12.20, 7.67, 9.53, 7.52, …
## $ dow                 <chr> "Mon", "Wed", "Fri", "Wed", "Thu", "Thu", "Tue", "…
## $ month               <chr> "Nov", "Sep", "Aug", "Jun", "Aug", "Dec", "Apr", "…
## $ moonphase           <chr> "Full Moon", "New Moon", "Full Moon", "Last Quarte…
## $ mort30              <chr> "No", "No", "No", "No", "No", "No", "No", "No", "N…
## $ complication        <chr> "No", "No", "No", "No", "No", "No", "No", "Yes", "…
```

```r
head(surgery)
```

```
## # A tibble: 6 × 25
##   ahrq_ccs   age gender race       asa_status   bmi baseline_cancer baseline_cvd
##   <chr>    <dbl> <chr>  <chr>      <chr>      <dbl> <chr>           <chr>       
## 1 <Other>   67.8 M      Caucasian  I-II        28.0 No              Yes         
## 2 <Other>   39.5 F      Caucasian  I-II        37.8 No              Yes         
## 3 <Other>   56.5 F      Caucasian  I-II        19.6 No              No          
## 4 <Other>   71   M      Caucasian  III         32.2 No              Yes         
## 5 <Other>   56.3 M      African A… I-II        24.3 Yes             No          
## 6 <Other>   57.7 F      Caucasian  I-II        40.3 No              Yes         
## # ℹ 17 more variables: baseline_dementia <chr>, baseline_diabetes <chr>,
## #   baseline_digestive <chr>, baseline_osteoart <chr>, baseline_psych <chr>,
## #   baseline_pulmonary <chr>, baseline_charlson <dbl>, mortality_rsi <dbl>,
## #   complication_rsi <dbl>, ccsmort30rate <dbl>, ccscomplicationrate <dbl>,
## #   hour <dbl>, dow <chr>, month <chr>, moonphase <chr>, mort30 <chr>,
## #   complication <chr>
```

```r
names(surgery)
```

```
##  [1] "ahrq_ccs"            "age"                 "gender"             
##  [4] "race"                "asa_status"          "bmi"                
##  [7] "baseline_cancer"     "baseline_cvd"        "baseline_dementia"  
## [10] "baseline_diabetes"   "baseline_digestive"  "baseline_osteoart"  
## [13] "baseline_psych"      "baseline_pulmonary"  "baseline_charlson"  
## [16] "mortality_rsi"       "complication_rsi"    "ccsmort30rate"      
## [19] "ccscomplicationrate" "hour"                "dow"                
## [22] "month"               "moonphase"           "mort30"             
## [25] "complication"
```

```r
summary(surgery)
```

```
##    ahrq_ccs              age           gender              race          
##  Length:32001       Min.   : 1.00   Length:32001       Length:32001      
##  Class :character   1st Qu.:48.20   Class :character   Class :character  
##  Mode  :character   Median :58.60   Mode  :character   Mode  :character  
##                     Mean   :57.66                                        
##                     3rd Qu.:68.30                                        
##                     Max.   :90.00                                        
##                     NA's   :2                                            
##   asa_status             bmi        baseline_cancer    baseline_cvd      
##  Length:32001       Min.   : 2.15   Length:32001       Length:32001      
##  Class :character   1st Qu.:24.60   Class :character   Class :character  
##  Mode  :character   Median :28.19   Mode  :character   Mode  :character  
##                     Mean   :29.45                                        
##                     3rd Qu.:32.81                                        
##                     Max.   :92.59                                        
##                     NA's   :3290                                         
##  baseline_dementia  baseline_diabetes  baseline_digestive baseline_osteoart 
##  Length:32001       Length:32001       Length:32001       Length:32001      
##  Class :character   Class :character   Class :character   Class :character  
##  Mode  :character   Mode  :character   Mode  :character   Mode  :character  
##                                                                             
##                                                                             
##                                                                             
##                                                                             
##  baseline_psych     baseline_pulmonary baseline_charlson mortality_rsi    
##  Length:32001       Length:32001       Min.   : 0.000    Min.   :-4.4000  
##  Class :character   Class :character   1st Qu.: 0.000    1st Qu.:-1.2400  
##  Mode  :character   Mode  :character   Median : 0.000    Median :-0.3000  
##                                        Mean   : 1.184    Mean   :-0.5316  
##                                        3rd Qu.: 2.000    3rd Qu.: 0.0000  
##                                        Max.   :13.000    Max.   : 4.8600  
##                                                                           
##  complication_rsi  ccsmort30rate      ccscomplicationrate      hour      
##  Min.   :-4.7200   Min.   :0.000000   Min.   :0.01612     Min.   : 6.00  
##  1st Qu.:-0.8400   1st Qu.:0.000789   1st Qu.:0.08198     1st Qu.: 7.65  
##  Median :-0.2700   Median :0.002764   Median :0.10937     Median : 9.65  
##  Mean   :-0.4091   Mean   :0.004312   Mean   :0.13325     Mean   :10.38  
##  3rd Qu.: 0.0000   3rd Qu.:0.007398   3rd Qu.:0.18337     3rd Qu.:12.72  
##  Max.   :13.3000   Max.   :0.016673   Max.   :0.46613     Max.   :19.00  
##                                                                          
##      dow               month            moonphase            mort30         
##  Length:32001       Length:32001       Length:32001       Length:32001      
##  Class :character   Class :character   Class :character   Class :character  
##  Mode  :character   Mode  :character   Mode  :character   Mode  :character  
##                                                                             
##                                                                             
##                                                                             
##                                                                             
##  complication      
##  Length:32001      
##  Class :character  
##  Mode  :character  
##                    
##                    
##                    
## 
```

2. Let's explore the participants in the study. Show a count of participants by race AND make a plot that visually represents your output.

    Table count

```r
surgery %>%
  group_by(race) %>%
  summarise(number_participant = n())
```

```
## # A tibble: 4 × 2
##   race             number_participant
##   <chr>                         <int>
## 1 African American               3790
## 2 Caucasian                     26488
## 3 Other                          1243
## 4 <NA>                            480
```


```r
surgery %>%
  group_by(race) %>%
  filter(race != "na") %>%
  summarise(number_participant = n()) %>%
  ggplot(aes(x= race, y = number_participant, fill = race)) +
  geom_col() +
  labs (title = "Paritcipants by Race",
        x= "Race",
        y= "Number of Participants")
```

![](midterm_2_files/figure-html/unnamed-chunk-5-1.png)<!-- -->
3. What is the mean age of participants by gender? (hint: please provide a number for each) Since only three participants do not have gender indicated, remove these participants from the data.


```r
surgery %>%
  group_by(gender) %>%
  filter(gender != "NA") %>%
  summarise(mean_age = mean(age, na.rm = T))
```

```
## # A tibble: 2 × 2
##   gender mean_age
##   <chr>     <dbl>
## 1 F          56.7
## 2 M          58.8
```

4. Make a plot that shows the range of age associated with gender.


```r
surgery %>%
  group_by(gender) %>%
  filter(gender != "NA") %>%
  ggplot(aes(x= gender, y= age, fill = gender)) +
  geom_boxplot() +
  labs(title = "Age Distribution by Gender",
       x= "Gender", 
       y= "Age (years)") + 
  theme(title = element_text(size = rel(1.5), hjust = 0.5))
```

```
## Warning: Removed 2 rows containing non-finite values (`stat_boxplot()`).
```

![](midterm_2_files/figure-html/unnamed-chunk-7-1.png)<!-- -->

5. How healthy are the participants? The variable `asa_status` is an evaluation of patient physical status prior to surgery. Lower numbers indicate fewer comorbidities (presence of two or more diseases or medical conditions in a patient). Make a plot that compares the number of `asa_status` I-II, III, and IV-V.


```r
surgery %>%
  group_by(asa_status) %>%
  ggplot(aes(asa_status, fill= asa_status)) + 
  geom_bar() +
  labs(title = "Distribution of Patient Health Pre-Procedure",
       x = "ASA Status",
       y = "Number of Participants")
```

![](midterm_2_files/figure-html/unnamed-chunk-8-1.png)<!-- -->

6. Create a plot that displays the distribution of body mass index for each `asa_status` as a probability distribution- not a histogram. (hint: use faceting!)


```r
surgery %>%
  filter(asa_status != "NA")%>%
  ggplot(aes(bmi)) +
  geom_density(fill= "purple3", alpha = .4) +
  facet_wrap(~ asa_status)
```

```
## Warning: Removed 3289 rows containing non-finite values (`stat_density()`).
```

![](midterm_2_files/figure-html/unnamed-chunk-9-1.png)<!-- -->

The variable `ccsmort30rate` is a measure of the overall 30-day mortality rate associated with each type of operation. The variable `ccscomplicationrate` is a measure of the 30-day in-hospital complication rate. The variable `ahrq_ccs` lists each type of operation.  

7. What are the 5 procedures associated with highest risk of 30-day mortality AND how do they compare with the 5 procedures with highest risk of complication? (hint: no need for a plot here)


```r
surgery %>% 
  group_by(ahrq_ccs) %>%
  summarise(mean_30day_mort = mean(ccsmort30rate)) %>%
  top_n(5, mean_30day_mort) %>%
  arrange(-mean_30day_mort)
```

```
## # A tibble: 5 × 2
##   ahrq_ccs                                             mean_30day_mort
##   <chr>                                                          <dbl>
## 1 Colorectal resection                                         0.0167 
## 2 Small bowel resection                                        0.0129 
## 3 Gastrectomy; partial and total                               0.0127 
## 4 Endoscopy and endoscopic biopsy of the urinary tract         0.00811
## 5 Spinal fusion                                                0.00742
```


```r
surgery %>% 
  group_by(ahrq_ccs) %>%
  summarise(mean_complication_risk = mean(complication_rsi)) %>%
  top_n(5, mean_complication_risk) %>%
  arrange(-mean_complication_risk)
```

```
## # A tibble: 5 × 2
##   ahrq_ccs                               mean_complication_risk
##   <chr>                                                   <dbl>
## 1 Small bowel resection                                  0.686 
## 2 Colorectal resection                                   0.275 
## 3 Nephrectomy; partial or complete                      -0.0212
## 4 Oophorectomy; unilateral and bilateral                -0.0455
## 5 Gastrectomy; partial and total                        -0.0605
```

    Intestinal porcedures seem to have the highest mortality and complication rates.

8. Make a plot that compares the `ccsmort30rate` for all listed `ahrq_ccs` procedures.


```r
surgery %>%
  ggplot(aes(x=ahrq_ccs, y= ccsmort30rate, reorder(ahrq_ccs, -ccsmort30rate))) +
  geom_boxplot() + 
  coord_flip()
```

![](midterm_2_files/figure-html/unnamed-chunk-12-1.png)<!-- -->


9. When is the best month to have surgery? Make a chart that shows the 30-day mortality and complications for the patients by month. `mort30` is the variable that shows whether or not a patient survived 30 days post-operation.


```r
surgery %>%
  group_by(month) %>%
  mutate(mort30_num = if_else(mort30 == "Yes", 1, 0 )) %>%
  mutate(complication_num = if_else(complication == "Yes", 1, 0)) %>%
  mutate(danger_level = (mort30_num + complication_num)/2) %>% 
  summarise(mean_danger_level = mean(danger_level)) %>%
  arrange(-mean_danger_level)
```

```
## # A tibble: 12 × 2
##    month mean_danger_level
##    <chr>             <dbl>
##  1 Jan              0.0798
##  2 Aug              0.0741
##  3 Feb              0.0718
##  4 Oct              0.0716
##  5 Jun              0.0708
##  6 Sep              0.0686
##  7 Jul              0.0673
##  8 Dec              0.0655
##  9 Nov              0.0649
## 10 May              0.0646
## 11 Mar              0.0623
## 12 Apr              0.0617
```

    It would appear that January is the "least safe" month to get a procedure done
    
10. Make a plot that visualizes the chart from question #9. Make sure that the months are on the x-axis. Do a search online and figure out how to order the months Jan-Dec.


```r
surgery %>%
  group_by(month) %>%
  mutate(mort30_num = if_else(mort30 == "Yes", 1, 0 )) %>%
  mutate(complication_num = if_else(complication == "Yes", 1, 0)) %>%
  mutate(danger_level = (mort30_num + complication_num)/2) %>% 
  summarise(mean_danger_level = mean(danger_level)) %>%
  ggplot(aes(x=as.factor(month), y=mean_danger_level, fill = month))+
  scale_x_discrete(limits = month.abb) +
  geom_col() +
  scale_x_discrete(limits = month.abb) +
  labs(title = "Risk of mortality or Complications", 
       x= "Month",
       y= "Probability of Complication or Mortatlity")
```

```
## Scale for x is already present.
## Adding another scale for x, which will replace the existing scale.
```

![](midterm_2_files/figure-html/unnamed-chunk-14-1.png)<!-- -->

Please be 100% sure your exam is saved, knitted, and pushed to your github repository. No need to submit a link on canvas, we will find your exam in your repository.
