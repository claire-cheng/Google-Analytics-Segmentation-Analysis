library(readr)
clean_train_data <- read_csv("~/Google_Analytics_Gstore/CleanData.csv")
str(clean_train_data)
library(dplyr)
clean_train_data <- clean_train_data %>%
  select(-X1)

#Remove all the columns with a significant number of NAs based on the "% of NAs per variable" chart.
clean_train_data <- clean_train_data %>%
  select(-newVisits,-bounces,-keyword,-referralPath,-isTrueDirect,-adwordsClickInfo.gclId,-adwordsClickInfo.adNetworkType,-adwordsClickInfo.isVideoAd,-adwordsClickInfo.page,
         -adwordsClickInfo.slot,-adContent,-campaign)

#Count NAs in each column in the table
sapply(clean_train_data, function(y) sum(length(which(is.na(y)))))

#####networkDomain
#count the number of unique values for networkDomain
  #There are 28063 different values in networkDomain column so we are going to remove this value since it does not provide much value to us.
length(unique(clean_train_data$networkDomain))
clean_train_data <- clean_train_data %>%
  select(-networkDomain)

#####date
  ####The dataset contains the timestamp column visitStartTime expressed as POSIX time. It allows us to create a bunch of features. 
  ####Let’s check symmetric differences of the time features from the train and test sets.

#Use as_datetime to convert POSIX format to date format and change the time zone to EST.
library(lubridate)
clean_train_data$visitStartTime <- as_datetime(clean_train_data$visitStartTime, tz = "America/New_York")

#Retrieve the hours from the visiting time to indicate the exact hour the user was on the website.
clean_train_data$visit_Hour <- hour(clean_train_data$visitStartTime)

####isMobile
#Convert the boolean field, isMobile, into 0 and 1
clean_train_data$isMobile <- as.numeric(ifelse(clean_train_data$isMobile == TRUE, 1, 0))

####continent
#There are 1468 NAs for Continent. We are checking if any of these rows have their country indicated, if so, we can input their continents manully, if not,
#we will remove these rows from our dataset. 
filter(clean_train_data, is.na(clean_train_data$continent) & !is.na(clean_train_data$country))
#Nothing returned from this code, so we are going to remove all the NAs rows.
clean_train_data <- clean_train_data[!is.na(clean_train_data$continent),]
nrow(clean_train_data)
#from 903653 to 902185

####region
#There are 534595 NAs for Region. Location is very important for our profiling analysis later on, so we want to make sure to have a location for each visit.
#We are removing the NAs rows from our dataset.
clean_train_data <- clean_train_data[!is.na(clean_train_data$region),]
nrow(clean_train_data)
#from 902185 to 367590

####browser
#There are 4 NAs for browser.
#We are removing the NAs rows from our dataset.
clean_train_data <- clean_train_data[!is.na(clean_train_data$browser),]
nrow(clean_train_data)
#from 367590 to 367586

####operatingSystem
#There are 1141 NAs for browser.
#We are removing the NAs rows from our dataset.
clean_train_data <- clean_train_data[!is.na(clean_train_data$operatingSystem),]
nrow(clean_train_data)
#from 367586 to 366448

####source
#There are 28 NAs for browser.
#We are removing the NAs rows from our dataset.
clean_train_data <- clean_train_data[!is.na(clean_train_data$source),]
nrow(clean_train_data)
#from 366448 to 366420

#Double check if there are any remaining NAs in the numerical data
sapply(clean_train_data, function(y) sum(length(which(is.na(y)))))

####pageviews
#We are using mice to impute the missing values for pagevies.
#library(mice)
#pageview_mice = mice::complete(mice(clean_train_data))
#We encountered an error here that mice does not handle such large amount of data, so we are going to remove these 100 rows of NAs.
#clean_train_data$pageviews = pageview_mice$pageviews

#Remove all the rows with pageviews = NA, from 366420 rows to 366360 rows.
nrow(clean_train_data)
clean_train_data <- clean_train_data[!is.na(clean_train_data$pageviews),] 

####medium
#The values medium stores is very similiar to channelGrouping, so we are just going to use channelGrouping instead of medium.
clean_train_data <- clean_train_data %>%
  select(-medium)

write.csv(clean_train_data, 'clean_data_k_means.csv',row.names = F)
nrow(clean_train_data)

#######################################
#Ok, now that we have a clean dataset, we are going to continue our k-means clustering analysis.
#######################################
library(readr)
clean_train_data <- read_csv("~/Desktop/APANPS5205_Applied_analytics_frameworks_methods_2/clean_data_k_means.csv")

