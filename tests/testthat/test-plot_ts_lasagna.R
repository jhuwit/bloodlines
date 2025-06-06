testthat::test_that("create ts lastagna", {

  # Load example data
  data(sample_df)

  # Test with default parameters
  p <- plot_ts_lasagna(sample_df, facet_var = "cat_cpb", layer_var = "cat_map")

  # Check if the plot is a ggplot object
  expect_true(inherits(p, "gg"))

  # Check if the plot has the correct layers
  # expect_true("geom_bar" %in% sapply(p$layers, function(x) x$geom$name))

})
