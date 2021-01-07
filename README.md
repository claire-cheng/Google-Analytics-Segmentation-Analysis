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

 - train.csv
  - This is 
