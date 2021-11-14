gradient <-
function(x, y, theta) {
  sig = sigmoid(x%*%t(theta))
  gradient <- ((1 / nrow(y)) * (t(x) %*% (sig) - y))
return(t(gradient))
}
