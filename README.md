
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
#> ✔ 1 pkg + 32 deps: kept 21 [9.2s]
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(bloodlines)
## basic example code
data(sample_df)
plot_lasagna(sample_df %>% dplyr::filter(cat_cpb != "intra"),
             facet_var = "cat_cpb",
             layer_var = "map_cat")
```

<img src="man/figures/README-example-1.png" width="100%" />

``` r

## we can use our own colors
sample_df_clean = 
  sample_df %>% 
  dplyr::filter(cat_cpb != "intra") %>% 
  dplyr::mutate(map_cat = forcats::fct_na_value_to_level(map_cat, level = "Missing"),
                map_cat = forcats::fct_rev(map_cat),
                cat_cpb = factor(cat_cpb,
                                 levels = c("pre", "post"),
                                 labels = c("Pre-CPB", "Post-CPB")),
                time = time / 60)
cols = c("[0,65)" = "#D82632FF",
               "[65,Inf)" = "#264DFFFF",
               "Missing" = "darkgrey")

plot_lasagna(data = sample_df_clean,
             facet_var = "cat_cpb",
             layer_var = "map_cat",
             xlab = "Time (hr)",
             ylab = "Proportion of Pts",
             title = "Lasagna Plot",
             xlims = c(0, 4),
             xbreaks = seq(0, 4, 1),
             col_vector = cols)
#> Warning: Removed 5 rows containing missing values or values outside the scale range
#> (`geom_bar()`).
```

<img src="man/figures/README-example-2.png" width="100%" />
