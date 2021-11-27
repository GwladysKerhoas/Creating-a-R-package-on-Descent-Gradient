#' CostFunction
#'
#' A loss function is a method of evaluating how well your algorithm models your datasets
#' If they're pretty good, it will output a lower number
#'
#' @param x Matrix of explanatory variables to predict
#' @param y Target Variable Matrix
#' @param theta Coefficient matrix for logistic regression
#'
#' @return
#' @export
#' @examples
#' cout(x,y,coef)
cout = function(x,y,theta){
  sig <- sigmoid(x%*%theta)
  cost = (1 / nrow(y)) * sum((-y * log(sig)) - ((1 - y) * log(1 - sig)))
  #print(cost)
  return (cost)
}
