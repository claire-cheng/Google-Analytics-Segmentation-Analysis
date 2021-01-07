# Google Analytics Segmentation Analysis
## **Project Aims and Background**
Google Analytics (GA) is a web analytics service that tracks and reports website traffic. GA is offering this tool to e-commerce companies and those who operate on digital platforms to better understand their customers and make sure of these business insights to take actions and make better decisions. 

GA’s marketing teams are challenged to make appropriate investments in its promotional strategies. However, GA is not sure whether the data they are providing to the clients are enough to do predictive analytics on revenue. In this project, I am analyzing a Google Merchandise Store, called GStore, where Google products are sold. I will be using GStore’s customer dataset that was collected from Google Analytics to predict revenue per customer- the natural log of the sum of all transactions per user. For every user in the test set, the target is:
<p align="center">
  <img src="https://raw.githubusercontent.com/claire-cheng/Google-Analytics-Segmentation-Analysis/main/Formula.png" width="300" height="150">
</p>
The goal of this project is to build an algorithm with appropriate customer segments to help GStore’s marketing team make precision marketing strategies. I need to build an algorithm with the lowest root mean squared error, which is defined as: 

<p align="center">
  <img src="https://raw.githubusercontent.com/claire-cheng/Google-Analytics-Segmentation-Analysis/main/RMSE.png" width="350" height="125">
</p>
where y hat is the projected revenue for a customer and y is the natural log of the actual revenue value.
## **Data Collection & Preparation**
The data is provided by Kaggle. There are 2 different CSV files:

 - train.csv:
    - This is the training dataset that contains user transactions from August 1st, 2016 to April 30th, 2018.
 - test.csv:
    - This is the testing dataset that contains user transactions from May 1st, 2018 to October 15th, 2018.
Both of the train and the test sets contain the columns listed under Data Fields (below). The only difference between the train and test sets is the extra information stored in the train set, TransactionRevenue, under one of the JSON columns, Totals. This sub-column  TransactionRevenue contains the revenue information I am trying to predict in this project. In addition, each row in the datasets represents one visit to the GStore. 
## **Data Fields**
  1. ChannelGrouping: the channel via which the user came to the store. There are total 8 factors: Organic search, Paid search, Display, Direct, Referral, Social, Affiliates, Other.
  2. Date: record the date when the user visited the store.
  3. FullVisitorId: A unique identifier for each user of the Google Merchandise Store.
  4. SessionId: A unique identifier to identify a session, a series of related message exchanges. For example, there may involve an ongoing communication where several web pages are requested by the client before they check out, session id is the tool to keep track of the current status of the shopper’s cart.
  5. VisitId: An identifier for this session. This is part of the value usually stored as the _utmb cookie. 
  6. VisitNumber: The session number for this user. If this is the first session, then this is set to 1. It is stored as an integer.
  7. VisitStartTime: A timestamp records the date of customer visiting. This variable is expressed as POSIX time. For POSIX time, every day is treated as if it contains exactly 86400 seconds, so it calculated as (sum of days between current date and 1970-01-01) * 86400.
  8. Device (JSON):
     - Browser: The browser used to visit the store, including Chrome, Firefox, and UC browser. There are a total of 109 browsers in this variable. 
     - OperatingSystem: Identify the operating system used to visit the store. There are a total of 19 operating systems in this variable including IOS, Macintosh, and Windows.
     - IsMobile: Whether the device is mobile. Returns True or False.
     - DeviceCategory: Identify the category of the device. There are 3 device categories, desktop, mobile, and tablet.
  9. GeoNetwork (JSON):
     - Continent: Identify the continent which customer belongs to. There are 6 continents: Asia, Europe, Americas, Africa, Oceania, Not set.
     - SubContinent: Provides more specific territory information.
     - Country: Identify the customer’s country.
     - Region: Provide a specific region of the country where customers are. 
     - Metro: A specific metro customers are. 
     - City: Identify the customer’s city.
     - NetworkDomain: Identify the domain of the customer’s network.
  10. Totals (JSON):
      - Hits: Identify the clicks of each customer.
      - Pageviews: Identify the pageviews of each customer.
      - Bounces: Identify the bounce of the customer, a binary variable.
      - NewVisits: Identify whether the customer is a new visitor or not, a binary variable.
      - TransactionRevenue: Provide the revenue of each customer, the dependent variable of this project.
  11. TrafficSource (JSON):
      - Campaign: Provide the name of the referring campaign of each customer.
      - Source: Identify the source of clicks of each customer.
      - Medium: Identify the referral to the page of each customer.
      - Keyword: Identify the keyword of SSL search of each customer.
      - IsTrueDirect: Identify whether the direction of each customer is true or not, a binary variable.
      - ReferralPath: Identify the path of each referral of each customer.
      - AdContent: Identify the specific link or content item in a campaign.
      - AdwordsClickInfo.page: Identify the direct click of the page for user.
      - AdwordsClickInfo.slot: Identify the direct click of the slot for each user.
      - AdwordsClickInfo.gclId: Identify the Google Click Identifier for user.
      - AdwordsClickInfo.adNetworkType:Identify the content type for user
      - AdwordsClickInfo.isVideoAd: Identify if the content is a video or not.
## **Clustering for Customer Segmentation**
By performing customer segmentation, all customers are divided into separate groups that share certain characteristics. The optimal characteristics that can be used for segmentations are highly depending on the specific business objective. In this project, I am using GA data that includes behavioral data and geographical information tracked and reported based on GStore’s website traffic. 

Since there is not a correct ‘answer’, a single or a right way, to segment customers and the target is to define groups of customers who are sharing characteristics within the group and showing differences from other groups, an unsupervised clustering technique is chosen to be the appropriate analytical technique in this project.

