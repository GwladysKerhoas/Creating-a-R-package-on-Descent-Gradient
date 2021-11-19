#' Gradient Function
#'
#' 
#' @param x matrice des variables explicatives
#' @param y variable cible à prédire
#' @param theta coefficient de la regression logistique
#' 
#' @export
#' @return Retourne un vecteur de gradient
#'
gradient <- function(x, y, theta) {
  sig <- sigmoid(x%*%theta)
  gradient <- (t(x) %*% (sig-y)) / nrow(y)
  return(gradient)
}
