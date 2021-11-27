# GradDesc

This is a user manual of using the R package GradDesc. The purpose of the GradDesc package is to make a binary logistic regression with the use of the stochastic gradient descent algorithm. It works on every dataset but the exploratory variables have to be quantitative and the target variable has to be binary.
In this demonstration, we are going to use two different datasets : “breast_cancer” and "default_of_credit_card_clients" from UCI dataset to see how the algorithm behaves by exploiting the capacities of multicore processors.

Installing the package and access to the library
----------------------
    
Once the package is installed, the library can be load using the standard commands from R.

    install.packages("devtools")
    library(devtools)

    devtools::install_github("FD155/GradDesc")
    
    library(GradDesc)
    
    
How to understand the expectations of the function parameters
----------------------   
You can just use the fonction help(function name) to see all the documentation about your function.

    help("fit")
   
----------------------  
    
Short descriptions of datasets in the package
----------------------   

### Breast Cancer : 

This first dataset is about breast cancer diagnostic. Features are computed from a digitized image of a breast mass. The dataset contain 699 observations and 10 columns. The target variable is the class with two modalities : malignant cancer or begnin cancer. 

<img width="620" alt="Capture d’écran 2021-11-26 à 19 31 11" src="https://user-images.githubusercontent.com/73121667/143619934-0c3f828b-8c78-44bc-b141-85016d5d4bb0.png">


### Default of credit card clients :

The "default of credit card clients" data frame has 30 000 rows and 24 columns of data from customers default payments research. This research employed a binary variable, default payment (Yes = 1, No = 0), as the response variable.

<img width="649" alt="Capture d’écran 2021-11-26 à 19 43 24" src="https://user-images.githubusercontent.com/73121667/143620746-5a553513-0c7b-47eb-b1f7-cf3d447f1301.png">



    
Demonstration
----------------------  


Load your dataset
----------------------  
First, load your dataset on R like the example below. We begin with the shortest dataset, breast cancer. This dataset is included in the GradDesc package.

    breast_cancer <- ProjetR::breast
 
If you want to import another dataset, use the code below.
    
    library(readxl)
    data <- read_excel("/Users/.../breast.xlsx")


Fit function
----------------------   
To use the GradDesc R package, the first function you have to call is the fit function which corresponds to the implementation of binary logistic regression with stochastic gradient descent. The possibility of exploiting the capacities of multicore processors is available for the batch mode of the gradient descent. To detect the number of cores you have access on your computer, use this code :

    library(parallel)
    detectCores()
    
Then, call the fit function and store the function call in an object variable. You have to informed the target variable and the explanatory variables in the formula parameter. 

The gradient descent has three mode : the batch, mini-batch and online mode. Here, is an explanation of these mode in order to inform you which is the mode you want to apply.

#### Batch mode : 
Batch gradient descent is a variation of the gradient descent algorithm that calculates the error for each example in the training dataset, but only updates the model after all training examples have been evaluated.

#### Mini-batch mode : 
We use a batch of a fixed number of training examples which is less than the actual dataset and call it a mini-batch. The fixed number is call the batchsize and you can fix it in the parameters fit function.

#### Online mode : 
In Stochastic Gradient Descent (SGD), we consider just one example at a time to take a single step. 


The example below show you how to use the fit function.

    LogisticRegression <- fit(formula=classe~.,data=data,coef=0.5,mode="batch",batch_size=0,learningrate=0.1,max_iter=100)
    
You must obtain a graphic like this one which show you the loss function according to the number of epochs. Here, we chose the mode "batch" of the gradient descent with a number of iteration fixed at 100.

<img width="649" alt="Capture d’écran 2021-11-27 à 12 19 18" src="https://user-images.githubusercontent.com/73121667/143679048-3402404e-7da2-4794-b340-3d43b52c2f28.png">


To see the gradient descent, print or summarize it like this :

    print(LogisticRegression)
    summary(LogisticRegression)

