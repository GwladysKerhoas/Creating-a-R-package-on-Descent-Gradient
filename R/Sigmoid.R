#' Sigmoid Function
#'
#' @param x Variable a predire
#'
#' @export
#' @return Retourne les probabilités d'appartenance aux classe positives/négatives
#'
sigmoid <-
function(x){
  return(1/(1+exp(-x)))
}
