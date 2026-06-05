
tidy_mitml <- function(mitml_result, params) {
  mitml_result |>
    pluck("estimates") |>
    as_tibble() |>
    mutate(term = mitml_result |> pluck("estimates") |> attr("dimnames") |> pluck(1),
           .before = everything()) |>
    select(term, estimate = Estimate) |>
  bind_rows(tibble(sigma = mitml_result |> pluck("extra.pars", 1),
                   cohens_d = mitml_result$estimates["treatment", "Estimate"] / sigma,
                   diff = cohens_d - (params$beta1 / params$sigma),
                   diff_squared = diff^2) |>
              pivot_longer(everything(),
                           names_to = "term", values_to = "estimate"))

}