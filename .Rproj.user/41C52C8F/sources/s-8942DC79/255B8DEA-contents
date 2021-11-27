#' Gradient Function
#'
#' The gradient of a function f, denoted as ∇f, is the collection of all its partial derivatives into a vector
#'
#' @param x Matrix of explanatory variables to predict
#' @param y Target Variable Matrix
#' @param theta Coefficient matrix for logistic regression
#'
#' @export
#' @return Returns a gradient vector
#'
#' @examples
#' gradient(x, y, coef)
gradient <- function(x, y, theta) {
  sig <- sigmoid(x%*%theta)
  gradient <- (t(x) %*% (sig-y)) / nrow(y)
  return(gradient)
}
