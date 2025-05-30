## code to prepare `sample_df` dataset goes here
sample_df = readr::read_rds(here::here("data-raw", "hemo_data_sim.rds"))
sample_df = sample_df %>%
  dplyr::mutate(map_cat = cut(val_MAP, breaks = c(0, 65, Inf), right = FALSE)) %>%
  dplyr::group_by(id, cat_cpb) %>%
  dplyr::mutate(timestamp = time,
         time = as.numeric(difftime(timestamp, min(timestamp), units = "mins"))) %>%
  dplyr::ungroup()


usethis::use_data(sample_df, overwrite = TRUE)


