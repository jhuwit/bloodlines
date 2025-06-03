
<!-- README.md is generated from README.Rmd. Please edit that file -->

# bloodlines

<!-- badges: start -->
<!-- badges: end -->

The goal of bloodlines is to generate nice plots for hemodynamics data.

## Installation

You can install the development version of bloodlines from
[GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("jhuwit/bloodlines")
#> ℹ Loading metadata database✔ Loading metadata database ... done
#>  
#> ℹ No downloads are needed
#> ✔ 1 pkg + 40 deps: kept 27 [9.3s]
```

## Lasagna plots

``` r
library(bloodlines)
## basic example code
data(sample_df)
plot_lasagna(sample_df %>% dplyr::filter(cat_cpb != "intra"),
             facet_var = "cat_cpb",
             layer_var = "cat_map")
```

<img src="man/figures/README-lasgana-1.png" width="100%" />

``` r

## we can use our own colors
sample_df_clean = 
  sample_df %>% 
  dplyr::filter(cat_cpb != "intra") %>% 
  dplyr::mutate(cat_map = forcats::fct_na_value_to_level(cat_map, level = "Missing"),
                cat_map = forcats::fct_rev(cat_map),
                cat_cpb = factor(cat_cpb,
                                 levels = c("pre", "post"),
                                 labels = c("Pre-CPB", "Post-CPB")),
                time = time / 60) %>% 
  print()
#> # A tibble: 36,329 × 7
#>    id      time timestamp           cat_cpb val_map val_cvp cat_map 
#>    <chr>  <dbl> <dttm>              <fct>     <dbl>   <dbl> <fct>   
#>  1 1     0      2019-01-01 00:18:20 Pre-CPB    97.6  18.4   [65,Inf)
#>  2 1     0.0167 2019-01-01 00:19:20 Pre-CPB    73.6  13.6   [65,Inf)
#>  3 1     0.0333 2019-01-01 00:20:20 Pre-CPB    NA    12.8   Missing 
#>  4 1     0.05   2019-01-01 00:21:20 Pre-CPB    66.1  11.5   [65,Inf)
#>  5 1     0.0667 2019-01-01 00:22:20 Pre-CPB    61.6   3.55  [0,65)  
#>  6 1     0.0833 2019-01-01 00:23:20 Pre-CPB    99.7   4.31  [65,Inf)
#>  7 1     0.1    2019-01-01 00:24:20 Pre-CPB    87.8   9.37  [65,Inf)
#>  8 1     0.117  2019-01-01 00:25:20 Pre-CPB    91.0   0.968 [65,Inf)
#>  9 1     0.133  2019-01-01 00:26:20 Pre-CPB    99.0   1.86  [65,Inf)
#> 10 1     0.15   2019-01-01 00:27:20 Pre-CPB   113.   13.0   [65,Inf)
#> # ℹ 36,319 more rows

# paletteer::paletteer_d("colorBlindness::Blue2DarkRed12Steps")
cols = c(
  "[0,65)" = "#D82632FF",
  "[65,Inf)" = "#264DFFFF",
  "Missing" = "darkgrey"
)

plot_lasagna(data = sample_df_clean,
             facet_var = "cat_cpb",
             layer_var = "cat_map",
             xlab = "Time (hr)",
             ylab = "Proportion of Pts",
             title = "Lasagna Plot",
             xlims = c(0, 4),
             xbreaks = seq(0, 4, 1),
             col_vec = cols) %>% 
  print()
#> Warning: Removed 5 rows containing missing values or values outside the scale range
#> (`geom_bar()`).
```

<img src="man/figures/README-lasgana-2.png" width="100%" />

## Lasagna plots (time series version)

``` r
sample_df_clean2 = 
  sample_df_clean %>% 
  dplyr::group_by(id) %>% 
  dplyr::mutate(n = dplyr::n()) %>% 
  dplyr::ungroup() %>% 
  dplyr::mutate(id = forcats::fct_reorder(id, n))
plot_ts_lasagna(sample_df %>% dplyr::filter(cat_cpb != "intra"),
             facet_var = "cat_cpb",
             layer_var = "cat_map") %>% 
  print()
```

<img src="man/figures/README-time_series_lasagna-1.png" width="100%" />

``` r


plot_ts_lasagna(data = sample_df_clean2,
             facet_var = "cat_cpb",
             layer_var = "cat_map",
             xlab = "Time (hr)",
             ylab = "Patient",
             title = "Time series lasagna Plot",
             xlims = c(0, 4),
             xbreaks = seq(0, 4, 1),
             col_vec = cols) %>% 
  print()
#> Warning: Removed 200 rows containing missing values or values outside the scale range
#> (`geom_tile()`).
```

<img src="man/figures/README-time_series_lasagna-2.png" width="100%" />
\## Heatmap from regression results

``` r
data(reg_df)

plot_heatmap(data = reg_df,
             fill_lab = "Odds Ratio",
             xlab = "Hemodynamic Range",
             ylab = "Hemodynamic Range",
             title = "Regression Results",
             sig = TRUE,
             text_col = "black",
             fill_scheme = "gradient2") %>% 
  print()
```

<img src="man/figures/README-heatmap-1.png" width="100%" />

``` r

## example using custom palette and only showing significance 
plot_heatmap(data = reg_df,
             fill_lab = "Odds Ratio",
             xlab = "Hemodynamic Range",
             ylab = "Hemodynamic Range",
             title = "Regression Results",
             sig = TRUE,
             text_col = "black",
             fill_scheme = "palette",
             palette = "viridis::plasma",
             show_only_sig = TRUE) %>% 
  print()
```

<img src="man/figures/README-heatmap-2.png" width="100%" />

``` r

## example using number of colors 
plot_heatmap(data = reg_df,
             fill_lab = "Odds Ratio",
             xlab = "Hemodynamic Range",
             ylab = "Hemodynamic Range",
             title = "Regression Results",
             sig = TRUE,
             text_col = "black",
             fill_scheme = "gradientn",
             n_colors = 5) %>% 
  print()
```

<img src="man/figures/README-heatmap-3.png" width="100%" />

## J plot from regression results

``` r
data(mult_reg_df)


p = plot_j(mult_reg_df, col_vec = c("A" = "#1E8E99", "B" = "#FF8E32"))
p + ggplot2::theme(axis.text.x =  ggplot2::element_text(angle = 90))
```

<img src="man/figures/README-j_plot-1.png" width="100%" />

``` r

## example with facets 

facet_data =
  mult_reg_df %>%
  dplyr::mutate(v1 = "Pre-CPB") %>%
  dplyr::bind_rows(mult_reg_df %>% dplyr::mutate(v1 = "Post-CPB")) %>% 
  dplyr::mutate(v1 = forcats::fct_rev(v1))

p = plot_j(
  facet_data,
  col_vec = c("A" = "#1E8E99", "B" = "#FF8E32"),
  facet_var = "v1",
  x_label = "MAP Range",
  y_label = "Odds Ratio"
)
p + ggplot2::theme(axis.text.x =  ggplot2::element_text(angle = 90))
```

<img src="man/figures/README-j_plot-2.png" width="100%" />
