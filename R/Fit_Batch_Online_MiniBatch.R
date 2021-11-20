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
  #x = as.matrix(apply(x, 2, scale))
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
    if (mode == "batch"){
      # Next iteration
      #iter <- iter +1
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
      coef = new_coef
      plot(loss_history)
    }
    
    if (mode=="online" || mode=="mini-batch"){ # batch_size = 1 or 10
      
      # Tirage aléatoire à chaque itération : on prend le nombre de batch_size indiqué 
      # dans la fonction et on réitère autant de fois au'il n'y a d'itération
      
      # Tirage aléatoire
      data = cbind(x,y)
      rows <- sample(nrow(data))  # Melanger les indices du dataframe data
      data <- data[rows,] # Utiliser ces indices pour reorganiser le dataframe
      
      # Get the x and y batch
      print("batch_size = ")
      print(batch_size)
      x_batch = matrix(data[1:batch_size,1:(ncol(data)-1)], nrow=batch_size, ncol=ncol(data)-1)
      y_batch = as.matrix(data[1:batch_size,ncol(data)])
      print(x_batch)
      print(y_batch)
      
      # Loss function
      c <- cout(x_batch,y_batch,new_coef)
      loss_history <- c(loss_history,c)
      
      # Gradient function
      z <- gradient(x_batch, y_batch, new_coef)
      new_coef = new_coef - learningrate*z
      
      # Verification
      if (sum(abs(new_coef-coef)) < tol){
        converge <- TRUE
      }
      coef = new_coef
      
      # Verification of the loss function
      plot(loss_history, type="l")
      
    }
    iter <- iter +1

  }
  return(coef)
}

print("Coefficients et temps de calcul pour descente gradient")
print(system.time(coef_grad <- fit(formula=classe~.,coef=0.5,mode="online",batch_size=1,data=data)))
print(system.time(coef_grad <- fit(formula=classe~.,coef=0.5,data=data)))
print(system.time(coef_grad <- fit(formula=coeur~age+pression+cholester+taux_max+depression+pic,coef=0.5,data=data)))
print(coef_grad)


#f <- glm(classe ~ clump+ucellsize+ucellshape+mgadhesion+sepics+bnuclei+bchromatin+normnucl+mitoses, data=data)
#f <- glm(coeur ~ age+pression+cholester+taux_max+depression+pic, data=data)
#summary(f)
#f$coefficients


