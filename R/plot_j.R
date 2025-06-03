#' Create a 'j-plot' from regression results from multiple models
#'
#' @importFrom ggplot2 ggplot aes geom_point geom_errorbar theme_bw labs scale_shape_discrete scale_color_discrete scale_color_manual scale_shape_manual theme geom_hline guides element_text position_dodge margin guide_legend
#'
#' @param data A data frame containing regression results, must include columns 'variable', 'estimate', 'ub', 'lb', 'model'
#' @param facet_var A variable to facet the plot by (optional)
#' @param col_vec A vector of colors for the models, may be named (optional)
#' @param shape_vec A vector of shapes for the models, may be named (optional)
#' @param dodge Amount to dodge the points and error bars (default is 0.6)
#' @param point_size Size of the points (default is 2)
#' @param bar_width Width of the error bars (default is 0.5)
#' @param line_width Width of the error bar lines (default is 0.5)
#' @param ybreaks Breaks for the y-axis (optional)
#' @param x_label Label for the x-axis (default is "")
#' @param y_label Label for the y-axis (default is "")
#' @param title Title of the plot (default is "")
#' @param ylims Limits for the y-axis (optional, if NULL will be set to min and max of 'lb' and 'ub')
#' @param legend_pos position of legend, default is "bottom"
#' @return A 'j-plot'
#' @export
#' @examples
#' # Load example walking bout data
#' data(mult_reg_df)
#'
#' # Run the function
#' plot_j(mult_reg_df, col_vec = c("A"= "#1E8E99", "B" = "#FF8E32"))
#'
plot_j = function(data,
                  facet_var = NULL,
                  col_vec = NULL,
                  shape_vec = NULL,
                  dodge = 0.6,
                  point_size = 2,
                  bar_width = 0.5,
                  line_width = 0.5,
                  ybreaks = NULL,
                  x_label = "",
                  y_label = "",
                  title = "",
                  ylims = NULL,
                  legend_pos = "bottom") {
  variable = estimate = ub = lb = model = NULL # to avoid R CMD check notes about undefined global variables
  rm(list = c("estimate", "variable", "ub", "lb", "model"))


  req_names = c("model", "variable", "ub", "lb", "estimate")
  assertthat::assert_that(all(req_names %in% colnames(data)),
                          msg = "Data must contain columns 'model', 'variable', 'ub', 'lb', and 'estimate'")

  assertthat::assert_that(is.factor(data$variable) | is.character(data$variable),
                          msg = "'variable' column in data must be a factor or character")
  if (!is.null(col_vec)) {
    assertthat::assert_that(length(col_vec) == length(unique(data$model)),
                            msg = "Color vector must be same length as # unique models")
  }

  if (!is.null(shape_vec)) {
    assertthat::assert_that(length(shape_vec) == length(unique(data$model)),
                            msg = "Shape vector must be same length as # unique models")
  }

  if (is.null(ylims)) {
    ylims = c(min(data$lb, na.rm = TRUE), max(data$ub, na.rm = TRUE))
  }
  p = data %>%
    ggplot2::ggplot(ggplot2::aes(x = variable, y = estimate)) +
    ggplot2::geom_point(
      ggplot2::aes(
        x = variable,
        y = estimate,
        col = model,
        shape = model
      ),
      position = ggplot2::position_dodge(dodge),
      size = point_size
    ) +
    ggplot2::geom_errorbar(
      width = bar_width,
      linewidth = line_width,
      ggplot2::aes(
        x = variable,
        y = estimate,
        ymin = lb,
        ymax = ub,
        col = model
      ),
      position = ggplot2::position_dodge(dodge)
    ) +
    ggplot2::theme_bw() +
    ggplot2::labs(
      x = paste(x_label),
      y = paste(y_label),
      title = paste(title)
    ) +
    ggplot2::geom_hline(ggplot2::aes(yintercept = 1), col = "black") +
    ggplot2::theme(
      legend.position = legend_pos,
      axis.text.x = ggplot2::element_text(size = 12),
      axis.text.y = ggplot2::element_text(size = 14),
      legend.text = ggplot2::element_text(size = 14),
      legend.title = ggplot2::element_text(size = 16),
      axis.title.y = ggplot2::element_text(margin = ggplot2::margin(r = 3), size = 14),
      axis.title.x = ggplot2::element_text(margin = ggplot2::margin(t = 10), size = 14)
    ) +
    ggplot2::guides(color = ggplot2::guide_legend(nrow = 1))

  if (is.null(col_vec) & is.null(shape_vec)) {
    p = p +
      ggplot2::scale_shape_discrete(name = "95% CI") +
      ggplot2::scale_color_discrete(name = "95% CI")
  } else if (!is.null(col_vec) & !is.null(shape_vec)) {
    p = p +
      ggplot2::scale_shape_manual(name = "95% CI", values = shape_vec) +
      ggplot2::scale_color_manual(name = "95% CI", values = col_vec)
  } else if (is.null(col_vec) & !is.null(shape_vec)) {
    p = p +
      ggplot2::scale_color_discrete(name = "95% CI") +
      ggplot2::scale_shape_manual(name = "95% CI", values = shape_vec)
  } else if (!is.null(col_vec) & is.null(shape_vec))  {
    p = p +
      ggplot2::scale_color_manual(name = "95% CI", values = col_vec) +
      ggplot2::scale_shape_discrete(name = "95% CI")
  }
  if (is.null(ybreaks)) {
    p = p + ggplot2::scale_y_continuous(limits = ylims)
  } else {
    p = p + ggplot2::scale_y_continuous(limits = ylims, breaks = ybreaks)
  }

  if (!is.null(facet_var)){
    assertthat::assert_that(facet_var %in% colnames(data),
                            msg = "'facet_var' must be in colnames of data")
    p = p + ggplot2::facet_wrap(~data[[facet_var]])
  }

  print(p)
}
