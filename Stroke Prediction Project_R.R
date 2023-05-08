rm(list=ls())
cat("\014")
getwd()
setwd("C:/Users/siddh/OneDrive - The University of Texas at Dallas/BA with R/Project")

#libraries
library(tidyverse)
library(caret)
library(randomForest)
library(skimr)
library(ggplot2)
library(gridExtra )
library(caTools)
library(corrplot)
library(ggcorrplot)
library(pROC)
library(plotly)

#read csv
stroke <- read.csv("strokedata.csv", stringsAsFactors = TRUE)

#summary
glimpse(stroke)
summary(stroke)
skim(stroke)

# Data Preprocessing

#BMI Data cleaning
stroke$bmi<-as.numeric(stroke$bmi)
stroke$bmi[stroke$bmi=="N/A"]=NA
#replacing NA in BMI with mean
stroke$bmi[is.na(stroke$bmi)]<-mean(stroke$bmi)
colSums(is.na(stroke))  #no missing values

#Removing other in gender
stroke <- stroke[stroke$gender != "Other", ]
nrow(stroke)

#Converting non-numeric variables to factors
stroke$stroke<- factor(stroke$stroke, levels = c(0,1), labels = c("No", "Yes"))

stroke$hypertension<-factor(stroke$hypertension,levels = c(0,1),labels=c("No","Yes"))

stroke$heart_disease<- factor(stroke$heart_disease, levels = c(0,1), labels = c("No", "Yes"))


# Plotting distribution of different features
p1<-ggplot(stroke,aes(x=gender,fill=gender))+geom_bar(col="black")+geom_text(aes(label=..count..),stat = "Count", vjust= 1.5)+ggtitle("Gender Distribution")

p2<-ggplot(stroke,aes(x="",fill=hypertension))+geom_bar(position = "fill")+coord_polar("y", start=0)+ggtitle("Distribution of Hypertension")

p3<-ggplot(stroke,aes(x="",fill=heart_disease))+geom_bar(position = "fill")+coord_polar("y")+ggtitle("Distribution of Heart Disease")

p4<-ggplot(stroke,aes(x=ever_married,fill=ever_married))+geom_bar(col="black")+geom_text(aes(label=..count..),stat = "Count", vjust= 1.5)+ggtitle("Marriage Status")

p5<-ggplot(stroke,aes(x="",fill=Residence_type))+geom_bar(position = "fill")+coord_polar("y", start = 0)+ggtitle("Distribution of Residence Type")

p6<-ggplot(stroke,aes(x="",fill=stroke))+geom_bar(position = "fill")+coord_polar("y", start = 0)+ggtitle("Distribution of Stroke occurence")

par(mfrow=c(3,2), mar=c(5,5,2,2), oma=c(0,0,2,0))
grid.arrange(p1,p4,p3,p2,p5,p6, ncol=2)

# Plotting visualizing for comparing stroke vs different varibles

p01<- ggplot(stroke,aes(x=gender,fill=stroke))+geom_bar(position ="fill")+ggtitle("Gendver vs Stroke")
p02<- ggplot(stroke,aes(x=hypertension,fill=stroke))+geom_bar(position ="fill")+ggtitle("Hypertension vs Stroke")
p03<- ggplot(stroke,aes(x=heart_disease,fill=stroke))+geom_bar(position ="fill")+ggtitle("Heart Disease vs Stroke")
p04<- ggplot(stroke,aes(x=ever_married,fill=stroke))+geom_bar(position ="fill")+ggtitle("Married Status vs Stroke")
p05<-ggplot(stroke,aes(x=work_type,fill=stroke))+geom_bar(position ="fill")+ggtitle("Work Type vs Stroke")
p06<-ggplot(stroke,aes(x=Residence_type,fill=stroke))+geom_bar(position ="fill")+ggtitle("Residence Type vs Stroke")
p07<-ggplot(stroke,aes(x=smoking_status,fill=stroke))+geom_bar(position ="fill")+ggtitle("Smoking Status vs Stroke")


grid.arrange(p01,p02,p03,p04,p06, ncol=3)
grid.arrange(p05,p07, ncol=1)

#bmi vs stroke visualization
g<- ggplot(stroke,aes(x=stroke,y = bmi, fill = gender))
g + geom_boxplot()+
  labs(title="BMI vs Stroke", 
       x="Stroke",
       y="Body Mass Index")


#age vs stroke visualization
g<- ggplot(stroke,aes(x=stroke,y = age, fill = gender))
g + geom_boxplot()+
  labs(title="Age vs Stroke", 
       x="Stroke",
       y="Age")

#glucose level vs stroke visualization
g<- ggplot(stroke,aes(x=stroke,y = avg_glucose_level, fill = gender))
g + geom_boxplot()+
  labs(title="Avg Glucose Level vs Stroke", 
       x="Stroke",
       y="Avg. Glucose Level")



