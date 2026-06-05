
fit_models <- function(data, compiled_brms_models) {
  data |>
    left_join(compiled_brms_models |>
                select(condition_id, compiled_brms_model),
              by = "condition_id") |>
    mutate(
      models = map2(data, compiled_brms_model,
                    \(data, compiled_brms_model) tribble(
                      ~method, ~result,
                      "lm_between", lm(y2_between ~ treatment, data = data),
                      "lm_pretest", lm(y2_pretest ~ treatment * y1_z, data = data),
                      "lm_true", lm(y2 ~ treatment * pretest * y1_z, data = data),
                      "fiml", fiml_model(data),
                      "mi", mi_model(data),
                      "brms", brms_model(data, compiled_brms_model)
                    ))
    ) |>
    select(-compiled_brms_model)
  
}


# d <- tar_read(gen_data) |>
#   head(6) |>
#   fit_models(tar_read(compiled_brms_models))
# 
# d2 <- tar_read(gen_data) |>
#   head(6) |>
#   left_join(tar_read(compiled_brms_models) |>
#               select(condition_id, compiled_brms_model),
#             by = "condition_id") |>
#   mutate(
#     models = map2(data, compiled_brms_model,
#                   \(data, compiled_brms_model) tribble(
#                     ~method, ~result,
#                     "lm_between", lm(y2_between ~ treatment, data = data),
#                     "lm_pretest", lm(y2_pretest ~ treatment * y1_z, data = data),
#                     "lm_true", lm(y2 ~ treatment * pretest * y1_z, data = data),
#                     "fiml", fiml_model(data),
#                     "mi", mi_model(data),
#                     "brms", brms_model(data, compiled_brms_model)
#                   ))
#   )

# d2 <- tar_read(gen_data) |>
#   left_join(tar_read(compiled_brms_models) |>
#               select(condition_id, compiled_brms_model),
#             by = "condition_id") 
# 
# d <- tar_read(gen_data) |>
#   fit_models()
# 
# d3 <- d |>
#   mutate(models = map2(data, compiled_brms_model,
#                        \(data, compiled_brms_models) tibble(
#                          lm_between = list(lm(y2_between ~ treatment, data = data)),
#                          lm_pretest = list(lm(y2_pretest ~ treatment * y1_z, data = data)),
#                          lm_true = list(lm(y2 ~ treatment * pretest * y1_z, data = data)),
#                          fiml = list(fiml_model(data)),
#                          mi = list(mi_model(data)),
#                          brms = compiled_brms_model
#                        )))
#   
# d3 |>
#   head(1) |>
#   pluck("models")
# 
# d4 <- d |>
#   head(10) |>
#   mutate(
#     
#   )
# 
# d4 |>
#   head(1) |>
#   pluck("models")
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
