testthat::test_that("create j-plot", {

  # Load example data
  data(mult_reg_df)

  # Test with default parameters
  p <- plot_j(data = mult_reg_df)

  # Check if the plot is a ggplot object
  expect_true(inherits(p, "gg"))

  # Check if the plot has the correct layers
  # expect_true("geom_bar" %in% sapply(p$layers, function(x) x$geom$name))

})
