#' Example sample dataset
#'
#' A simulated hemodynamics dataset included in bloodlines to illustrate usage.
#'
#' @format A tibble with 59,008 rows and 13 columns:
#' \describe{
#'   \item{id}{Character. Subect id, e.g. "1"}
#'   \item{time}{Numeric. Time in minutes from start of recording (by subect)}
#'   \item{timestamp}{POSIXct. Time stamp.}
#'   \item{cat_cpb}{Character. 'pre', 'intra', or 'post' cardiopulmonary bypass (CPB) status.}
#'   \item{val_map}{Numeric. value of mean arterial pressure (MAP) in mmHg}
#'   \item{val_cvp}{Numeric. value of central venous pressure (CVP) in mmHg}
#'   \item{cat_map}{Factor. category of MAP (<65 or >= 65)}
#' }
#' @source Simulated data, see https://github.com/jhuwit/fine_mapping_sim
"sample_df"

#' Example regression results
#'
#' A simulated regression result dataset included in bloodlines to illustrate usage
#'
#' @format A tibble with 25 rows and 7 columns
#' \describe{
#'   \item{x}{Factor: x-axis variable, e.g. "1" (hemodynamic range)}
#'   \item{y}{Factor: y-axis variable, e.g. "1" (hemodynamic range)}
#'   \item{estimate}{Numeric: Odds ratio estimate}
#'   \item{width}{Numeric: width of confidence interval}
#'   \item{ub}{Numeric: upper bound of confidence interval}
#'   \item{lb}{Numeric: lower bound of confidence interval}
#'   \item{p}{Numeric: p-value for regression}
#' }
#' @source Simulated data, see https://github.com/jhuwit/fine_mapping_sim
"reg_df"


