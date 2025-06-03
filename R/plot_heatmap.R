#' Create a heatmap from regression results where regression predictors can be represented as combination of two variables
#'
#'
#' @importFrom dplyr rename if_else across mutate between
#' @importFrom tidyr drop_na
#' @importFrom ggplot2 ggplot aes geom_tile geom_text facet_wrap labs scale_fill_gradient scale_fill_gradientn scale_fill_gradient2
#' @importFrom paletteer scale_fill_paletteer_c
#' @importFrom colorspace diverge_hcl
#'
#' @param data A data frame containing regression results with variables to be plotted on x and y axes and estimate from regression and columns p, lb, ub for p-value, upper and lower bounds of CI
#' @param xvar Name of the variable that will be on x-axis, must be character or factor
#' @param yvar Name of variable that will be on y-axis, must be character or factor
#' @param estvar Name of variable with regression result estimate, default is "estimate"
#' @param facet_var A variable to facet the plot by (optional)
#' @param fill_lab Label for the fill aesthetic (default is "")
#' @param xlab Label for the x-axis (default is "")
#' @param ylab Label for the y-axis (default is "")
#' @param title Title of the plot (default is "")
#' @param sig Logical indicating whether to show significance (default is FALSE)
#' @param ci Logical indicating whether to show confidence intervals (default is FALSE)
#' @param show_only_sig Logical indicating whether to show only significant results (default is FALSE)
#' @param sig_threshold Threshold for significance (default is 0.05, must be between 0 and 1 if show_only_sig is TRUE)
#' @param text_col Color for the text labels (default is white)
#' @param fill_scheme One of "gradient", "gradient2", "gradientn", or palette for fill color scheme (default is "gradient2")
#' @param low_col Color for the low end of the gradient (default is "blue")
#' @param mid_col Color for the middle of the gradient (default is "white"), ONLY for 'gradient2' fill_scheme
#' @param high_col Color for the high end of the gradient (default is "red")
#' @param mid_value Midpoint value for the 'gradient2' fill scheme (default is 1)
#' @param color_vec A vector of colors for the 'gradientn' fill scheme
#' @param n_colors Number of colors for the 'gradientn' fill scheme
#' @param palette A palette name for the 'palette' fill scheme (default is NULL)
#' @param legend_pos Position of the legend (default is "bottom")
#' @return A heatmap
#' @export
#' @examples
#' # Load example walking bout data
#' data(reg_df)
#'
#' # Run the function
#' plot_ts_lasagna(sample_df, facet_var = "cat_cpb", layer_var = "cat_map")
#'
plot_heatmap = function(data,
                        xvar,
                        yvar,
                        estvar = "estimate",
                        fill_lab = "",
                        xlab = "",
                        ylab = "",
                        title = "",
                        facet_var = NULL,
                        sig = FALSE,
                        ci = FALSE,
                        show_only_sig = FALSE,
                        sig_threshold = 0.05,
                        text_col = "white",
                        fill_scheme = "gradient2",
                        low_col = "blue",
                        mid_col = "white",
                        high_col = "red",
                        mid_value = 1,
                        color_vec = NULL,
                        n_colors = NULL,
                        palette = NULL,
                        legend_pos = "bottom"){

  estimate = lb = ub = p = NULL # to avoid R CMD check notes about undefined global variables
  rm(list = c("estimate", "lb", "ub", "p"))
  assertthat::assert_that(fill_scheme %in% c("gradient", "gradient2", "gradientn", "palette"),
                          msg = "'fill_scheme' must be one of 'gradient', 'gradient2', 'gradientn', 'palette'")
  data = data %>%
    rename(xvar = {{xvar}},
           yvar = {{yvar}},
           estimate = {{estvar}})
  assertthat::assert_that(is.factor(data$xvar) | is.character(data$xvar),
                          msg = "'xvar' must be character or factor")

  assertthat::assert_that(is.factor(data$yvar) | is.character(data$yvar),
                          msg = "'yvar' must be character or factor")


  if(show_only_sig){
    assertthat::assert_that("p" %in% colnames(data),
                            msg = "'p' must be column in data")
    assertthat::assert_that(!is.null(sig_threshold) & is.numeric(sig_threshold) & dplyr::between(sig_threshold, 0, 1),
                            msg = "'sig_threshold' must be provided if 'show_only_sig' is TRUE and must be number between 0 and 1")
    data =
      data %>%
      dplyr::mutate(dplyr::across(c(estimate, lb, ub, p), ~dplyr::if_else(p < .05, .x, NA_real_)))
  }

  p = data %>%
    ggplot2::ggplot(ggplot2::aes(x = xvar, y = yvar, fill = estimate)) +
    ggplot2::geom_tile(color = "black") +
    ggplot2::theme_minimal() +
    ggplot2::labs(x = paste0(xlab),
                  y = paste0(ylab),
                  title = paste0(title))  +
    ggplot2::theme(legend.position = legend_pos)


  if(fill_scheme == "gradient"){
    p = p +
      ggplot2::scale_fill_gradient(low = low_col, high = high_col,
                          name = paste0(fill_lab))
  } else if (fill_scheme == "gradient2") {
    p = p +
      ggplot2::scale_fill_gradient2(low = low_col, mid = mid_col, high = high_col,
                           midpoint = mid_value,
                           name = paste0(fill_lab))
  } else if(fill_scheme == "gradientn"){
    assertthat::assert_that(!(is.null(n_colors)) | !is.null(color_vec),
                            msg = "must provide vector of colors OR number of colors for gradient n scale")
    if(!is.null(color_vec)){
      p = p +
        ggplot2::scale_fill_gradientn(colorspace::diverge_hcl(n_colors),
                                      name = paste0(fill_lab))
    } else {
      p = p +
        ggplot2::scale_fill_gradientn(colors = color_vec,
                                      name = paste0(fill_lab))
    }

  } else if (fill_scheme == "palette") {
    assertthat::assert_that(!is.null(palette),
                            msg = "must provide palette name for palette fill scheme")
    p = p +
      paletteer::scale_fill_paletteer_c(palette,
                                      name = paste0(fill_lab))
  }
  if(sig & !ci){
    assertthat::assert_that("p" %in% colnames(data),
                            msg = "'p' must be column in data")
    p = p +
      ggplot2::geom_text(data = data %>% tidyr::drop_na(),
                         ggplot2::aes(label = paste0("OR = ", sprintf("%.2g", signif(estimate, 2)), "\np = ", p)),
                col = text_col)

  }
  if(ci & !sig){
    assertthat::assert_that(all(c("ub", "lb") %in% colnames(data)),
                            msg = "'ub' and 'lb' must be columns in data")
    p = p +
      ggplot2::geom_text(data = data %>% tidyr::drop_na(),
                         ggplot2::aes(label = paste0("OR = ", sprintf("%.2g", signif(estimate, 2)), "\n(", lb, ",", ub, ")")),
                col = text_col)
  }
  if(ci & sig){
    assertthat::assert_that(all(c("ub", "lb") %in% colnames(data)),
                            msg = "'ub' and 'lb' must be columns in data")
    assertthat::assert_that("p" %in% colnames(data),
                            msg = "'p' must be column in data")
    p = p +
      ggplot2::geom_text(data = data %>% tidyr::drop_na(),
                         ggplot2::aes(label = paste0("OR = ", sprintf("%.2g", signif(estimate, 2)), "\n(", lb, ",", ub, ")",
                                   "\np = ", p)),
                col = text_col)
  }
  if(!sig & !ci){
    p = p +
      ggplot2::geom_text(data = data %>% tidyr::drop_na(),
                         ggplot2::aes(label = paste0("OR = ", sprintf("%.2g", signif(estimate, 2)))),
                col = text_col)
  }
  if (!is.null(facet_var)){
    assertthat::assert_that(facet_var %in% colnames(data),
                            msg = "'facet_var' must be in colnames of data")
    p = p + ggplot2::facet_wrap(~data[[facet_var]])
  }
  print(p)
}


