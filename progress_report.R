
library(targets)

logs <- tibble(i = 0,
               time = Sys.time())
  
while (length(tar_outdated()) > 0) {
  if (i < 20) {
  i <- last(logs$i) + 1
  logs <- logs |> 
    add_row(list(
      i = i,
      time = `Sys.time()`
    ))
  write.table(logs, "logs.txt")
  Sys.sleep(1)
  } else break
}