The print call inform you which modality the algorithm takes as the positive modality. By default, it takes the modality that appears first in the dataset. This first call also show the number of epochs, the gradient descent use to converges to the final coefficients. You have access to these final coefficients and the loss function at each iteration. The summary call also gives you the formula on which the descent gradient is based. 


Now, let's see how the gradient descent behaves when using several ncores. Here, we chose to use 2 ncores on the fit function. 

    LogisticRegression <- fit(formula=classe~.,data=breast_cancer,coef=0.5,mode="batch",batch_size=10,learningrate=0.1,max_iter=100, ncores=2)

If you want to use more multicore processors, remember to see the number of cores on your computer with the code just above.

<img width="646" alt="Capture d’écran 2021-11-27 à 12 17 40" src="https://user-images.githubusercontent.com/73121667/143679002-d1bff5d7-96af-43cc-a12f-7ce53a6bcd47.png">

Now, you understand how to apply the fit function. Then, we use a bigger dataset to see the real utility of exploiting the capacities of multicore processors. That's why, we use the second dataset of the R package.
We compare the batch mode with 1 ncore and then 3 ncores on the batch mode. To see the time of calculs, you can use "system.time".

    print(system.time(LogisticRegression <- fit(formula=default~.,data=default_card,coef=0.5,mode="batch",batch_size=10,learningrate=0.1,max_iter=100, ncores=1)))

<img width="730" alt="Capture d’écran 2021-11-27 à 12 28 05" src="https://user-images.githubusercontent.com/73121667/143679280-7491640a-1c82-4417-bc64-dfa6aaf64f0c.png">

With one ncore, the time of the algorithm is about 23 seconds.

<img width="269" alt="Capture d’écran 2021-11-27 à 16 02 36" src="https://user-images.githubusercontent.com/73121667/143686670-e5b19de0-f9d1-4d52-88e2-2c27c3842aef.png">


    LogisticRegression <- fit(formula=default~.,data=default_card,coef=0.5,mode="batch",batch_size=10,learningrate=0.1,max_iter=100, ncores=3)

    
<img width="732" alt="Capture d’écran 2021-11-27 à 12 30 00" src="https://user-images.githubusercontent.com/73121667/143679331-51e5ad02-6878-4df0-8abe-020e7a8ce200.png">

<img width="260" alt="Capture d’écran 2021-11-27 à 16 03 11" src="https://user-images.githubusercontent.com/73121667/143686716-4b2deab0-44d6-49b9-9239-723f6c60e633.png">

With three ncores, the time of the algorithm is now about 14 seconds. The result is clear, the gradient descent is achieved faster when using the capacity of multicore processors.


If you want to use the other mode of the gradient descent, here are some examples and output you can have. The exploitation of the capacities of multicore processors are not available on the mini-batch and online mode.

    LogisticRegression <- fit(formula=default~.,data=default_card,coef=0.5,mode="mini-batch",batch_size=10,learningrate=0.1,max_iter=100, ncores=0)

<img width="728" alt="Capture d’écran 2021-11-27 à 12 36 04" src="https://user-images.githubusercontent.com/73121667/143679589-12a3f36b-3bb3-4743-b118-1e44f9af5e7e.png">

    LogisticRegression <- fit(formula=default~.,data=default_card,coef=0.5,mode="online",batch_size=1,learningrate=0.1,max_iter=100, ncores=0)
    
<img width="677" alt="Capture d’écran 2021-11-27 à 15 02 59" src="https://user-images.githubusercontent.com/73121667/143684711-1083c9c7-b720-416d-a674-8c608c4bcc32.png">



Predict function
----------------------   
The second function of the package is the predict function. Use it like the example below.




----------------------  

Let’s practice on your own dataset
----------------------  
Now that you have seen how the package works, it is up to you to use it on your own data. Remember to use the help() function to access to all the documentation.

Authors
----------------------  

Franck Doronzo, Candice Rajaonarivony, Gwladys Kerhoas
