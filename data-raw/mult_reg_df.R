mult_reg_df =
  dplyr::tibble(variable = rep(factor(seq(1:10)), 2),
         estimate = rnorm(20, 1, 2),
         width = runif(20, 0, 2),
         ub = estimate + width / 2,
         lb = estimate - width / 2,
         model = c(rep("A", 10), rep("B", 10)))

usethis::use_data(mult_reg_df, overwrite = TRUE)
