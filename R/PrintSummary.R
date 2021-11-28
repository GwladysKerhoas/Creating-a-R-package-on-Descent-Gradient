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
