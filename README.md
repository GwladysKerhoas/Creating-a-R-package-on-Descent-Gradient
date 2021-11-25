# ProjetR

The purpose of the ProjetR package is to make a binary logistic regression with the use of the stochastic gradient descent algorithm.
Next is a demonstration of how to use the R package.

Installing the package and access to the library
----------------------
    
    install.packages("devtools")
    library(devtools)

    devtools::install_github("FD155/ProjetR")
    
    library(ProjetR)
    
How to understand the expectations of the function parameters
----------------------   
You can juste use the fonction help(function name) to see all the documentation about your function.

    help("fit")
   
----------------------  
    
Short descriptions of datasets
----------------------   

Breast Cancer :


Default of credit card clients :


    
Demonstration
----------------------  


Load your dataset
----------------------  
First, load your dataset on R like the example below.
    
    library(readxl)
    data <- read_excel("/Users/.../breast.xlsx")


Fit function
----------------------   
The first function you have to call is the fit function which correspond to the implementation of binary logistic regression with stochastic gradient descent. The possibility of exploiting the capacities of multicore processors is available for the batch mode of the gradient descent. To detect the number of cores you have access on your computer, use this code :

    library(parallel)
    detectCores()
    
Then, call the fit function and store the function call in an object variable.

    LogisticRegression <- fit(formula=classe~.,data=data,coef=0.5,mode="online",batch_size=1,learningrate=0.1,max_iter=100)

The function returns an object of type S3 as output. To see the object, print or summarize it like this :

    print(LogisticRegression)
    summary(LogisticRegression)


Predict function
----------------------   
The second function of the package is the predict function.


----------------------  

Let’s practice on your own dataset
----------------------  
Now that you have seen how the package works, it is up to you to use it on your own data. Remember to use the help() function to access to all the documentation.

Authors
----------------------  

Franck Doronzo, Candice Rajaonarivony, Gwladys Kerhoas
