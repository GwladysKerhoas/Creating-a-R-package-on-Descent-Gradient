#' Fit Function
#'
#' Implementation of binary logistic regression with stochastic gradient descent for algorithm
#'
#' @param formula Target variable ~ explanatory variables
#' @param data dataframe required to perform the gradient descent
#' @param mode Gradient descent mode (Online, Mini-Batch, Batch)
#' @param batch_size size of the cutting to be carried out for the "mini-batch" mode
#' @param ncores Number of cores required for parallelization
#' @param coef Fixed number for creating the base vector
#' @param max_iter Max number of iterations not to be exceeded
#' @param learningrate Learning rate which determines the step of the descent
#' @param tol Tolerance threshold for which convergence is said to be "finished"
#'
#' @import parallel
#' @import dplyr
#'
#' @return
#' @export
#'
fit <- function(formula, data, mode, batch_size, ncores=0,coef,max_iter=100,learningrate=0.1,tol=1e-4){
  if ((mode != "batch") && (mode != "mini-batch") && (mode != "online")){
    stop("mode incorrect")
  }
  if ((mode == "online") && (batch_size !=1)){
    stop("batch size incorrect pour ce mode")
  }
  if (learningrate <= 0){
    stop("learning rate incorrect")
  }
  if (max_iter <= 0){
    stop("max_iter incorrect")
  }

  # Création de l'instance
  instance <- list()

  data = model.frame(formula, data = data)
  modele = formula

  x = as.matrix(data[,2:(ncol(data))])
  x = as.matrix(apply(x, 2, scale))
  b = matrix(1,nrow=nrow(x),ncol = 1)
  x = as.matrix(cbind(b,x))

  coef = matrix(coef,nrow=ncol(x),ncol = 1)

  y = as.matrix(data[,1])
  y = as.matrix(ifelse(y==data[1,1], 1,0))
  cible = data[1,1]

  # Démarrage des moteurs (workers)
  if (ncores!=0){
    clust = parallel::makeCluster(ncores)
  }

  iter = 0
  converge = FALSE
  loss_history = c()
  while ((iter < max_iter) && (converge == FALSE)){
    if (mode == "batch"){

      if (ncores==0){

        # Predict value for the model
        c = cout(x,y,coef)
        loss_history = c(loss_history,c)

        z = gradient(x, y, coef)
        new_coef = coef-(learningrate*z)

      }else{

        data = as.data.frame(cbind(y,x))
        n = nrow(data)

        # Partition en blocs des données
        blocs = split(data,1+(1:n)%%ncores)
        #print(class(blocs))

        # ParSapply
        clusterExport(cl=clust, varlist=c("sigmoid", "gradient","gradient_xy", "cout"))
        res = parallel::parSapply(clust,X=blocs,FUN=gradient_xy,theta=coef)
        mean_coef=c()
        for (i in 1:nrow(res)){
          mean_coef = c(mean_coef,mean(res[i,]))
        }
        mean_coef = as.matrix(mean_coef)
        new_coef = coef-(learningrate*mean_coef)

        blocs_1 = as.matrix(blocs[[1]])
        y_blocs = as.matrix(blocs_1[,1])
        x_blocs = as.matrix(blocs_1[,2:ncol(blocs_1)])
        #print(x_blocs)

        # Predict value for the model
        c = cout(x_blocs,y_blocs,mean_coef)
        #print(loss_history)
        loss_history = c(loss_history,c)
      }

      # Verification
      if (sum(abs(new_coef-coef)) < tol){
        converge = TRUE
      }
      coef = new_coef
      plot(loss_history, type='l',main = "Evolution of the cost function")
    }

    if (mode=="mini-batch"){

      # Tirage aléatoire
      data = cbind(y,x)
      rows = sample(nrow(data))  # Melanger les indices du dataframe data
      data = data[rows,] # Utiliser ces indices pour reorganiser le dataframe

      # Get the x and y batch
      x_batch = matrix(data[1:batch_size,2:ncol(data)], nrow=batch_size, ncol=ncol(data)-1)
      y_batch = as.matrix(data[1:batch_size,1])

      # Loss function
      c = cout(x_batch,y_batch,coef)
      loss_history = c(loss_history,c)

      # Gradient function
      z = gradient(x_batch, y_batch, coef)
      new_coef = coef - learningrate*z

      # Verification
      if (sum(abs(new_coef-coef)) < tol){
        converge = TRUE
      }

      coef = new_coef
      # Verification of the loss function
      plot(loss_history, type="l",main = "Evolution of the cost function")
    }

    if (mode=="online"){

      # Tirage aléatoire
      data = cbind(y,x)
      rows = sample(nrow(data))  # Melanger les indices du dataframe data
      data = data[rows,] # Utiliser ces indices pour reorganiser le dataframe
      n=nrow(data)

      
      # Get the x and y batch
      x_batch = matrix(data[1,2:ncol(data)], nrow=1, ncol=ncol(data)-1)
      y_batch = matrix(data[1,1])

      # Loss function
      c = cout(x_batch,y_batch,coef)
      loss_history = c(loss_history,c)

      # Gradient function
      z = gradient(x_batch, y_batch, coef)
      new_coef = coef - learningrate*z
      

      # Verification
      if (sum(abs(new_coef-coef)) < tol){
        converge = TRUE
      }
      coef = new_coef
      # Verification of the loss function
      plot(loss_history, type="l",main = "Evolution of the cost function")
    }

    # Next iteration
    iter = iter +1

  }
  # Eteindre les moteurs
  if (ncores!=0){
    parallel::stopCluster(clust)
  }
  instance$cible = cible
  instance$index = colnames(data[,2:(ncol(data))])
  instance$formula = modele
  instance$coefficients = coef
  instance$loss_history = loss_history
  instance$nb_iter_while = iter
  class(instance) = "fit"
  # Renvoyer le résultat
  return(instance)
}


# Définition of our print method
#' Print Overload
#'
#' @param objet the S3 object that the fit function returns
#'
#' @return Print all the objects of the instance
#' @export
#'
print.fit <- function(objet){
  # Improved display
  cat("coef = ", objet$coef, "\n", "\n")
  cat("loss_history = ",objet$loss_history,"\n", "\n")
  cat("nb_iter_while = ",objet$nb_iter_while,"\n", "\n")
  cat("modalité positive = ",objet$cible,"\n", "\n")
}


# Définition of our summary method
#' Summary Overload
#'
#' @param objet the S3 object that the fit function returns
#'
#' @return Print the trained model, the final coefficients and the number of iterations executed.
#' @export
#'
summary.fit <- function(objet){
  # Improved display
  cat("Call ",Reduce(paste, deparse(objet$formula)),"\n")
  cat("Coefficients : ", "\n", objet$coef, "\n", "\n")
  cat("Number of iterations : ", "\n", objet$nb_iter_while, "\n")
}






