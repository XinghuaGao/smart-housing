# Set the working directory
setwd("C:/R workspace/BRI")

# install.packages("dplyr")
# install.packages("gplots")
# install.packages("tidyr")
# install.packages("scatterplot3d")
# install.packages("splot")

# Load libraries
# library(ggplot2)
library(dplyr)
library(ggplot2)
library(gplots)
library(tidyr)
library(scatterplot3d)
library(splot)

# Load raw data
raw_data <- read.csv("data.csv", header = TRUE, check.names = TRUE)

# names(raw_data)
# str(raw_data)

######################## Data cleaning and formating ######################## 

data <- raw_data %>% select(Project, New.vs..Reno, Senior.vs..Non.Senior, Yrs.in.Un, Un.Loc, Avg.Elec.Un, Ppl.in.Un, Visit.per.wk, Ann.Income, Under.5, X5.to.9, X10.to.19, 
                            X20.to.29, X30.to.59, X60.and.over, comfort_winter, comfort_summer,
                            afford_utility, afford_house, satisfaction, thermo_summer, thermo_winter, fall.window, winter.window, 
                            spring.window,summer.window,space.heater.comfort, fan.comfort,humid_prefer, short.showers, medium.showers,
                            long.showers, dishwasher_use, washer_dryer, comfort_current_winter, comfort_current_summer)

# change new vs. renovation into logical
data$New.vs..Reno <- as.logical(data$New.vs..Reno)

# change senior vs. non-senior into logical
data$Senior.vs..Non.Senior <- as.logical(data$Senior.vs..Non.Senior)

# fill the blanks with 0
data$Ann.Income[data$Ann.Income==""] <- 0

## how much is the SS?
## data$Ann.Income[data$Ann.Income=="SS"] <- 

# change income to numeric
# data$Ann.Income <- as.numeric(levels(data$Ann.Income))[data$Ann.Income]

# change questionnaire answers to factor
data$comfort_winter <- as.factor(data$comfort_winter)
data$comfort_summer <- as.factor(data$comfort_summer)
data$afford_utility <- as.factor(data$afford_utility)
data$afford_house <- as.factor(data$afford_house)
data$satisfaction <- as.factor(data$satisfaction)

data$thermo_summer <- as.factor(data$thermo_summer)
data$thermo_winter <- as.factor(data$thermo_winter)

# change to logical
data$fall.window <- as.logical(data$fall.window)
data$winter.window <- as.logical(data$winter.window)
data$spring.window <- as.logical(data$spring.window)
data$summer.window <- as.logical(data$summer.window)
data$space.heater.comfort <- as.logical(data$space.heater.comfort)
data$fan.comfort <- as.logical(data$fan.comfort)

# change to factor
data$humid_prefer <- as.factor(data$humid_prefer)

# change to logical
data$short.showers <- as.logical(data$short.showers)
data$medium.showers <- as.logical(data$medium.showers)
data$long.showers <- as.logical(data$long.showers)

# change to factor
data$dishwasher_use <- as.factor(data$dishwasher_use)
data$washer_dryer <- as.factor(data$washer_dryer)
data$comfort_current_winter <- as.factor(data$comfort_current_winter)
data$comfort_current_summer <- as.factor(data$comfort_current_summer)

# change to num
# data$X60.and.over <- as.numeric(levels(data$X60.and.over))[data$X60.and.over]

# remove the NA
 data <- subset(data, !is.na(data$X60.and.over))

# occupant <- data %>% select(Yrs.in.Un, Ppl.in.Un, Visit.per.wk, Ann.Income, Under.5, X5.to.9, X10.to.19, 
#                             X20.to.29, X30.to.59, X60.and.over)

# Thermostat <- data %>% select(thermo_summer, thermo_winter, fall.window, winter.window, 
#                               spring.window,summer.window,space.heater.comfort, fan.comfort,humid_prefer)

# occupant <- unite(occupant, demographic, Under.5, X5.to.9, X10.to.19,
#                   X20.to.29, X30.to.59, X60.and.over,sep = "/", remove = TRUE)

# size of data
n = nrow(data)



# 0 = Senior, 1 = Non-Senior True

occupant_senior <- subset(data, data$X60.and.over!=0)
occupant_nonsenior <- subset(data, data$X60.and.over==0)

# data$family = FALSE means senior, = TRUE means non-sensior

nn = {1:n}

for (k in nn)
{
  if (data$X60.and.over[k]!=0) {
    data$family[k] = FALSE 
  } else {
    data$family[k] = TRUE 
  }
}


# occupant_senior <- unite(occupant_senior, demographic, Under.5, X5.to.9, X10.to.19,
#                   X20.to.29, X30.to.59, X60.and.over,sep = "/", remove = FALSE)
# 
# occupant_senior$demographic <- as.factor(occupant_senior$demographic) 
# occupant59 <- subset(occupant_senior, occupant_senior$X30.to.59!=0)
# occupant60 <- subset(data, data$X60.and.over!=0)