Clustering is an unsupervised machine learning technique, where there are no defined dependent and independent variables. The patterns in the data are used to identify similar observations .

The objective of clustering algorithms is to ensure that the distance between data points in a cluster is low compared to the distance between 2 clusters. In other words, members in the same group are very similar and members that are in different groups are extremely dissimilar, which perfectly suits the purpose of customer segmentation in this project.

In this project, I applied k-means and hierarchical clustering from clustering algorithms and finally chose the results of k-means. This is mainly due to the scale of our large datasets. 

Our website traffic data from GA has 903653 observations of 35 variables which is too large to be processed by hierarchical clustering. Although hierarchical clustering is simple and intuitive but does not scale well to large datasets. Thus, I chose the interactive clustering algorithm, k-means.
## **Result and Profile**
I used the elbow method to determine the optimal number of clusters. Based on the Total Within Sum of Squares Plot and the Ratio Plot, I decided to group the dataset into 4 clusters, where the distortion/inertia start decreasing slightly in a linear fashion.
<p align="center">
  <img src="https://raw.githubusercontent.com/claire-cheng/Google-Analytics-Segmentation-Analysis/main/Elbow_chart.png">
</p>
Within the 4 clusters, cluster 1 has c observations, cluster 2 has 78812 observations, cluster 3 has 271880 observations, and cluster 4 has 14645 observations.
<p align="center">
  <img src="https://raw.githubusercontent.com/claire-cheng/Google-Analytics-Segmentation-Analysis/main/Hits%20and%20Pageviews%20Analysis.png">
</p>
I calculate the average of hits and pageviews for each cluster. According to the chart, I can see that cluster 4 has much higher numbers for hits and page views compared to other clusters.
<p align="center">
  <img src="https://raw.githubusercontent.com/claire-cheng/Google-Analytics-Segmentation-Analysis/main/Visit%20Number%20Analysis.png">
</p>
Cluster 4 is also outstanding on hits and page views while cluster 1 has the top average visit numbers.
<p align="center">
  <img src="https://raw.githubusercontent.com/claire-cheng/Google-Analytics-Segmentation-Analysis/main/Transaction%20Revenue%20Analysis.png">
</p>
For the transaction revenues, most of them come from cluster 4. Cluster 1, with the minimal person, is the second largest source for transaction revenue.

According to the results, I believe that cluster 1 the niche market and cluster 4 is our target customer, thus I decided to focus on these two clusters.
<p align="center">
  <img src="https://raw.githubusercontent.com/claire-cheng/Google-Analytics-Segmentation-Analysis/main/Cluster%201%20Paid%20Users%20in%20US.png">
</p>
Cluster 1 consists of 1023 observations from different parts of the world. The majority of the visitors are english speakers with 81% of them being from the United States. Among these users from the United States, the majority of them are located in Virginia with a 36% of the total visitors in Cluster 1 and California comes in second with a 27%. Despite the number of visits to the store, while it is getting lots of returning users, the new users are minimal. Most of the users arrive to the site organically, in other words, the users actually visited the website by searching for Gstore on Google search engine and the majority of these users browsed the site from a desktop via Chrome. Of all the visits, transactions were only made on 17 of them by 2 users, one from Ann Arbor, Michigan, the other one from Salem, Virginia. Among all the transactions made, the bounce rate for Michigan is extremely low, with 88% of sessions ending in transactions. However, even though the numbers seem to be very appealing for Gstore to pay more attention to, due to the limited data available, further analysis is needed on external data in this specific area to draw any indications. On the other hand, Virginia is not only the state with the most visitors, but also the state that made the most revenue, with 96% of the total revenue made in Cluster 1. Another important thing to note is that 95% of the transactions were made during regular business hours, from 9 to 5, which is an indication that these 2 customers could be making purchases for their companies instead of their personal use.
<p align="center">
  <img src="https://raw.githubusercontent.com/claire-cheng/Google-Analytics-Segmentation-Analysis/main/Cluster%204%20Paid%20Users%20in%20US.png">
</p>
Cluster 4 has 14645 observations from 5 different continents. Compared to cluster 1, the most frequent visitor coming channel for cluster 4 is referral traffic, which means that the majority of visitors land on Gstore’s website from another website. These “other” websites may include partner sites, blogs, emails, posts on social media sites and more. In cluster 4, about 31.63% of observations have the transaction revenue. The main source is America, which contributes about 98.55% of the total transaction revenue.To be more specific, about 47.38% of them are from California, 23.26% of them are from New York, and about 7% of them are from Illinois. The majority of observations from cluster 4 are using Chrome as their browser from desktop. Most of them are using the Macintosh operating system, meanwhile, Chrome OS, Linux, and Windows are in the second level. 
## **Conclusion and Recommendation**
In conclusion, most of the transaction revenues are from Cluster 4. Even though Cluster 1 has the least number of visitors, it is the second largest source of Gstore’s transaction revenues. Therefore, Gstore should focus on these two clusters to establish its precision marketing strategy.

Based on the aforementioned analysis, I have 4 recommendations for Gstore listed as below:


  1. GStore is recommended to focus on the US market, especially in the states of California, New York, Illinois and Michigan.
  2. The marketing strategy should invest more in Search Engine Optimization and Online Referrals, which are the main sources of target customers.
  3. Marketing teams should review the referral traffic and do a further analysis to determine which sites are the ones that are redirecting visitors to GStore’s website.
  4. Gstore should deliver advertisements to the returning users who are using Chrome and Macintosh operating systems to make corporate purchases.
  
By performing the aforementioned recommendations, I believe GStore can improve its effectiveness and efficiency of the marketing communications and enhance its precision marketing strategy.

