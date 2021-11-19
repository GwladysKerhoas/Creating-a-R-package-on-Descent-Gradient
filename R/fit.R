# Clear the environment
rm(list=ls())

library(readxl)

sigmoid <-
  function(x){
    return(1/(1+exp(-x)))
  }

gradient <- function(x, y, theta) {
  sig <- sigmoid(x%*%theta)
  gradient <- (t(x) %*% (sig-y)) / nrow(y)
  return(gradient)
}

cout = function(x,y,theta){
  sig <- sigmoid(x%*%theta)
  cost = mean((-y*log(sig))-((1-y)*log(1-sig)))
  #print(cost)
  return (cost)
}


# Get the data
data <- read_excel("breast.xlsx")
data <- read_excel("heart_train_test.xlsx")

fit = function(formula, data, mode = "batch", batch_size=0 , ncores=0,coef,max_iter=1000,learningrate=0.1,tol=1e-4){
  data = model.frame(formula, data = data)
  x = as.matrix(data[,2:(ncol(data))])
  x = as.matrix(apply(x, 2, scale))
  b = matrix(1,nrow=nrow(x),ncol = 1)
  x = as.matrix(cbind(b,x))
  
  coef = matrix(coef,nrow=ncol(x),ncol = 1)
  
  y = as.matrix(data[,1])
  y = as.matrix(ifelse(y=="malignant", 1,0))
  
  iter <- 0
  converge <- FALSE
  new_coef = coef
  max_iter=100
  loss_history = c()
  while ((iter < max_iter) && (converge == FALSE)){
    
    # Next iteration
    iter <- iter +1
    # Predict value for the model
    c = cout(x,y,new_coef)
    #print(c)
    loss_history = c(loss_history,c)
    #print(loss_history)
    z <- gradient(x,y,new_coef)
    new_coef = new_coef-(learningrate*z)
    
    # Verification
    if (sum(abs(new_coef-coef)) < tol){
      converge <- TRUE
    }
    theta = new_coef
    plot(loss_history)
  }
  return(theta)
}

print("Coefficients et temps de calcul pour descente gradient")
print(system.time(coef_grad <- fit(formula=classe~.,coef=0.5,data=data)))
print(system.time(coef_grad <- fit(formula=coeur~age+pression+cholester+taux_max+depression+pic,coef=0.5,data=data)))
print(coef_grad)


#f <- glm(classe ~ clump+ucellsize+ucellshape+mgadhesion+sepics+bnuclei+bchromatin+normnucl+mitoses, data=data)
#f <- glm(coeur ~ age+pression+cholester+taux_max+depression+pic, data=data)
#summary(f)
#f$coefficients


