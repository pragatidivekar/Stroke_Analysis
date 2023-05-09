# Stroke_Analysis
Goal: Detection (Prediction) of the possibility of a stroke in a person based on various parameters
- Data exploration and model building will answer the following questions: 
- How does the incidence of stroke vary based on the patient's smoking status? Are former smokers at a higher risk of stroke than current smokers or non-smokers?
- Is there any difference in stroke incidence between rural and urban areas?
- What is the distribution of patients with hypotension or heart disease? Is the incidence of stroke higher in patients with these conditions?
- Does work related stress,low physical activity and long working hours associate to risk of having stroke?
- Is proportion of stroke higher in female than male?


![th1](https://images.ctfassets.net/yixw23k2v6vo/3WpTUk6z52hVzvtTsPaWT/ef7c4d18a15e79f3d3533355ae380411/iStock-1168179082.jpg)
Dataset:
Kaggle dataset (https://www.kaggle.com/datasets/fedesoriano/stroke-prediction-dataset). 


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


Model Training:
The first step in model training involves splitting the dataset into training and testing sets. The training set is used to train the models, while the testing set is used to evaluate their performance. The models are trained using hyperparameter tuning with 5-fold cross-validation. They affect the behavior of the model and can significantly impact its performance. This process of using hyperparameter helps to reduce the risk of overfitting and ensures that the model is not only performing well on the training set but also on the unseen data.

Model Evaluation:
After training the models, their performance is evaluated using two metrics accuracy and ROC-AUC. Accuracy measures the percentage of correct predictions made by the model. Accuracy can be misleading when the dataset is imbalanced. This is because the model can achieve high accuracy by simply predicting the majority class for all instances. ROC AUC, on the other hand, is a metric that measures the performance of a binary classifier over all possible thresholds. It plots the True Positive Rate (TPR) against the False Positive Rate (FPR) for different thresholds and calculates the area under the curve (AUC).

Conclusion :
- 1.Through Exploratory Data Analysis it can be interpreted that Avg glucose level, BMI, Hypertension and heart disease are the biggest risk factors for stroke.
- 2.From our three models ie. Decision tree, Random forest and Logistic regression , Random forest gives best accuracy.
Logistic Regression gives best ROC-AUC curve than Decision tree and Random forest.
- 3.Considering the significant class imbalance in the dataset, accuracy may not be an appropriate metric for evaluating the models. 
- 4.If the goal is to optimize the model's performance in identifying stroke cases, even at the cost of some false positives, ROC-AUC may be a more appropriate metric to use. 
- 5.If the cost of false positives is very high, and a balance between precision and recall is desired, accuracy may be a better metric to use.



