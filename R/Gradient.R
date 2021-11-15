#' Gradient Function
#'
#' 
#' @param x matrice des variables explicatives
#' @param y variable cible à prédire
#' @param theta coefficiant de la regression logistique
#' 
#' @export
#' @return Retourne un vecteur de gradient
#'
gradient <-
function(x, y, theta) {
  sig = sigmoid(x%*%t(theta))
  gradient <- ((1 / nrow(y)) * (t(x) %*% (sig) - y))
return(t(gradient))
}