# summary(occupant$demographic)
# str(occupant)
# plot(occupant$demographic) 

#Each Project:
# pro_A <-  subset(data, Project == "A")
# pro_B <-  subset(data, Project == "B")
# pro_C <-  subset(data, Project == "C")
# pro_D <-  subset(data, Project == "D")
# pro_E <-  subset(data, Project == "E")
# pro_F <-  subset(data, Project == "F")
# pro_G <-  subset(data, Project == "G")
# pro_H <-  subset(data, Project == "H")
# pro_I <-  subset(data, Project == "I")
# pro_J <-  subset(data, Project == "J")
# pro_K <-  subset(data, Project == "K")
# pro_L <-  subset(data, Project == "L")
# pro_M <-  subset(data, Project == "M")
# pro_N <-  subset(data, Project == "N")
# pro_O <-  subset(data, Project == "O")


######################## some statistics ########################

# Number of years the studied households spent in their current units
summary(data$Yrs.in.Un)


# The Comfort level of current unit to previous housing unit by age group
# Summer
summary(data$comfort_summer)
summary(occupant_senior$comfort_summer)
summary(occupant_nonsenior$comfort_summer)

# Winter
summary(data$comfort_winter)
summary(occupant_senior$comfort_winter)
summary(occupant_nonsenior$comfort_winter)

# satisfaction
summary(data$satisfaction)
summary(occupant_senior$satisfaction)
summary(occupant_nonsenior$satisfaction)



######################## The energy consumption ########################

summary(data$Avg.Elec.Un)

# Overall
splot(
  Avg.Elec.Un ~ Project, data =  data, 
  type = 'scatter',
  laby = 'Average electricity use per unit (kBtu/m2/yr)', labx = 'Development', title = 'Overall electricity use per unit (kBtu/m2/yr)',
  col = 'blue',
  xaxis = TRUE, yaxis = TRUE,
  xlas = 1
)

# family households
splot(
  Avg.Elec.Un ~ Project, data =  occupant_nonsenior, 
  type = 'scatter',
  laby = 'Average electricity use per unit (kBtu/sqft/yr)', labx = 'Project', title = 'Non-senior electricity use per unit (kBtu/sqft/yr)',
  col = 'green'
)

# Senior
splot(
  Avg.Elec.Un ~ Project, data =  occupant_senior, 
  type = 'scatter',
  laby = 'Average electricity use per unit (kBtu/sqft/yr)', labx = 'Project', title = 'Senior households electricity use per unit (kBtu/sqft/yr)',
  col = 'orange'
)

# Bar charts
plot(data$Project, data$Avg.Elec.Un, main="Overall electricity consumption per unit (kBtu/sqft/yr)",
     xlab="Projects", ylab="Average electricity use per unit", col=10)

plot(occupant_senior$Project, occupant_senior$Avg.Elec.Un, main="Electricity consumption of senior households (kBtu/sqft/yr)",
     xlab="Projects", ylab="Average electricity use per unit (kBtu/sqft/yr)", col=4)

plot(occupant_nonsenior$Project, occupant_nonsenior$Avg.Elec.Un, main="Electricity consumption of family households (kBtu/sqft/yr)",
     xlab="Projects", ylab="Average electricity use per unit (kBtu/sqft/yr)", col=3)

# Bar charts - comparison
qplot(Project,Avg.Elec.Un, data=data, geom=c("boxplot"),
      main="Senior vs. non-senior electricity use per unit (kBtu/m2/yr)", xlab="Projects", ylab="Electricity use per unit (kBtu/m2/yr)",
      fill=as.factor(family)
      )


  ######################## plots about summer/winter comfortable level ########################

