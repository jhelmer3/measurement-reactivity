
library(tidyverse)

t1 <- Sys.time()
mtcars |>
  map(\(var) mean(var))
t2 <- Sys.time()

t3 <- Sys.time()
mtcars |>
  map(in_parallel(\(var) mean(var)))
t4 <- Sys.time()

(t2 - t1)
(t4 - t3)