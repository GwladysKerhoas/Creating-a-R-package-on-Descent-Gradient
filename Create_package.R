#' Custom Data Summaries
#'
#' Easily generate custom data frame summaries
#'
#' @docType package
#' @name datasummary
"_PACKAGE"

# Update this function call
utils::globalVariables(c("weather","Temp"))

# Add dplyr as an imported dependency to the DESCRIPTION file
use_package("dplyr", pkg = "datasummary")

# Add purrr as an imported dependency to the DESCRIPTION file
use_package("purrr", pkg = "datasummary")

# Add tidyr as an imported dependency to the DESCRIPTION file
use_package("tidyr", pkg = "datasummary")


#' Random Weather Data
#'
#' A dataset containing randomly generated weather data.
#'
#' @format A data frame of 7 rows and 3 columns
#' \describe{
#'  \item{Day}{Numeric values giving day of the week, 1 = Monday, 7 = Sunday}
#'  \item{Temp}{Numeric values giving temperature in degrees Celsius}
#'  \item{Weather}{Character values describing the weather on that day}
#' }
#' @source Randomly generated data
"weather"

# Build the package
build("datasummary")

# Examine the contents of the current directory
dir("datasummary")

# Use the create function to set up your first package
create("datasummary")

# Take a look at the files and folders in your package
dir("datasummary")


# Add a title and description
#' Numeric Summaries
#'
#' Summarises numeric data and returns a data frame containing the minimum value, median, standard deviation, and maximum value.
#'
#' @param x a numeric vector containing the values to summarize.
#' @param na.rm a logical value indicating whether NA values should be stripped before the computation proceeds.
numeric_summary <- function(x, na.rm) {

    # Include an error if x is not numeric
    if(!is.numeric(x)){
        stop("Data must be numeric")
    }
    
    # Create data frame
    data.frame( min = min(x, na.rm = na.rm),
                median = median(x, na.rm = na.rm),
                sd = sd(x, na.rm = na.rm),
                max = max(x, na.rm = na.rm))
}

# Test numeric_summary() function
numeric_summary(airquality$Ozone, na.rm = TRUE)


# What is in the R directory before adding a function?
dir("datasummary/R")

# Use the dump() function to write the numeric_summary function
dump("numeric_summary", file = "datasummary/R/numeric_summary.R")

# Verify that the file is in the correct directory
dir("datasummary/R")


# What is in the package at the moment?
dir("datasummary")

# Add the weather data
use_data(weather, pkg = "datasummary", overwrite = TRUE)

# Add a vignette called "Generating Summaries with Data Summary"
use_vignette("Generating_Summaries_with_Data_Summary", pkg = "datasummary")

# What directories do you now have in your package now?
dir("datasummary")

#' Summary of Numeric Columns
#'
#' Generate specific summaries of numeric columns in a data frame
#' 
#' @param x A data frame. Non-numeric columns will be removed
#' @param na.rm A logical indicating whether missing values should be removed
#' @import purrr
#' @import dplyr
#' @importFrom tidyr gather
#' @export
#' @examples
#' data_summary(iris)
#' data_summary(airquality, na.rm = FALSE)
#' @return This function returns a \code{data.frame} including columns: 
#' \itemize{
#'  \item ID
#'  \item min
#'  \item median
#'  \item sd
#'  \item max
#' }
#'
#' @author My Name <myemail@example.com>
#' @seealso \link[base]{summary}
data_summary <- function(x, na.rm = TRUE){
  
  num_data <- select_if(x, .predicate = is.numeric) 
  
  map_df(num_data, .f = numeric_summary, na.rm = TRUE, .id = "ID")
  
}

# Write the function to the R directory
dump("data_summary", file = "datasummary/R/data_summary.R")




#################### DOCUMENTATION #####################

# Generate package documentation
document("datasummary")

# Examine the contents of the man directory
dir("datasummary/man")

# View the documentation for the data_summary function
help("data_summary")

# View the documentation for the weather dataset
help("weather")




#################### CHECKING #####################

# Check your package
check("datasummary")

# Set up the test framework
use_testthat("datasummary")

# Look at the contents of the package root directory
dir("datasummary")

# Look at the contents of the new folder which has been created 
dir("datasummary/tests")

# Create a summary of the iris dataset using your data_summary() function
iris_summary <- data_summary(iris)

# Count how many rows are returned
summary_rows <- nrow(iris_summary) 

# Use expect_equal to test that calling data_summary() on iris returns 4 rows
expect_equal(summary_rows, expected=4)

result <- data_summary(weather)

# Update this test so it passes
expect_equal(result$sd, c(2.1, 3.6), tolerance = 0.1)

expected_result <- list(
    ID = c("Day", "Temp"),
    min = c(1L, 14L),
    median = c(4L, 19L),
    sd = c(2.16024689946929, 3.65148371670111),
    max = c(7L, 24L)
)

# Write a passing test that compares expected_result to result
expect_equivalent(result, expected_result)