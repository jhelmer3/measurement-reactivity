
fit_models <- function(data) {
    data |>
      mutate(models = map(data, 
                       \(data) tibble(
                         lm_between = list(lm(y2_between ~ treatment, data = data)),
                         lm_pretest = list(lm(y2_pretest ~ treatment * y1_z, data = data)),
                         lm_true = list(lm(y2 ~ treatment * pretest * y1_z, data = data)),
                         fiml = list(fiml_model(data))
                       ) |> 
                         pivot_longer(everything(),
                                      names_to = "method", values_to = "result")))
  
}
# 
# tar_read(params) |>
#   generate_data() |>
#   fit_models() |>
#   unnest(lms)


# 
# tar_read(params) |>
#   head(1) |>
#   mutate(N = 10000) |>
#   generate_data() |>
#   fit_models() |>
#   map(\(mod) mod |> pluck(1) |> broom::tidy())
