
fiml_model <- function(data) {
  fiml_data <- data |> 
    unnest(aux) |>
    mutate(y1_z = ifelse(pretest == 1, y1_z, NA))
  
  nodes <- seq(min(fiml_data$y1_z, na.rm = T),
               max(fiml_data$y1_z, na.rm = T), 
               length.out = 30)
  
  ## factorized models
  model.s1 <- list("model" = "linreg", "formula" = aux1 ~ aux2 + aux3 + y2 + y1_z)
  model.s2 <- list("model" = "linreg", "formula" = aux2 ~ aux3 + y2 + y1_z)
  model.s3 <- list("model" = "linreg", "formula" = aux3 ~ y2 + y1_z)
  model.s4 <- list("model" = "linreg", "formula" = y2 ~ treatment * pretest * y1_z)
  model.s5 <- list("model" = "linreg", "formula" = y1_z ~ 1, 
                   nodes = nodes)
  
  ## separate "extra" models
  extra.mods <- list(model.s1 = model.s1,
                     model.s2 = model.s2,
                     model.s3 = model.s3,
                     model.s5 = model.s5)
  
  
  ## estimation
  mdmb::frm_em(dat = fiml_data |> as.data.frame(), 
               dep = model.s4, 
               ind = extra.mods)
  
}
# tar_read(sim_data) |>
#   pull(data) |>
#   pluck(1) |>
#   fiml_model()
# 
# data <- tar_read(params) |>
#   generate_data() |>
#   pluck("data", 1) |>
#   unnest(aux)
# 
# 
# 
# 
# ml_result |> 
#   pluck("partable") |> 
#   as_tibble() |>
#   filter(str_detect(parm, "^y2")) |>
#   mutate(parm = str_remove_all(parm, "y2 |ON ")) |>
#   select(term = parm, est)
