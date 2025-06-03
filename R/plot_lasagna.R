#' Create a lasagna plot from hemodynamics time series
#'
#'
#' @importFrom dplyr rename pull
#' @importFrom ggplot2 ggplot aes geom_bar facet_wrap labs scale_color_discrete scale_fill_discrete scale_color_manual scale_fill_manual scale_x_continuous scale_y_continuous theme

#'
#' @param data A data frame containing hemodynamic time series with columns 'time', 'id', and a variable that is lasagna layers
#' @param facet_var A variable to facet the plot by (optional)
#' @param layer_var A variable to create lasagna layers from
#' @param xlab Label for the x-axis (default is "")
#' @param ylab Label for the y-axis (default is "")
#' @param title Title of the plot (default is "")
#' @param proportion Logical indicating whether to plot proportions (default is TRUE)
#' @param xlims Limits for the x-axis (default is NULL)
#' @param xbreaks Breaks for the x-axis (default is NULL)
#' @param col_vector A named vector of colors for the layers (default is NULL, which uses default ggplot colors)
#' @param legend_pos Position of the legend (default is "bottom")
#' @return A lasagna plot
#' @export
#' @examples
#' # Load example walking bout data
#' data(sample_df)
#'
#' # Run the function
#' plot_lasagna(sample_df, facet_var = "cat_cpb", layer_var = "cat_map")
#'

plot_lasagna = function(data,
                        facet_var = NULL,
                        layer_var = NULL,
                        xlab = "",
                        ylab = "",
                        title = "",
                        proportion = TRUE,
                        xlims = NULL,
                        xbreaks = NULL,
                        col_vector = NULL,
                        legend_pos = "bottom") {
  assertthat::assert_that(
    is.data.frame(data),
    msg = "Data must be a data frame."
  )
  time = NULL
  rm(list = c("time"))
  assertthat::assert_that(layer_var %in% colnames(data),
                          msg = "'layer_var' must be in colnames of data")
  assertthat::assert_that(all(c("time", "id") %in% colnames(data)),
                          msg = "columns 'id' and 'time' must be in data")
  assertthat::assert_that(is.numeric(data$time),
                          msg = "'time' column must be numeric")


  if (is.null(col_vector)) {
    p = data %>%
      dplyr::rename(layer_var = {{layer_var}},
             facet_var = {{facet_var}}) %>%
      ggplot2::ggplot(ggplot2::aes(
        x = time,
        fill = layer_var,
        color = layer_var
      )) +
      ggplot2::geom_bar() +
      ggplot2::theme_classic() +
      ggplot2::theme(legend.position = legend_pos) +
      ggplot2::scale_color_discrete(name = "",
                           na.translate = TRUE) +
      ggplot2::scale_fill_discrete(name = "",
                          na.translate = TRUE) +
      ggplot2::labs(x = paste0(xlab),
           y = paste0(ylab),
           title = paste0(title))
  } else {
    assertthat::assert_that(all(!is.null(names(col_vector)) &
                                  names(col_vector) != ""),
                            msg = "Color vector must be named")
    layer_var_names = unique(data %>% dplyr::pull({{layer_var}}))
    col_vec_names = names(col_vector)

    assertthat::assert_that(setequal(layer_var_names, col_vec_names),
                            msg = "Names of color vector must be same as levels of layer_var")

    p = data %>%
      dplyr::rename(layer_var = {{layer_var}},
             facet_var = {{facet_var}}) %>%
      ggplot2::ggplot(aes(
        x = time,
        fill = layer_var,
        color = layer_var
      )) +
      ggplot2::geom_bar() +
      ggplot2::theme_classic() +
      ggplot2::theme(legend.position = legend_pos) +
      ggplot2::scale_color_manual(name = "",
                         values = col_vector,
                         na.translate = TRUE) +
      ggplot2::scale_fill_manual(name = "",
                        values = col_vector,
                        na.translate = TRUE) +
      ggplot2::labs(x = paste0(xlab),
           y = paste0(ylab),
           title = paste0(title))
  }
  if (!is.null(facet_var)) {
    p = p +
      ggplot2::facet_wrap( ~ facet_var, scales = "free_x")
  }
  if (proportion) {
    n_sub = length(unique(data$id))
    p = p +
      ggplot2::scale_y_continuous(breaks = seq(0, n_sub, n_sub / 10),
                         labels = seq(0, 1, .1))
  }
  if (!is.null(xlims) & !is.null(xbreaks)) {
    p = p +
      ggplot2::scale_x_continuous(limits = xlims, breaks = xbreaks)
  } else if (!is.null(xlims)) {
    p = p +
      ggplot2::scale_x_continuous(limits = xlims)
  } else if (!is.null(xbreaks)) {
    p = p + ggplot2::scale_x_continuous(breaks = xbreaks)
  }

  print(p)
}


# plot_lasagna(hemo_data, layer_var = "cat_map", facet_var = "cat_cpb",proportion = FALSE,
#              col_vector = c("[0,65)" = "red", "[65,Inf)" = "blue", "Missing" = "black"),
#              xlims = c(0, 10000), xbreaks = seq(0, 10000, 5000))
