## --------------------------------
## Pull data from text file
library('readr')
library('lubridate')
library('dplyr')
library('readxl')
##

## --
## Load main accident facts
accidents <- read_csv("/Users/rmoff/data/road-accidents-safety-data/data/DfTRoadSafety_Accidents_2014.csv",
                      col_types = list( "1st_Road_Number" = col_character(),
                                        "2nd_Road_Number" = col_character()
                      )
)
## Derive the timestamp
accidents$timestamp <- dmy_hm(paste(accidents$Date,accidents$Time))
## Define the location as a string.
accidents$location <- paste(accidents$Latitude,accidents$Longitude,sep=',')

## The CSV file has a BOM (https://en.wikipedia.org/wiki/Byte_order_mark) which
## causes a problem because the first row in the file is column headings, hence
## the first column is prefixed with the BOM (ef bb), which is special characters and
## not visible which makes working with the column impossible.
## This code overwrites the column name with a non-special character name.
names(accidents)<- c("Accident_Index", names(accidents[2:34]))


## --
## Lookup datasets
police <-
  read_excel("/Users/rmoff/data/road-accidents-safety-data/data/Road-Accident-Safety-Data-Guide.xls",sheet = 3) %>%
  rename(police_force=label)
severity <-
  read_excel("/Users/rmoff/data/road-accidents-safety-data/data/Road-Accident-Safety-Data-Guide.xls",sheet = 4) %>%
  rename(severity=label)
day_of_week <-
  read_excel("/Users/rmoff/data/road-accidents-safety-data/data/Road-Accident-Safety-Data-Guide.xls",sheet = 5) %>%
  rename(day_of_week=label)
la_district <-
  read_excel("/Users/rmoff/data/road-accidents-safety-data/data/Road-Accident-Safety-Data-Guide.xls",sheet = 6) %>%
  rename(local_auth_district=label)
la_highway <-
  read_excel("/Users/rmoff/data/road-accidents-safety-data/data/Road-Accident-Safety-Data-Guide.xls",sheet = 7) %>%
  rename(local_auth_highway=Label)
road_class_1 <-
  read_excel("/Users/rmoff/data/road-accidents-safety-data/data/Road-Accident-Safety-Data-Guide.xls",sheet = 8) %>%
  rename(road_class_1=label)
road_type <-
  read_excel("/Users/rmoff/data/road-accidents-safety-data/data/Road-Accident-Safety-Data-Guide.xls",sheet = 9) %>%
  rename(road_type=label)
junc_detail <-
  read_excel("/Users/rmoff/data/road-accidents-safety-data/data/Road-Accident-Safety-Data-Guide.xls",sheet = 10) %>%
  rename(junction_detail=label)
junc_control <-
  read_excel("/Users/rmoff/data/road-accidents-safety-data/data/Road-Accident-Safety-Data-Guide.xls",sheet = 11) %>%
  rename(junction_control=label)
road_class_2 <-
  read_excel("/Users/rmoff/data/road-accidents-safety-data/data/Road-Accident-Safety-Data-Guide.xls",sheet = 12) %>%
  rename(road_class_2=label)
ped_cross_human <-
  read_excel("/Users/rmoff/data/road-accidents-safety-data/data/Road-Accident-Safety-Data-Guide.xls",sheet = 13) %>%
  rename(ped_cross_human=label)
ped_cross_phys <-
  read_excel("/Users/rmoff/data/road-accidents-safety-data/data/Road-Accident-Safety-Data-Guide.xls",sheet = 14) %>%
  rename(ped_cross_phys=label)
light_conditions <-
  read_excel("/Users/rmoff/data/road-accidents-safety-data/data/Road-Accident-Safety-Data-Guide.xls",sheet = 15) %>%
  rename(light_conditions=label)
weather <-
  read_excel("/Users/rmoff/data/road-accidents-safety-data/data/Road-Accident-Safety-Data-Guide.xls",sheet = 16) %>%
  rename(weather=label)
road_surface <-
  read_excel("/Users/rmoff/data/road-accidents-safety-data/data/Road-Accident-Safety-Data-Guide.xls",sheet = 17) %>%
  rename(road_surface=label)
special_conditions <-
  read_excel("/Users/rmoff/data/road-accidents-safety-data/data/Road-Accident-Safety-Data-Guide.xls",sheet = 18) %>%
  rename(special_conditions=label)
carriageway_hazards <-
  read_excel("/Users/rmoff/data/road-accidents-safety-data/data/Road-Accident-Safety-Data-Guide.xls",sheet = 19) %>%
  rename(carriageway_hazards=label)
urban_rural <-
  read_excel("/Users/rmoff/data/road-accidents-safety-data/data/Road-Accident-Safety-Data-Guide.xls",sheet = 20) %>%
  rename(urban_rural=label)
po_attend <-
  read_excel("/Users/rmoff/data/road-accidents-safety-data/data/Road-Accident-Safety-Data-Guide.xls",sheet = 21) %>%
  rename(police_officer_attend=label)

