tidy_frm_em <- function(frm_em_result, params) {
  frm_em_result <- frm_em_result |>
    pluck("partable") |>
    as_tibble() |>
    filter(str_detect(parm, "^y2")) |>
    mutate(parm = str_remove_all(parm, "y2 |ON ")) |>
    select(term = parm, estimate = est)
  
  frm_em_result |>
    bind_rows(
      tibble(cohens_d = (frm_em_result |>
                           filter(term == "treatment") |>
                           pull(estimate)) / (frm_em_result |>
                                                filter(term == "sigma") |>
                                                pull(estimate))) |>
        mutate(diff = cohens_d - (params$beta1 / params$sigma),
               diff_squared = diff^2) |>
        pivot_longer(everything(),
                     names_to = "term", values_to = "estimate")
    )
}

# 
# tar_read(params) |>
#   generate_data() |>
#   fit_models() |>
#   pluck("models", 1) |>
#   filter(method == "fiml") |>
#   pluck("result", 1) |>
#   tidy_frm_em(tar_read(params) |> head(1))


