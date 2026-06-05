
tidy_brms <- function(brms_model, params) {
  brms_tidy <- brms_model |>
    tidybayes::tidy_draws() |>
    posterior::summarize_draws() |>
    select(variable, estimate = mean) |>
    filter(str_detect(variable, "y2_|sigma_y1z")) |>
    mutate(term = str_remove_all(variable, "b_|y2_|bsp_|mi|_y1z") |>
             replace_values("Intercept" ~ "(Intercept)")) |>
    mutate(term = map_chr(term, \(term) if (str_detect(term, "y1_z:")) term |>
                            str_remove("y1_z:") |>
                            paste0(":y1_z") else term),
           .keep = "unused",
           .before = everything()) 
  
  brms_tidy |>
    bind_rows(
      tibble(cohens_d = (brms_tidy |>
                           filter(term == "treatment") |>
                           pull(estimate)) / (brms_tidy |>
                                                filter(term == "sigma") |>
                                                pull(estimate))) |>
        mutate(diff = cohens_d - (params$beta1 / params$sigma),
               diff_squared = diff^2) |>
        pivot_longer(everything(),
                     names_to = "term", values_to = "estimate")
    ) |>
    as_tibble()
}

# tar_read(compiled_brms_models) |> pluck("compiled_brms_model", 1)  |>
#    tidybayes::tidy_draws() |>
#    posterior::summarize_draws() |>
#    select(variable, estimate = mean) |> 
#   filter(str_detect(variable, "y2_|sigma_y1z"))  |>
#   mutate(term = str_remove_all(variable, "b_|y2_|bsp_|mi|_y1z") |>
#            replace_values("Intercept" ~ "(Intercept)")) |>
#   mutate(term = map_chr(term, \(term) if (str_detect(term, "y1_z:")) term |>
#                           str_remove("y1_z:") |>
#                           paste0(":y1_z") else term),
#          .keep = "unused",
#          .before = everything()) |>
#   pull(term) 

# d <- tar_read(gen_data) |>
#   head(6) |>
#   fit_models(tar_read(compiled_brms_models))