accidents <-
  left_join(accidents,police, by=c("Police_Force"="code")) %>%
  left_join(severity, by=c("Accident_Severity"="code")) %>%
  left_join(day_of_week,by=c("Day_of_Week"="code")) %>%
  left_join(la_district,by=c("Local_Authority_(District)"="code")) %>%
  left_join(la_highway,by=c("Local_Authority_(Highway)"="Code")) %>%
  left_join(road_class_1,by=c("1st_Road_Class"="code")) %>%
  left_join(road_type,by=c("Road_Type"="code")) %>%
  left_join(junc_detail,by=c("Junction_Detail"="code")) %>%
  left_join(junc_control,by=c("Junction_Control"="code")) %>%
  left_join(road_class_2,by=c("2nd_Road_Class"="code")) %>%
  left_join(ped_cross_human,by=c("Pedestrian_Crossing-Human_Control"="code")) %>%
  left_join(ped_cross_phys,by=c("Pedestrian_Crossing-Physical_Facilities"="code")) %>%
  left_join(light_conditions,by=c("Light_Conditions"="code")) %>%
  left_join(weather,by=c("Weather_Conditions"="code")) %>%
  left_join(road_surface,by=c("Road_Surface_Conditions"="code")) %>%
  left_join(special_conditions,by=c("Special_Conditions_at_Site"="code")) %>%
  left_join(carriageway_hazards,by=c("Carriageway_Hazards"="code")) %>%
  left_join(urban_rural,by=c("Urban_or_Rural_Area"="code")) %>%
  left_join(po_attend,by=c("Did_Police_Officer_Attend_Scene_of_Accident"="code"))

## Concatenate road class/numbers - this takes a while to run
accidents$road_1 <- paste0(accidents$road_class_1,accidents$`1st_Road_Number`)
accidents$road_2 <- paste0(accidents$road_class_2,accidents$`2nd_Road_Number`)

## -------------------------------------
## All done! Save the file
save(accidents,file="/Users/rmoff/data/road-accidents-safety-data/data/accidents.rda")

## --------------------------------------
## Send to Elasticsearch
library("elastic")
connect()
docs_bulk(accidents,doc_ids = accidents$Accident_Index,index="dftroadsafetyaccidents02")


## ## Vehicle
## vehicle_type <- read_excel("/Users/rmoff/data/road-accidents-safety-data/data/Road-Accident-Safety-Data-Guide.xls",sheet = 22)
## towing <- read_excel("/Users/rmoff/data/road-accidents-safety-data/data/Road-Accident-Safety-Data-Guide.xls",sheet = 23)
## vehicle_manoeuvre <- read_excel("/Users/rmoff/data/road-accidents-safety-data/data/Road-Accident-Safety-Data-Guide.xls",sheet = 24)
## junction_location <- read_excel("/Users/rmoff/data/road-accidents-safety-data/data/Road-Accident-Safety-Data-Guide.xls",sheet = 25)
## skidding <- read_excel("/Users/rmoff/data/road-accidents-safety-data/data/Road-Accident-Safety-Data-Guide.xls",sheet = 26)
## hit_object_carriageway <- read_excel("/Users/rmoff/data/road-accidents-safety-data/data/Road-Accident-Safety-Data-Guide.xls",sheet = 27)
## veh_leaving_carriageway <- read_excel("/Users/rmoff/data/road-accidents-safety-data/data/Road-Accident-Safety-Data-Guide.xls",sheet = 28)
## hit_object_off_carriageway <- read_excel("/Users/rmoff/data/road-accidents-safety-data/data/Road-Accident-Safety-Data-Guide.xls",sheet = 29)
## first_poi <- read_excel("/Users/rmoff/data/road-accidents-safety-data/data/Road-Accident-Safety-Data-Guide.xls",sheet = 30)
## lh_drive <- read_excel("/Users/rmoff/data/road-accidents-safety-data/data/Road-Accident-Safety-Data-Guide.xls",sheet = 31)
## journey_purpose  <- read_excel("/Users/rmoff/data/road-accidents-safety-data/data/Road-Accident-Safety-Data-Guide.xls",sheet = 32)
## driver_sex <- read_excel("/Users/rmoff/data/road-accidents-safety-data/data/Road-Accident-Safety-Data-Guide.xls",sheet = 33)
## driver_age_band<- read_excel("/Users/rmoff/data/road-accidents-safety-data/data/Road-Accident-Safety-Data-Guide.xls",sheet = 34)
## propulsion <- read_excel("/Users/rmoff/data/road-accidents-safety-data/data/Road-Accident-Safety-Data-Guide.xls",sheet = 35)
## imd_decile <- read_excel("/Users/rmoff/data/road-accidents-safety-data/data/Road-Accident-Safety-Data-Guide.xls",sheet = 45)
## home_area_type <- read_excel("/Users/rmoff/data/road-accidents-safety-data/data/Road-Accident-Safety-Data-Guide.xls",sheet = 46)
## ## Casualty
## casualty_class <- read_excel("/Users/rmoff/data/road-accidents-safety-data/data/Road-Accident-Safety-Data-Guide.xls",sheet = 36)
## casualty_sex <- read_excel("/Users/rmoff/data/road-accidents-safety-data/data/Road-Accident-Safety-Data-Guide.xls",sheet = 37)
## casualty_sev <- read_excel("/Users/rmoff/data/road-accidents-safety-data/data/Road-Accident-Safety-Data-Guide.xls",sheet = 38)
## ped_location <- read_excel("/Users/rmoff/data/road-accidents-safety-data/data/Road-Accident-Safety-Data-Guide.xls",sheet = 39)
## ped_movement <- read_excel("/Users/rmoff/data/road-accidents-safety-data/data/Road-Accident-Safety-Data-Guide.xls",sheet = 40)
## car_passenger <- read_excel("/Users/rmoff/data/road-accidents-safety-data/data/Road-Accident-Safety-Data-Guide.xls",sheet = 41)
## bus_passenger <- read_excel("/Users/rmoff/data/road-accidents-safety-data/data/Road-Accident-Safety-Data-Guide.xls",sheet = 42)
## ped_road_maint_worker <- read_excel("/Users/rmoff/data/road-accidents-safety-data/data/Road-Accident-Safety-Data-Guide.xls",sheet = 43)
## casualty_type <- read_excel("/Users/rmoff/data/road-accidents-safety-data/data/Road-Accident-Safety-Data-Guide.xls",sheet = 44)
