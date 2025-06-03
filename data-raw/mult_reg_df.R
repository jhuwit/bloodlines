x1 = seq(45,105,5)
x2 = seq(50,110,5)

cat_map = paste("[",x1, ",",x2, ")", sep ="")



mult_reg_df =
  dplyr::tibble(variable = factor(rep(cat_map, 2), levels = cat_map),
         estimate = rnorm(26, 1, 2),
         width = runif(26, 0, 2),
         ub = estimate + width / 2,
         lb = estimate - width / 2,
         model = c(rep("A", 13), rep("B", 13)))

usethis::use_data(mult_reg_df, overwrite = TRUE)


