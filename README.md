# ProjetR

The purpose of the ProjetR package is to make a binary logistic regression with the use of the stochastic gradient descent algorithm.
Next is a demonstration of how to use the R package.

Installing the package and access to the library
----------------------
    
    install.packages("devtools")
    library(devtools)

    devtools::install_github("FD155/ProjetR")
    
    library(ProjetR)
    
How to access to help
----------------------   
You can juste use the fonction help(function name) to see all the documentation about your function.

    help("fit")
    
Short Descriptions of datasets
----------------------   

Breast Cancer :


Default of credit card clients :


    
Demonstration
----------------------   


Fit function
----------------------   
The first function you have to call is the fit function which correspond to the implementation of binary logistic regression with stochastic gradient descent. The possibility of exploiting the capacities of multicore processors is available for the batch mode of the gradient descent. To detect the number of cores you have access on your computer, use this code :

    detectCores()


Predict function
----------------------   
The second function of the package is the predict function.



Let’s practice on your own dataset
----------------------  
Now that you have seen how the package works, it is up to you to use it on your own data. Remember to use the help() function to access to all the documentation.

Authors
----------------------  

Franck Doronzo, Candice Rajaonarivony, Gwladys Kerhoas
