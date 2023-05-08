# Stroke_Analysis
Goal: Detection (Prediction) of the possibility of a stroke in a person based on various parameters
Data exploration and model building will answer the following questions: 
How does the incidence of stroke vary based on the patient's smoking status? Are former smokers at a higher risk of stroke than current smokers or non-smokers?
Is there any difference in stroke incidence between rural and urban areas?
What is the distribution of patients with hypotension or heart disease? Is the incidence of stroke higher in patients with these conditions?
Does work related stress,low physical activity and long working hours associate to risk of having stroke?
Is proportion of stroke higher in female than male?


![th1](https://images.ctfassets.net/yixw23k2v6vo/3WpTUk6z52hVzvtTsPaWT/ef7c4d18a15e79f3d3533355ae380411/iStock-1168179082.jpg)
Dataset:
Kaggle dataset (https://www.kaggle.com/datasets/fedesoriano/stroke-prediction-dataset). 
This data source include 12 input parameters and over 5000 observations. 
No.	Attribute	Description
1	ID	Patient unique identifier
2	Gender	“male”, “female”, or “other”
3	Age	Age of the patient
4	Hypotension	0 if patient doesn’t have hypotension, 1 if they do
5	Heart disease	0 if patient doesn’t have heart disease, 1 if they do
6	Marital status	“yes” or “no”
7	Work type	"children", "Govt_jov", "Never_worked", "Private" or "Self-employed"
8	Residence	“rural” or “urban”
9	Average glucose level	Average glucose level In blood
10	BMI	Body mass index
11	Smoking status	"formerly smoked", "never smoked", "smokes" or "Unknown"
12	Stroke	1 if the patient had a stroke or 0 if not

Challenges 

Major challenges faced in the project are: 

Challenge 1: Gender feature with one occurrence of ‘Other’ class
One of the primary challenges is dealing with the "Other" class in the gender feature. To resolve this issue, the row containing the "Other" class is removed from the dataset, ensuring that only the male and female classes are retained.

Challenge 2: Occurrence of N/A values in BMI
Another challenge in the project is the presence of 201 N/A values in the BMI feature. These values can potentially skew the results of the analysis, leading to inaccurate predictions. To address this challenge, mean imputation is used to fill in the missing values.

Challenge 3: Imbalanced dataset
The occurrence of imbalanced data is another challenge in the project. The dependent variable stroke has a higher occurrence of 'No' than 'Yes', making it challenging to develop a model that could accurately predict the occurrence of stroke. To overcome this, we tuned hyperparameters with 5 fold cv to achieve optimal results for each model.

Challenge 4: Performance evaluation
Performance evaluation is a significant challenge in the project. The different models used, such as Logistic Regression, Decision tree, and random forest, preform differently on different evaluation metrices. For example, the Random Forest model worked better on accuracy, while Logistic Regression worked better on ROC. Since this is a classification problem, the logistic regression model is selected based on the ROC result.
