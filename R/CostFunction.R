#' CostFunction
#'
#'
#' @param x matrice des variables explicatives
#' @param y variable cible à prédire 
#' @param theta coefficient de la regression logistique
#'
#' @export
#' @return 
CostFunction = function(x,y,theta){
  sig <- sigmoid(x%*%theta)
  cost = mean((-y*log(sig))-((1-y)*log(1-sig)))
  #print(cost)
  return (cost)
}