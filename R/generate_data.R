
generate_data <- function(params_rep) {
  params_rep |>
    group_split(condition_id) |>
    map(\(data) {
      n_pretest <- round(data$N * data$p_pretest)
      n_treatment <- round(data$N * data$p_treatment)

      data |>
        tidyr::nest(params = -condition_id) |>
        tidyr::uncount(data$N) |>
        dplyr::mutate(
          id = dplyr::row_number(),
          aux = purrr::map(id,
                           \(id) MASS::mvrnorm(1,
                                               mu = rep(0, data$K),
                                               # defining aux vars independent
                                               Sigma = data$K |> diag()) |>
                             tibble::as_tibble() |>
                             dplyr::mutate(var = paste0("aux", dplyr::row_number())) |>
                             tidyr::pivot_wider(names_from = var, values_from = value)),
          y1 = purrr::map_dbl(aux, \(aux) rnorm(1, rowSums(aux), data$sigma)),
          y1_z = y1 / sqrt((data$K + data$sigma^2)),
          pretest = c(rep(1, n_pretest), rep(0, data$N - n_pretest)) |>
            sample(size = data$N),
          treatment = c(rep(1, n_treatment), rep(0, data$N - n_treatment)) |>
            sample(size = data$N),
          y2s = purrr::pmap(list(y1_z, pretest, treatment),
                            \(y1_z, pretest, treatment) tibble::tibble(
                              condition = c("", "_between", "_pretest"),
                              pretest_indicator = c(pretest, 0, 1),
                              y2 = rnorm(3,
                                         mean =
                                           data$beta1 * treatment +
                                           data$beta2 * pretest_indicator +
                                           data$beta3 * y1_z +
                                           data$beta4 * treatment * pretest_indicator +
                                           data$beta5 * treatment * y1_z +
                                           data$beta6 * pretest_indicator * y1_z +
                                           data$beta7 * treatment * pretest_indicator * y1_z,
                                         sd = 1
                              )) |>
                              dplyr::select(-pretest_indicator) |>
                              tidyr::pivot_wider(names_from = condition,
                                                 values_from = y2, names_prefix = "y2"))) |>
        tidyr::unnest(y2s) |>
        tidyr::nest(data = -c(condition_id, params))
      
    }) |>
    list_rbind()
}

# tar_read(params) |>
#   generate_data() |>
#   fit_models()


# generate_data <- function(condition_params) {
#   
#   n_pretest <- round(condition_params$N * condition_params$p_pretest)
#   n_treatment <- round(condition_params$N * condition_params$p_treatment)
#   
#   condition_params |>
#     tidyr::nest(params = -rep) |>
#     tidyr::uncount(condition_params$N) |>
#     dplyr::mutate(id = row_number(),
#                   aux = map(id,
#                             \(id) MASS::mvrnorm(1,
#                                                 mu = rep(0, condition_params$K),
#                                                 # defining aux vars independent
#                                                 Sigma = condition_params$K |> diag()) |>
#                               tibble::as_tibble() |>
#                               dplyr::mutate(var = paste0("aux", row_number())) |>
#                               tidyr::pivot_wider(names_from = var, values_from = value)),
#                   y1 = purrr::map_dbl(aux, \(aux) rnorm(1, rowSums(aux), condition_params$sigma)),
#                   y1_z = y1 / sqrt((condition_params$K + condition_params$sigma^2)),
#                   pretest = c(rep(1, n_pretest), rep(0, condition_params$N - n_pretest)) |>
#                     sample(size = condition_params$N),
#                   treatment = c(rep(1, n_treatment), rep(0, condition_params$N - n_treatment)) |>
#                     sample(size = condition_params$N)) |>
#     dplyr::mutate(
#       y2s = purrr::pmap(list(y1_z, pretest, treatment),
#                         \(y1_z, pretest, treatment) tibble(
#                           condition = c("", "_between", "_pretest"),
#                           pretest_indicator = c(pretest, 0, 1),
#                           y2 = rnorm(3,
#                                      mean =
#                                        condition_params$beta1 * treatment +
#                                        condition_params$beta2 * pretest_indicator +
#                                        condition_params$beta3 * y1_z +
#                                        condition_params$beta4 * treatment * pretest_indicator +
#                                        condition_params$beta5 * treatment * y1_z +
#                                        condition_params$beta6 * pretest_indicator * y1_z +
#                                        condition_params$beta7 * treatment * pretest_indicator * y1_z,
#                                      sd = 1
#                           )) |>
#                           dplyr::select(-pretest_indicator) |>
#                           tidyr::pivot_wider(names_from = condition,
#                                              values_from = y2, names_prefix = "y2"))
#     ) |>
#     tidyr::unnest(y2s) |>
#     tidyr::nest(data = -c(rep, params))
# }



# init_params(2) |>
#   define_params() |>
#   head(1) |>
#   generate_data() 

# generate_data_old <- function(condition_params) {
#   #print(condition_params)
#   list2env(condition_params, envir = environment())
#   
#   n_pretest <- round(N * p_pretest)
#   n_treatment <- round(N * p_treatment)
# 
#   return(
# tibble(id = seq(1, N),
#        aux = map(id,
#          \(id) MASS::mvrnorm(1,
#                              mu = rep(0, K),
#                              # defining aux vars independent
#                              Sigma = K |> diag()) |>
#            as_tibble() |>
#            mutate(var = paste0("aux", row_number())) |>
#            pivot_wider(names_from = var, values_from = value)),
#        y1 = map_dbl(aux, \(aux) rnorm(1, rowSums(aux), sigma)),
#        y1_z = y1 / sqrt((K + sigma^2)),
#        pretest = c(rep(1, n_pretest), rep(0, N - n_pretest)) |>
#          sample(size = N),
#        treatment = c(rep(1, n_treatment), rep(0, N - n_treatment)) |>
#          sample(size = N)) |>
#   mutate(
#     y2s = pmap(list(y1_z, pretest, treatment),
#                \(y1_z, pretest, treatment) tibble(
#                  condition = c("", "_between", "_pretest"),
#                  pretest_indicator = c(pretest, 0, 1),
#                  y2 = rnorm(3,
#                             mean =
#                               beta1 * treatment +
#                               beta2 * pretest_indicator +
#                               beta3 * y1_z +
#                               beta4 * treatment * pretest_indicator +
#                               beta5 * treatment * y1_z +
#                               beta6 * pretest_indicator * y1_z +
#                               beta7 * treatment * pretest_indicator * y1_z,
#                             sd = 1
#                  )) |>
#                    select(-pretest_indicator) |>
#                    pivot_wider(names_from = condition,
#                                values_from = y2, names_prefix = "y2"))
#   ) |>
#   unnest(y2s)
#     ) 
# }