#Since clustering analysis only allows numeric variables, we are going to subset those variables for our analysis.
data_cluster = clean_train_data[,c(6,10,18:20)]
str(data_cluster)

#scale
#head(scale(data_cluster))
data_cluster = scale(data_cluster)
head(data_cluster)

#For k-means, the distance is computed using Euclidean distance
set.seed(617)

#4- 46.4%
km = kmeans(x = data_cluster,centers = 4, iter.max = 10000, nstart = 25)
km

#We are choosing 4 clusters for now to proceed with the analysis
#The number of observations in the resulting clusters
k_segments = km$cluster
table(k_segments)

#The total sum of squares is the sum of total within-cluster sum of squares and the between
#cluster sum of squares
paste(km$totss, '=', km$betweenss, '+' , km$tot.withinss, sep = ' ')
km$totss == km$betweenss + km$tot.withinss

##Interpret results
#Total within sum of squares Plot
within_ss = sapply(1:10, FUN = function(x){
  set.seed(617)
  kmeans(x=data_cluster,centers=x,iter.max = 1000,nstart=25)$tot.withinss
})

library(ggplot2)
ggplot(data=data.frame(cluster = 1:10, within_ss),aes(x=cluster,y=within_ss))+
  geom_line(col = 'steelblue',size = 1.2)+
  geom_point()+
  scale_x_continuous(breaks = seq(1,10,1))
#Based on the Total within sum of squares Plot, the elbow indicates 4 clusters.

#Ratio Plot
ratio_ss = sapply(1:10, FUN = function(x){
  set.seed(617)
  km = kmeans(x=data_cluster,centers=x,iter.max = 1000,nstart=25)
  km$betweenss/km$totss
})

ggplot(data=data.frame(cluster = 1:10, ratio_ss),aes(x=cluster,y=ratio_ss))+
  geom_line(col = 'steelblue',size = 1.2)+
  geom_point()+
  scale_x_continuous(breaks = seq(1,10,1))
#Based on the Ratio Plot, the elbow indicates 4 clusters.


data_combined = cbind(clean_train_data, k_segments)
write.csv(data_combined, 'data_combined_k_means.csv',row.names = F)

#Visialize
library(psych)
temp = data.frame(cluster = factor(k_segments),
                  factor1 = fa(data_cluster,nfactors = 2, rotate = 'varimax')$scores[,1],
                  factor2 = fa(data_cluster,nfactors = 2, rotate = 'varimax')$scores[,2])
ggplot(temp,aes(x=factor1,y=factor2,col=cluster))+geom_point()

#Using clusplot
library(cluster)
clusplot(data_cluster,
         k_segments,
         color = T, shade = T, labels = 4, lines = 0, main = 'k-means Cluster Plot')


#######################################
#Clusters profiling- choosing target clusters
#######################################
##hour
prop.table(table(data_combined$k_segments,data_combined[,22]),1)

round(prop.table(table(data_combined$k_segments,data_combined[,22]),1)*100)

library(ggplot2)
library(RColorBrewer)

tab = round(prop.table(table(data_combined$k_segments,data_combined[,22]),1)*100)
tab2 = data.frame(round(tab,2))

ggplot(data = tab2, aes(x=Var2, y = Var1,fill=Freq))+
  geom_tile()+
  geom_text(aes(label=Freq),size=6)+
  xlab(label = '')+
  ylab(label = '')+
  scale_fill_gradientn(colors=brewer.pal(n=9,name='Greens'))

##country
prop.table(table(data_combined$k_segments,data_combined[,14]),1)

round(prop.table(table(data_combined$k_segments,data_combined[,14]),1)*100)

library(ggplot2)
library(RColorBrewer)

tab = round(prop.table(table(data_combined$k_segments,data_combined[,22]),1)*100)
tab2 = data.frame(round(tab,2))

ggplot(data = tab2, aes(x=Var2, y = Var1,fill=Freq))+
  geom_tile()+
  geom_text(aes(label=Freq),size=6)+
  xlab(label = '')+
  ylab(label = '')+
  scale_fill_gradientn(colors=brewer.pal(n=9,name='Greens'))

test <- data_combined[c(-157924),]
nrow(data_combined)
nrow(test)

#Getting rid of the ourlier with transactionRevenue== 16023750000 in cluster 4.
#Get the index of this row.
data_combined[data_combined$transactionRevenue== 16023750000,]
#157924
#remove this index from the dataset
data_combined <- data_combined[c(-157924),]

