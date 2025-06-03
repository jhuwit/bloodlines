## code to prepare `sample_df` dataset goes here
sample_df = readr::read_rds(here::here("data-raw", "hemo_data_sim.rds"))
sample_df = sample_df %>%
  dplyr::mutate(cat_map = cut(val_MAP, breaks = c(0, 65, Inf), right = FALSE)) %>%
  dplyr::group_by(id, cat_cpb) %>%
  dplyr::mutate(timestamp = time,
         time = as.numeric(difftime(timestamp, min(timestamp), units = "mins"))) %>%
  dplyr::ungroup() %>%
  dplyr::select(id, time, timestamp, cat_cpb, val_map = val_MAP, val_cvp = val_CVP, cat_map)


usethis::use_data(sample_df, overwrite = TRUE)


