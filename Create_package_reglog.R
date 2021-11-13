#' Implementation of binary Logistic Regression
#'
#' @docType package
#' @name logisticregression
"_PACKAGE"

# Set up the package
create("logisticregression")

# Examine the contents of the current directory
dir("logisticregression")

#' Implementation of binary Logistic Regression
#'
#' Function fit based on the algorithm stochastic gradient descent
#'
#' @param formula is the problem to solve 
#' @param data is a dataframe 
#' @param mode is the coefficient update mode
#' @param batch_size
#' @param ncores is the number of hearts to use
fit <-function(formula, data, mode, batch_size, ncores){
  
  # Verification on the formula
  if (!is.formula(formula)){
    stop("Formula must be class formula")
  } 
  
  # Include an error if some variables are not numeric
  if(!is.data.frame(data)){
    stop("Data must be a dataframe")
  }
  
  
}

# Test fit() function
fit(iris)


# What is in the R directory before adding a function?
dir("logisticregression/R")

# Use the dump() function to write the fit function
dump("fit", file = "logisticregression/R/fit.R")

# Verify that the file is in the correct directory
dir("logisticregression/R")


#' Implementation of the prediction
#'
#' 
#'
#' @param reglog is a S3 object return by the fit function 
#' @param newdata is a new dataframe
#' @param type indicate the type of the prediction
predict <-function(reglog, newdata, type){
  
  
}

# Test predict() function
predict(iris)

# Write the function to the R directory
dump("predict", file = "logisticregression/R/predict.R")


#################### DOCUMENTATION #####################

# Generate package documentation
document("logisticregression")

# Examine the contents of the man directory
dir("logisticregression/man")

# View the documentation for the fit and predict function
help("fit")
help("predict")



#################### CHECKING #####################

# Check your package
check("logisticregression")

# Set up the test framework
use_testthat("logisticregression")


