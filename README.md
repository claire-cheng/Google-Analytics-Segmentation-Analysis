# Google Analytics Segmentation Analysis
## **Project Aims and Background**
Google Analytics (GA) is a web analytics service that tracks and reports website traffic. GA is offering this tool to e-commerce companies and those who operate on digital platforms to better understand their customers and make sure of these business insights to take actions and make better decisions. 

GA’s marketing teams are challenged to make appropriate investments in its promotional strategies. However, GA is not sure whether the data they are providing to the clients are enough to do predictive analytics on revenue. In this project, we are analyzing a Google Merchandise Store, called GStore, where Google products are sold. We will be using GStore’s customer dataset that was collected from Google Analytics to predict revenue per customer- the natural log of the sum of all transactions per user. For every user in the test set, the target is:
<p align="center">
  <img src="https://raw.githubusercontent.com/claire-cheng/Google-Analytics-Segmentation-Analysis/main/Formula.png" width="300" height="150">
</p>
The goal of this project is to build an algorithm with appropriate customer segments to help GStore’s marketing team make precision marketing strategies. We need to build an algorithm with the lowest root mean squared error, which is defined as: 
<p align="center">
  <img src="https://raw.githubusercontent.com/claire-cheng/Google-Analytics-Segmentation-Analysis/main/RMSE.png" width="300" height="150">
</p>
where y hat is the projected revenue for a customer and y is the natural log of the actual revenue value.
## **Data Collection & Preparation**
The data is provided by Kaggle. There are 2 different CSV files:

 - train.csv:
    - This is the training dataset that contains user transactions from August 1st, 2016 to April 30th, 2018.
 - test.csv:
    - This is the testing dataset that contains user transactions from May 1st, 2018 to October 15th, 2018.
Both of the train and the test sets contain the columns listed under Data Fields (below). The only difference between the train and test sets is the extra information stored in the train set, TransactionRevenue, under one of the JSON columns, Totals. This sub-column  TransactionRevenue contains the revenue information we are trying to predict in this project. In addition, each row in the datasets represents one visit to the GStore. 
## **Data Fields**
  1. ChannelGrouping: the channel via which the user came to the store. There are total 8 factors: Organic search, Paid search, Display, Direct, Referral, Social, Affiliates, Other.
  2. Date: record the date when the user visited the store.
  3. FullVisitorId: A unique identifier for each user of the Google Merchandise Store.
  4. SessionId: A unique identifier to identify a session, a series of related message exchanges. For example, there may involve an ongoing communication where several web pages are requested by the client before they check out, session id is the tool to keep track of the current status of the shopper’s cart.
  5. VisitId: An identifier for this session. This is part of the value usually stored as the _utmb cookie. 
  6. VisitNumber: The session number for this user. If this is the first session, then this is set to 1. It is stored as an integer.
  7. VisitStartTime: A timestamp records the date of customer visiting. This variable is expressed as POSIX time. For POSIX time, every day is treated as if it contains exactly 86400 seconds, so it calculated as (sum of days between current date and 1970-01-01) * 86400.
  8. Device (JSON):

