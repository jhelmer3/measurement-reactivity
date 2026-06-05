init_method_levels <- function() {
  tibble(method = c("lm_true", "lm_between", "lm_pretest", "fiml", "mi") |>
           factor(levels = c("lm_true", "lm_between", "lm_pretest", "fiml", "mi")),
         label = c("true", "between", "pretest", "fiml", "mi"),
         color = c("#E3C8D2", "#C7D8EB", "#A7BE9D", "#d29979", "#b39eb5"))
}
