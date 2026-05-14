
fit_models <- function(data) {
  return(
    data |>
      mutate(lms = map(data, 
                       \(data) tibble(
                         lm_between = list(lm(y2_between ~ treatment, data = data)),
                         lm_pretest = list(lm(y2_pretest ~ y1_z * treatment, data = data)),
                         lm_true = list(lm(y2 ~  y1_z * treatment * pretest, data = data))
                       )))
    
  )
}
# 
# tar_read(params) |>
#   head(1) |>
#   mutate(N = 10000) |>
#   generate_data() |>
#   fit_models() |>
#   map(\(mod) mod |> pluck(1) |> broom::tidy())