library(dplyr)
library(performance)
#examine means of each needs-based variable
average_values <-
  data_combined %>%
  select(c(visitNumber,hits,pageviews,transactionRevenue),k_segments)%>%
  group_by(k_segments)%>%
  summarize_all(function(x)round(mean(x,na.rm=T),2))%>%
  data.frame()

average_values
write.csv(average_values, 'avg_values_profiling.csv',row.names = F)


#######################################
#Cluster 1 Profiling
#######################################
#Subset data for those under cluster 1
cluster1data <- data_combined[which(data_combined$k_segments == 1),]
str(cluster1data)

##country
counts <- table(cluster1data$country)
barplot(counts,main='Country', horiz = TRUE)
#The majority of the visits are from the united states
library(dplyr)
cluster1data %>%
  group_by(country) %>%
  summarise(fullVisitorId = n()) %>%
  arrange(desc(fullVisitorId))

##region
counts <- table(cluster1data$region)
barplot(counts,main='Region', horiz = TRUE)
#The majority of the visits are from Virginia and then California.
cluster1data %>%
  group_by(region) %>%
  summarise(fullVisitorId = n()) %>%
  arrange(desc(fullVisitorId))

##channelGrouping
counts <- table(cluster1data$channelGrouping)
barplot(counts,main='ChannelGrouping', horiz = TRUE)
#The majority of the visits are from Organic Search.
cluster1data %>%
  group_by(channelGrouping) %>%
  summarise(fullVisitorId = n()) %>%
  arrange(desc(fullVisitorId))

##browser
counts <- table(cluster1data$browser)
barplot(counts,main='Browser', horiz = TRUE)
#The majority of the visits used Chrome.
cluster1data %>%
  group_by(browser) %>%
  summarise(fullVisitorId = n()) %>%
  arrange(desc(fullVisitorId))

##operatingSystem
counts <- table(cluster1data$operatingSystem)
barplot(counts,main='OperatingSystem', horiz = TRUE)
#The majority of the visits used Windows
cluster1data %>%
  group_by(operatingSystem) %>%
  summarise(fullVisitorId = n()) %>%
  arrange(desc(fullVisitorId))

##deviceCategory
counts <- table(cluster1data$deviceCategory)
barplot(counts,main='DeviceCategory', horiz = TRUE)
#The majority of the visits used Desktop
cluster1data %>%
  group_by(deviceCategory) %>%
  summarise(fullVisitorId = n()) %>%
  arrange(desc(fullVisitorId))

##city
counts <- table(cluster1data$city)
barplot(counts,main='City', horiz = TRUE)
#The majority of the visits by the users who are in big cities.
cluster1data %>%
  group_by(city) %>%
  summarise(fullVisitorId = n()) %>%
  arrange(desc(fullVisitorId))

##source
counts <- table(cluster1data$source)
barplot(counts,main='Source', horiz = TRUE)
#The majority of the visits used google.
cluster1data %>%
  group_by(source) %>%
  summarise(fullVisitorId = n()) %>%
  arrange(desc(fullVisitorId))
##most of the people visited gstore by googling gstore from the search engine, this is an indicator that these customers might be in the nichce market
  #as they might be loyal customers who tend to shop at the website without clicking on and ads.

##Visit_Hour
counts <- table(cluster1data$visit_Hour)
barplot(counts,main='Visit_Hour', horiz = TRUE)
#The majority of the visits used google.
cluster1data %>%
  group_by(source) %>%
  summarise(fullVisitorId = n()) %>%
  arrange(desc(fullVisitorId))


####money spend vs hours (most of the money spent by this group of people at noon or in the afternoon)
#Subset a dataset with revenue <> 0
cluster1_with_revenue <- cluster1data[which(cluster1data$transactionRevenue != 0),]

#add a column to indicate if there was revenue or not
cluster1data$money_spent <- ifelse(cluster1data$transactionRevenue > 0, 'Money spent', 'No money spent')

library(ggplot2)
library(RColorBrewer)
tab = round(prop.table(table(cluster1data$visit_Hour,cluster1data[,24]),1)*100)
tab2 = data.frame(round(tab,2))

ggplot(data = tab2, aes(x=Var2, y = Var1,fill=Freq))+
  geom_tile()+
  geom_text(aes(label=Freq),size=6)+
  xlab(label = '')+
  ylab(label = '')+
  scale_fill_gradientn(colors=brewer.pal(n=9,name='Greens'))

