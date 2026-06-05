
tidy_lm <- function(lm_result, params) {
  lm_result |>
    broom::tidy() |>
    select(term, estimate) |>
    bind_rows(tibble(sigma = sigma(lm_result),
                     cohens_d = pluck(lm_result, "coefficients", "treatment") / sigma,
                     diff = cohens_d - (params$beta1 / params$sigma),
                     diff_squared = diff^2) |>
                pivot_longer(everything(),
                             names_to = "term", values_to = "estimate"))
}  

# tar_read(params) |>
#   generate_data() |>
#   fit_models() |>
#   unnest(models) |>
#   filter(method == "lm_between") |>
#   pluck("result", 1) |>
#   tidy_lm()
