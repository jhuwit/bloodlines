testthat::test_that("create heatmap", {

  # Load example data
  data(reg_df)

  # Test with default parameters
  p <- plot_heatmap(data = reg_df,
                    xvar = "x",
                    yvar = "y")

  # Check if the plot is a ggplot object
  expect_true(inherits(p, "gg"))

  # Check if the plot has the correct layers
  # expect_true("geom_bar" %in% sapply(p$layers, function(x) x$geom$name))

})
