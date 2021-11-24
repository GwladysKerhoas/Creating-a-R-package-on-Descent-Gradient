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
#' @return
#' @export
#'

fit <- function(formula, data, mode, batch_size, ncores=0,coef,max_iter,learningrate,tol=1e-4){
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

  data = model.frame(formula, data = data)
  modele = formula
  #modelFit <- fitFun(formula = formula,data= data)
  n = nrow(data)

  x = as.matrix(data[,2:(ncol(data))])
  x = as.matrix(apply(x, 2, scale))
  b = matrix(1,nrow=nrow(x),ncol = 1)
  x = as.matrix(cbind(b,x))
  print(head(x))

  coef = matrix(coef,nrow=ncol(x),ncol = 1)

  y = as.matrix(data[,1])
  y = as.matrix(ifelse(y==data[1,1], 1,0))
  cible <- data[1,1]

  # Démarrage des moteurs (workers)
  #if (ncores!=0){
  #  clust <- parallel::makeCluster(ncores)
  #}

  iter <- 0
  converge <- FALSE
  new_coef = coef
  # Création de l'instance
  instance <- list()
  loss_history = c()
  while ((iter < max_iter) && (converge == FALSE)){
    if (mode == "batch"){

      # Predict value for the model
      c = cout(x,y,new_coef)
      loss_history = c(loss_history,c)
      if (ncores==0){
        z <- gradient(x, y, new_coef)
        new_coef = new_coef-(learningrate*z)
      } else{

        data = as.data.frame(cbind(y,x))


        # Partition en blocs des données
        blocs <- split(data,1+(1:n)%%ncores)
        blocs<-as.data.frame(blocs)
        print(class(blocs))
        c=c()
        nb_blocs <- 0
        for (i in blocs){
          c = c(c, nrow(blocs[[i]]))
          nb_blocs <- nb_blocs + 1
        }
        min = min(c)
        for (i in nb_blocs){
          blocs[[i]] <- blocs[[i]][0:min,]
        }

        # ParSapply
        #clusterExport(cl=clust, varlist=c("sigmoid", "gradient","gradient_xy", "cout"))
        #res <- parallel::parSapply(clust,X=blocs,FUN=gradient_xy,theta=new_coef)
        #new_coef = new_coef-(learningrate*res)
      }

      # Verification
      if (sum(abs(new_coef-coef)) < tol){
        converge <- TRUE
      }
      coef = new_coef
      plot(loss_history, type='l')
    }

    if (mode=="online" || mode=="mini-batch"){ # batch_size = 1 or 10

      # Tirage aléatoire
      data = cbind(y,x)
      rows <- sample(nrow(data))  # Melanger les indices du dataframe data
      data <- data[rows,] # Utiliser ces indices pour reorganiser le dataframe

      # Get the x and y batch
      #print("batch_size = ")
      #print(batch_size)
      x_batch = matrix(data[1:batch_size,2:(ncol(data))], nrow=batch_size, ncol=ncol(data)-1)
      y_batch = as.matrix(data[1:batch_size,1])

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
    # Next iteration
    iter <- iter +1

  }
  #instance$plot <- plot
  instance$cible = cible
  instance$index = colnames(data)
  instance$formula <- modele
  instance$coefficients <- coef
  instance$loss_history <- loss_history
  instance$nb_iter_while <- iter
  class(instance) <- "fit"
  # Renvoyer le résultat
  return(instance)
}

# print("Coefficients et temps de calcul pour descente gradient")
# print(system.time(LogisticRegression <- fit(formula=classe~.,coef=0.5,mode="batch",batch_size=1,data=data,max_iter=0,learningrate=0.1)))
# print(system.time(LogisticRegression <- fit(formula=classe~.,coef=0.5,data=data)))
# print(system.time(LogisticRegression <- fit(formula=coeur~age+pression+cholester+taux_max+depression+pic,coef=0.5,data=data)))
#
# # Objet Type S3
# summary.glm((LogisticRegression))
# print(LogisticRegression)
# print(LogisticRegression$formula)
# print(LogisticRegression$coef)
# print(LogisticRegression$loss_history)
# print(LogisticRegression$nb_iter_while)
#
# # List of definitions of the print procedure
# methods(print)
#
# # Définition of our print method
# print.fit <- function(objet){
#   # Improved display
#   cat("coef = ", objet$coef, "\n", "\n")
#   cat("loss_history = ",objet$loss_history,"\n", "\n")
#   cat("nb_iter_while = ",objet$nb_iter_while,"\n", "\n")
#   cat("modalité positive = ",objet$cible,"\n", "\n")
#   print(objet$plot)
# }
#
# # New list
# methods(print)
#
# # Display
# print(LogisticRegression)
#
# # Définition of our summary method
# methods(summary)
# summary.fit <- function(objet){
#   # Improved display
#   cat("Call ",Reduce(paste, deparse(objet$formula)),"\n")
#   cat("Coefficients : ", "\n", objet$coef, "\n", "\n")
#   cat("Number of iterations : ", "\n", objet$nb_iter_while, "\n")
# }
#
# summary.fit(LogisticRegression)
# print(LogisticRegression$plot1)
