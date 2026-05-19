
tidy_models <- function(data) {
  data |>
    unnest(lms) |>
    pivot_longer(starts_with("lm"),
                 names_to = "method", values_to = "lm_result") |>
    mutate(
      tidy = map2(
        lm_result, params,
        \(lm_result, params) {
          key <- params |>
            pivot_longer(everything(),
                         names_to = "term", values_to = "true_value") |>
            mutate(true_values_term = replace_values(
              term,
              from = init_params_tidy_key() |> pull(param_label),
              to = init_params_tidy_key() |> pull(tidy_label))) |>
            bind_rows(tribble(~true_values_term, ~true_value,
                              "diff", 0,
                              "diff_squared", 0))
          
          broom::tidy(lm_result) |>
            bind_rows(tibble(sigma = sigma(lm_result),
                             cohens_d = pluck(lm_result, "coefficients", "treatment") / sigma,
                             diff = cohens_d - (params$beta1 / params$sigma),
                             diff_squared = diff^2) |>
                        pivot_longer(everything(), 
                                     names_to = "term", values_to = "estimate")) |>
            mutate(true_value = recode_values(term,
                                              from = key$true_values_term,
                                              to = key$true_value))}
      )) |>
    unnest(tidy) |>
    select(-c(lm_result, std.error, statistic, p.value)) |>
    nest(tidy = c(method, term, estimate, true_value))
}

# tar_read(sim_data) |>
#   tidy_models()
  # unnest(lms) |>
  # pivot_longer(starts_with("lm"),
  #              names_to = "type", values_to = "lm_result") |>
  # mutate(
  #   tidy = map2(
  #     lm_result, params,
  #     \(lm_result, params) {
  #       key <- params |>
  #         pivot_longer(everything(),
  #                      names_to = "term", values_to = "true_value") |>
  #         mutate(true_values_term = replace_values(
  #           term,
  #           from = init_params_tidy_key() |> pull(param_label),
  #           to = init_params_tidy_key() |> pull(tidy_label))) |>
  #         bind_rows(tribble(~true_values_term, ~true_value,
  #                           "diff", 0,
  #                           "diff_squared", 0))
  #       
  #       broom::tidy(lm_result, conf.int = T) |>
  #       bind_rows(tibble(sigma = sigma(lm_result),
  #                        cohens_d = pluck(lm_result, "coefficients", "treatment") / sigma(lm_result),
  #                        diff = cohens_d - (params$beta1 / sigma),
  #                        diff_squared = diff^2) |>
  #                   pivot_longer(everything(), 
  #                                names_to = "term", values_to = "estimate")) |>
  #       mutate(true_value = recode_values(term,
  #                                         from = key$true_values_term,
  #                                         to = key$true_value))}
  #   )) |>
  # pull(tidy)
  # 
  # 
  #   
  #   
  #   true_values = map(params,
  #                     \(params) params |>
  #                       select(starts_with("beta"), cohens_d, sigma) |>
  #                       pivot_longer(everything(),
  #                                    names_to = "true_values_term",
  #                                    values_to = "true_value") |>
  #                       mutate(true_values_term = recode_values(
  #                         true_values_term,
  #                         from = init_params_tidy_key() |> pull(param_label),
  #                         to = init_params_tidy_key() |> pull(tidy_label))))
  # ) |>
  # unnest(tidy) |>
  # unnest(true_values) |>
  # filter(term == true_values_term) |>
  # select(-true_values_term) |>
  # mutate(
  #   tidy = map(tidy, \(tidy) tid)
  # )

  