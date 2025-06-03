# code to create sample regression result data frame

reg_df = tidyr::expand_grid(x = 1:5,
                   y = 1:5) %>%
  dplyr::mutate(
    estimate = rnorm(25, 1, 2),
    width = runif(25, 0, 2),
    ub = estimate + (width / 2),
    lb = estimate - (width / 2)
  ) %>%
  dplyr::mutate(across(c(x,y), as.factor)) %>%
  dplyr::mutate(p = round(rnorm(25, 0.05, .01), 2))

usethis::use_data(reg_df, overwrite = TRUE)
