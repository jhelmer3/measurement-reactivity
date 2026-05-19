init_method_levels <- function() {
  tibble(method = c("lm_true", "lm_between", "lm_pretest") |>
           factor(levels = c("lm_true", "lm_between", "lm_pretest")),
         label = c("true", "between", "pretest"),
         color = c("#E3C8D2", "#C7D8EB", "#A7BE9D"))
}