####money spend vs cities (customers who spent money on g store were in Ann Arbor or Salem)
tab = round(prop.table(table(cluster1data$city,cluster1data[,24]),1)*100)
tab2 = data.frame(round(tab,2))

ggplot(data = tab2, aes(x=Var2, y = Var1,fill=Freq))+
  geom_tile()+
  geom_text(aes(label=Freq),size=6)+
  xlab(label = '')+
  ylab(label = '')+
  scale_fill_gradientn(colors=brewer.pal(n=9,name='Greens'))

#######################################
#Cluster 4 Profiling
#######################################
library(dplyr)
data = data_combined_k_means # Use data_combined_k_means as my back-up dataset

# Find the relationship between clusters and visitNumber, hits, and pageviews
library(ggplot2)
library(tidyr)
data %>%
  select(visitNumber, hits, pageviews, k_segments) %>%
  group_by(k_segments) %>%
  summarize_all(function(x) round(mean(x, na.rm = T),2)) %>%
  gather(key = var, value = value, visitNumber, hits, pageviews) %>%
  ggplot(aes(x = var, y = value, fill = factor(k_segments))) +
  geom_col(position = 'dodge') +
  coord_flip()

table(data$k_segments)

# Count how many people in cluster 4 has a transactionRevenue that is greater than 0
data %>% 
  filter(transactionRevenue > 0, k_segments == 4) %>%
  nrow()

# cluster 4: continent vs transactionRevenue
library(RColorBrewer)
cluster4 = data[which(data$k_segments == 4),]

cluster4$revenue_group = ifelse(cluster4$transactionRevenue > 0, 'Has transaction revenue', 'No transaction revenue')
tab = prop.table(table(cluster4$continent, cluster4$revenue_group),1)
tab1.1 = data.frame(round(tab, 4)*100)
View(tab1.1)

ggplot(data = tab1.1, aes(x = Var2, y = Var1, fill = Freq)) +
  geom_tile() +
  geom_text(aes(label = Freq), size = 6) +
  xlab(label = '') +
  ylab(label = '') +
  scale_fill_gradientn(colors = brewer.pal(n = 9, name = 'Greens'))

# Cluster 4 region

US = cluster4[which(cluster4$continent == 'Americas'),]

US_data = US$region[which(US$revenue_group == 'Has transaction revenue')]
write.csv(US_data, 'US_data.csv',row.names = F)

tab2 = prop.table(table(US$region, US$revenue_group),1)
tab2.1 = data.frame(round(tab2, 4)*100)
View(tab2)

US_data = table(US_data)
prop.table(US_data)

ggplot(data = tab2.1, aes(x = Var2, y = Var1, fill = Freq)) +
  geom_tile() +
  geom_text(aes(label = Freq), size = 6) +
  xlab(label = '') +
  ylab(label = '') +
  scale_fill_gradientn(colors = brewer.pal(n = 9, name = 'Greens'))

# cluster 4: browser
browser = cluster4$browser[which(cluster4$revenue_group == 'Has transaction revenue')]
unique(browser)

browser = table(browser)
browser = data.frame(browser)
ggplot(browser, aes(browser, Freq), fill = browser)+
  geom_col(position = 'dodge') # Most of people who has transaction revenue use chrome


# cluster 4: average visit hour
cluster4 %>%
  select(visit_Hour, revenue_group) %>%
  group_by(revenue_group) %>%
  summarize_all(function(x) mean(x)) %>%
  gather(key = var, value = value, visit_Hour) %>%
  ggplot(aes(x = value, y = var, fill = factor(revenue_group))) +
  geom_col(position = 'dodge') +
  coord_flip() # No significant difference

# device Category
unique(cluster4$deviceCategory)
table(cluster4$deviceCategory) # most of cluster 4 person are using desktop

# operating system
unique(cluster4$operatingSystem)
os = table(cluster4$operatingSystem[which(cluster4$revenue_group == 'Has transaction revenue')])
os = data.frame(os)
ggplot(os, aes(x = Var1, y = Freq), fill = Var1)+geom_col()
# focus on Macintosh, Windows, Linus, Android and Chrome OS user

# Cluster 4: visitNumber
cluster4 %>%
  select(visitNumber, revenue_group) %>%
  group_by(revenue_group) %>%
  summarize_all(function(x) mean(x)) %>%
  gather(key = var, value = value, visitNumber) %>%
  ggplot(aes(x = value, y = var, fill = factor(revenue_group))) +
  geom_col(position = 'dodge') +
  coord_flip() 

table(cluster4$continent, cluster4$revenue_group)
table(cluster4$isMobile) 