#' Predict Function
#'
#' prediction Binary or probabilities prediction
#'
#' @param objet the S3 object that the predict function returns
#' @param newdata dataframe explanatory variables on which to apply the prediction
#' @param type Output type "Posterior" (For predicted classes) or "class" (for the probability of class memberships)
#'
#' @import dplyr
#'
#' @return An instance with the probability of class memberships, or predictions
#' @export
#'
predict = function(objet, newdata ,type){
  instance = list()
  instance$pred = c()
  data = newdata
  coef = objet$coefficients
  index = objet$index
  test = index != colnames(data[,2:(ncol(data))])
  if(FALSE %in% test){
    stop("Jeu de donnees incorrect")
  }

  data = as.matrix(apply(data, 2, scale))
  b = matrix(1,nrow=nrow(data),ncol = 1)
  data = as.matrix(cbind(b,data))

  sig = sigmoid(data %*% as.matrix(coef))

  if(type=='posterior'){
    instance$classe = sig
  }else if(type=="class"){
    instance$classe = sig
    for(i in sig){
      if(i >0.5){
        instance$pred = c(instance$pred,1)
      } else {
        instance$pred = c(instance$pred,0)
      }

    }

  }


  class(instance) = "prediction"
  return(instance)
}

# pred = predict(LogisticRegression,X_Test,type = "class")
# Y_test2 = as.matrix(ifelse(pred$pred==1, "malignant","begnin"))
# table(Y_Test,Y_test2)
# prop.table(table(Y_Test,Y_test2))
