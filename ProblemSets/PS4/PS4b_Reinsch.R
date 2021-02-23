library(tidyverse)
library(sparklyr)
spark_install(version = "3.0.0")
sc <- spark_connect(master = "local")
# When attempting to run this command in the console, I get the following error code 
#Error in spark_connect_gateway(gatewayAddress, gatewayPort, sessionId,  :
                                 #Gateway in localhost:8880 did not respond.
                               
                               
                               #Try running `options(sparklyr.log.console = TRUE)` followed by `sc <- spark_connect(...)` for more debugging info.
df1<-as_tibble(iris)
df <- copy_to(sc, df1)
class(df1)
class(df)
# I am not able to comment on the class type since the spark_connect command did not work.

df %>% select(Sepal_Length,Species) %>% head %>% print

df %>% filter(Sepal_Length>5.5) %>% head %>% print

df %>% filter(Sepal_Length>5.5) %>% head %>% print %>% select(Sepal_Length,Species) %>%
  head %>% print
    
df2 <- df %>% group_by(Species) %>% summarize(mean = mean(Sepal_Length),
                                              count = n()) %>% head %>% print

df2 <- df2 %>% group_by(Species) %>% summarize(mean = mean(Sepal_Length),
                                              count = n()) %>% head %>% print
df2 %>% arrange(Species) %>% head %>% print

