
compile_brms_model <- function(gen_data) {
  # gets the very first simulated dataset
  data <- gen_data |>
    slice(1, .by = condition_id) |>
    mutate(
      compiled_brms_model = map2(
        data, condition_id,
        \(data, condition_id) {
          data <- data |>
            unnest(aux) |>
            mutate(y1_z = ifelse(pretest == 1, y1_z, NA))
          
          brms_frm <- bf(aux1 ~ aux2 + aux3 + y2 + mi(y1_z)) +
            bf(aux2 ~ aux3 + y2 + mi(y1_z)) +
            bf(aux3 ~ y2 + mi(y1_z)) +
            bf(y2 ~  treatment * pretest * mi(y1_z)) +
            bf(y1_z | mi() ~ 1) +
            set_rescor(FALSE)
          
          # priors will be default generated for just that first
          # data set. overall to save compile time. consider different
          brm(brms_frm, data,
              save_model = here::here(
                "models",
                glue::glue("brms_model_condition-{condition_id}.stan")
              ),
              chains = 1,
              iter = 1,
              silent = 2)
        }
      )
    )
}

# tar_read(gen_data) |>
#   compile_brms_model()