# Building Models

#train - test split

set.seed(123) 
train_set<-sample(1:nrow(stroke),nrow(stroke)*2/3)
train<- stroke[train_set,]
test<- stroke[-train_set,]

# Train Logistic Regression with hyperparameter tuning
set.seed(123)
lr_model <- train(stroke ~ ., data = train, method = "glm",
                  trControl = trainControl(method = "cv", number = 5),
                  tuneLength = 10)

# Train Random Forest with hyperparameter tuning
set.seed(123)
rf_model <- train(stroke ~ ., data = train, method = "rf",
                  trControl = trainControl(method = "cv", number = 5),
                  tuneLength = 10)


# Train Decision Tree with hyperparameter tuning
set.seed(123)
dt_model <- train(stroke ~ ., data = train, method = "rpart",
                  trControl = trainControl(method = "cv", number = 5),
                  tuneLength = 10)

# Predict on test data
lr_preds <- predict(lr_model, newdata = test)
rf_preds <- predict(rf_model, newdata = test)
dt_preds <- predict(dt_model, newdata = test)

#Confusion Matrix for three models
lr_cm =  confusionMatrix(lr_preds, test$stroke)
rf_cm =  confusionMatrix(rf_preds, test$stroke)
dt_cm =  confusionMatrix(dt_preds, test$stroke)


print(lr_cm$table)
print(rf_cm$table)
print(dt_cm$table)

# Evaluate performance
lr_accuracy <- lr_cm$overall[1]  
rf_accuracy <- rf_cm$overall[1]
dt_accuracy <- dt_cm$overall[1]


lr_auc <- roc(test$stroke, predict(lr_model, newdata = test, type = "prob")[,2])$auc
rf_auc <- roc(test$stroke, predict(rf_model, newdata = test, type = "prob")[,2])$auc
dt_auc <- roc(test$stroke, predict(dt_model, newdata = test, type = "prob")[,2])$auc

# Print results for accuracy
cat("Logistic Regression accuracy: ", lr_accuracy, "\n")
cat("Random Forest accuracy: ", rf_accuracy, "\n")
cat("Decision Tree accuracy: ", dt_accuracy, "\n")

# Plotting accuracy

# create a data frame with the parameter names and their values 
parameter_names <- c("Logistic Regression", "Random Forest", "Descision Tree") 
parameter_values <- c(lr_accuracy, rf_accuracy, dt_accuracy) 
data <- data.frame(Parameter = parameter_names, Accuracy = parameter_values) 

# create the bar chart 
gg = ggplot(data, aes(x = Parameter, y = Accuracy))+geom_bar(stat = "identity", aes(fill = parameter_names))+labs(title = "Accuracy Comparison", x = "Parameter", y = "Accuracy")
gg+geom_text(aes(label=round(parameter_values,5)), vjust=-0.3, size=3.5)

# Print results for AUC
cat("Logistic Regression AUC: ", lr_auc, "\n")
cat("Random Forest AUC: ", rf_auc, "\n")
cat("Decision Tree AUC: ", dt_auc, "\n")

# Plot ROC curves
par(mfrow=c(1,3))
plot(roc(test$stroke, predict(lr_model, newdata = test, type = "prob")[,2]), main = "Logistic Regression ROC")
plot(roc(test$stroke, predict(rf_model, newdata = test, type = "prob")[,2]), main = "Random Forest ROC")
plot(roc(test$stroke, predict(dt_model, newdata = test, type = "prob")[,2]), main = "Decision Tree ROC")

lr_prob <- predict(lr_model, newdata = test, type = "prob")[,2]
rf_prob <- predict(rf_model, newdata = test, type = "prob")[,2]
dt_prob <- predict(dt_model, newdata = test, type = "prob")[,2]

par(mar = c(5, 6, 4, 2) + 0.1, mfrow = c(1, 1))

plot(roc(test$stroke, lr_prob), col = "blue", main = "ROC Curves Comparison")
plot(roc(test$stroke, rf_prob), col = "red", add = TRUE)
plot(roc(test$stroke, dt_prob), col = "green", add = TRUE)

# Add a legend
legend("topleft", legend = c("Logistic Regression", "Random Forest", "Decision Tree"), 
       col = c("blue", "red", "green"), lty = 1, cex = 0.8, bty = "n")

#visualizing the feature importance in logistic regression
# Extract the variable importance using the caret library
importance <- varImp(lr_model)

# Create a bar chart of the variable importance in logistic regression using ggplot2
ggplot(importance, aes(x = rownames(importance), y = Overall)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  xlab("Features") + ylab("Importance") +
  ggtitle("Feature Importance in Logistic Regression Model")


