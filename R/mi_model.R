
mi_model <- function(data, n_imps = 100) {
  mi_data <- data |>
    unnest(aux) |>
    mutate(y1_z = ifelse(pretest == 1, y1_z, NA))
  
  mimps <- mice::mice(mi_data |> select(y1_z, starts_with("aux")), 
                      m = n_imps, printFlag = FALSE) 
  
  mimps |>
    complete(action = "long") |>
    as_tibble() |>
    mutate(y2 = rep(mi_data$y2, n_imps),
           treatment = rep(mi_data$treatment, n_imps),
           pretest = rep(mi_data$pretest, n_imps)) |>
    group_split(by = .imp) |>
    map(\(data) lm(y2 ~ treatment * pretest * y1_z, data)) |>
    mitml::testEstimates(extra.pars = T)
  
}

# 
# mitml_result |>
#   pluck("estimates") |>
#   as_tibble() |>
#   mutate(term = mitml_result |> pluck("estimates") |> attr("dimnames") |> pluck(1),
#          .before = everything()) |>
#   select(term, estimate = Estimate)
