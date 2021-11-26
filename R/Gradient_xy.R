#' Gradient Function
#'
#' The gradient of a function f for the parallelisation, denoted as ∇f, is the collection of all its partial derivatives into a vector
#'
#' @param data dataframe required to perform the gradient descent
#' @param theta Coefficient matrix for logistic regression
#'
#' @export
#' @return Returns a gradient vector
#'
#' @examples
#' gradient_xy(data_ex, coef_ex)
gradient_xy <- function(data, theta) {
  y <- as.matrix(data[,1])
  x <- as.matrix(data[,2:ncol(data)])
  sig <- sigmoid(x%*%theta)
  gradient <- (t(x) %*% (sig-y)) / nrow(y)
  return(gradient)
}