# Plot the summer comfortable level vs. project of all households
ggplot(data, aes(x =Project, fill = comfort_summer)) +
  geom_bar() +
  xlab("Project") +
  ylab("Total count of households") +
  labs(fill = "Comfortable level in summer, 
       0 = No response,
       1 = Much lesscomfortable, 
       2 = About the same, 
       3 = Much more comfortable") 

# Plot the winter comfortable level vs. project of all households
ggplot(data, aes(x =Project, fill = comfort_winter)) +
  geom_bar() +
  xlab("Project") +
  ylab("Total count of households") +
  labs(fill = "Comfortable level in winter, 
       0 = No response,
       1 = Much lesscomfortable, 
       2 = About the same, 
       3 = Much more comfortable") 

# Family group
# Plot the summer comfortable level vs. project of Family households
ggplot(occupant_nonsenior, aes(x =Project, fill = comfort_summer)) +
  geom_bar() +
  xlab("Project") +
  ylab("Total count of households") +
  labs(fill = "Comfortable level in summer, 
       0 = No response,
       1 = Much lesscomfortable, 
       2 = About the same, 
       3 = Much more comfortable") 

# Plot the winter comfortable level vs. project of Family households
ggplot(occupant_nonsenior, aes(x =Project, fill = comfort_winter)) +
  geom_bar() +
  xlab("Project") +
  ylab("Total count of households") +
  labs(fill = "Comfortable level in winter, 
       0 = No response,
       1 = Much lesscomfortable, 
       2 = About the same, 
       3 = Much more comfortable") 

# Senior group
# Plot the summer comfortable level vs. project of senior households
ggplot(occupant_senior, aes(x =Project, fill = comfort_summer)) +
  geom_bar() +
  xlab("Project") +
  ylab("Total count of households") +
  labs(fill = "Comfortable level in summer, 
       0 = No response,
       1 = Much lesscomfortable, 
       2 = About the same, 
       3 = Much more comfortable") 

# Plot the winter comfortable level vs. project of senior households
ggplot(occupant_senior, aes(x =Project, fill = comfort_winter)) +
  geom_bar() +
  xlab("Project") +
  ylab("Total count of households") +
  labs(fill = "Comfortable level in winter, 
       0 = No response,
       1 = Much lesscomfortable, 
       2 = About the same, 
       3 = Much more comfortable") 


# Plot the winter comfortable level vs. new or reno 
# FALSE = new, TRUE = renovated project
ggplot(data, aes(x =New.vs..Reno, fill = comfort_winter)) +
  geom_bar() +
  xlab("FALSE = New building, TRUE = Renovated building") +
  ylab("Total count of households") +
  labs(fill = "Comfortable level in winter, 
       0 = No response,
       1 = Much lesscomfortable, 
       2 = About the same, 
       3 = Much more comfortable") 

######################## plots about satisfaction ########################

# Plot the overall satisfaction vs. new or reno 
# FALSE = new, TRUE = renovated project
ggplot(data, aes(x =New.vs..Reno, fill = satisfaction)) +
  geom_bar() +
  xlab("FALSE = New building, TRUE = Renovated building") +
  ylab("Total count of households") +
  labs(fill = "Overall satisfaction, 
       1 = Much less satisfied, 
       2 = About the same, 
       3 = Much more satisfied") 

# Housing affordability vs. Overall satisfaction
# Grouping by projects
ggplot(data, aes(x = afford_house, fill = satisfaction)) +
  geom_bar() +
  facet_wrap(~Project) + 
  ggtitle("Housing affordability vs. Overall satisfaction") +
  xlab("Housing affordability, 
       1 = Much less affordable,
       2 = About the same,
       3 = Much more affordable") +
  ylab("Total count of households") +
  labs(fill = "Overall satisfaction, 
       1 = Much less satisfied, 
       2 = About the same, 
       3 = Much more satisfied")

# Housing affordability vs. Overall satisfaction
# Grouping by unit locations
ggplot(data, aes(x = afford_house, fill = satisfaction)) +
  geom_bar() +
  facet_wrap(~Un.Loc) + 
  ggtitle("Housing affordability vs. Overall satisfaction") +
  xlab("Housing affordability, 
       1= Much less affordable,
       2= About the same,
       3 = much more affordable") +
  ylab("Total count of households") +
  labs(fill = "Overall satisfaction, 
       1= Much less satisfied,
       2= About the same,
       3 = much more satisfied")

# Overall People number vs. satisfaction
# Grouping by projects
ggplot(data, aes(x = Ppl.in.Un, fill = satisfaction)) +
  geom_bar() +
  facet_wrap(~Project) + 
  ggtitle("Overall satisfaction vs. number of people in unit") +
  xlab("Number of People in unit") +
  ylab("Total count of households") +
  labs(fill = "Overall satisfaction, 
       1 = Much less satisfied,
       2 = About the same,
       3 = Much more satisfied")

######################## plots about affordability ########################

# Overall satisfaction vs. utility affordability
ggplot(data, aes(x = afford_utility, fill = satisfaction)) +
  geom_bar() +
  ggtitle("Overall satisfaction vs. utility affordability") +
  xlab("Utility affordability, 
       0 = No response,       
       1 = Much less affordable,
       2 = About the same,
       3 = Much more affordable") +
  ylab("Total count of households") +
  labs(fill = "Overall satisfaction, 
       1 = Much less satisfied,
       2 = About the same,
       3 = Much more satisfied")

# Overall satisfaction vs. utility affordability by project
ggplot(data, aes(x = afford_utility, fill = satisfaction)) +
  geom_bar() +
  facet_wrap(~Project) + 
  ggtitle("Overall satisfaction vs. utility affordability") +
  xlab("Utility affordability, 
       0 = No response,       
       1 = Much less affordable,
       2 = About the same,
       3 = Much more affordable") +
  ylab("Total count of households") +
  labs(fill = "Overall satisfaction, 
       1 = Much less satisfied,
       2 = About the same,
       3 = Much more satisfied")

######################## plots about thermostat preference ########################

# Overall summer thermostat
ggplot(data, aes(x = thermo_summer)) +
  geom_bar() +
  ggtitle("All households summer thermostat preference") +
  xlab("Temperature set, 0 = no response, 1 = below 68, 2 = 68-72, 3 = 72-75, 4 = above 75") +
  ylab("Total number of household") +
  labs(fill = " ")

# Overall winter thermostat
ggplot(data, aes(x = thermo_winter)) +
  geom_bar() +
  ggtitle("All households winter thermostat preference") +
  xlab("Temperature set, 0 = no response, 1 = below 68, 2 = 68-72, 3 = 72-75, 4 = above 75") +
  ylab("Total number of household") +
  labs(fill = " ")

# non-senior summer thermostat
ggplot(occupant_nonsenior, aes(x = thermo_summer)) +
  geom_bar() +
  ggtitle("Non-senior households summer thermostat preference") +
  xlab("Temperature set, 0 = no response, 1 = below 68, 2 = 68-72, 3 = 72-75, 4 = above 75") +
  ylab("Total number of household") +
  labs(fill = " ")

# Family winter thermostat
ggplot(occupant_nonsenior, aes(x = thermo_winter)) +
  geom_bar() +
  ggtitle("Non-senior households winter thermostat preference") +
  xlab("Temperature set, 0 = no response, 1 = below 68, 2 = 68-72, 3 = 72-75, 4 = above 75") +
  ylab("Total number of household") +
  labs(fill = " ")

# Senior summer thermostat
ggplot(occupant_senior, aes(x = thermo_summer)) +
  geom_bar() +
  ggtitle("Senior group summer thermostat preference") +
  xlab("Temperature set, 0 = no response, 1 = below 68, 2 = 68-72, 3 = 72-75, 4 = above 75") +
  ylab("Total number of household") +
  labs(fill = " ")

# Senior winter thermostat  
ggplot(occupant_senior, aes(x = thermo_winter)) +
  geom_bar() +
  ggtitle("Senior group winter thermostat preference") +
  xlab("Temperature set, 0 = no response, 1 = below 68, 2 = 68-72, 3 = 72-75, 4 = above 75") +
  ylab("Total number of household") +
  labs(fill = " ")

######################## Preference: opening window, space heater, fan, and humid ########################

summary(data$fall.window)
summary(data$winter.window)
summary(data$spring.window)
summary(data$summer.window)
summary(data$space.heater.comfort)
summary(data$fan.comfort)
summary(data$humid_prefer)

summary(occupant_nonsenior$fall.window)
summary(occupant_nonsenior$winter.window)
summary(occupant_nonsenior$spring.window)
summary(occupant_nonsenior$summer.window)
summary(occupant_nonsenior$space.heater.comfort)
summary(occupant_nonsenior$fan.comfort)
summary(occupant_nonsenior$humid_prefer)

summary(occupant_senior$fall.window)
summary(occupant_senior$winter.window)
summary(occupant_senior$spring.window)
summary(occupant_senior$summer.window)
summary(occupant_senior$space.heater.comfort)
summary(occupant_senior$fan.comfort)
summary(occupant_senior$humid_prefer)

######################## Preference: length of shower, washer/dryer usage ########################

summary(data$short.showers)
summary(data$medium.showers)
summary(data$long.showers)
summary(data$dishwasher_use)
summary(data$washer_dryer)

summary(occupant_nonsenior$short.showers)
summary(occupant_nonsenior$medium.showers)
summary(occupant_nonsenior$long.showers)
summary(occupant_nonsenior$dishwasher_use)
summary(occupant_nonsenior$washer_dryer)

summary(occupant_senior$short.showers)
summary(occupant_senior$medium.showers)
summary(occupant_senior$long.showers)
summary(occupant_senior$dishwasher_use)
summary(occupant_senior$washer_dryer)


######################## Education and noise ########################





######################## K-means clustering ########################

project_comfort <- data %>% select(Project, comfort_winter, comfort_summer, satisfaction)

plot(project_comfort)

# d <- dist(project_comfort)

# fith <- hclust(1.6, "ward.D2")

######################## Archive ########################


# which(is.na(data$satisfaction))
# str(data$Project)
# fitk_project <- kmeans(project_comfort, 3)


# names(data)
# str(data)
# summary(data)

# data <- as.factor(raw_data$Project)
# data$new_reno <- as.logical(raw_data$New.vs..Reno)
# data$project <- raw_data$Project
