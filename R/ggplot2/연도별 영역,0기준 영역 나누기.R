library(dplyr)
library(stringr)
library(ggplot2)
library(reshape)

TS <- data.frame(date = seq(as.Date("2012-01-01"), as.Date("2019-01-01"), by="month"),
                 value = c(runif(30, -.3, 0), runif(55,0,0.3)))

# 연도별로 영억 채우기 
ggplot(TS,aes(x=date,y=value)) +
  geom_line() + 
  geom_area(data = TS[substr(TS$date,1,4) == "2012",], fill="hotpink", alpha=0.3) +
  geom_area(data = filter(TS, str_sub(TS$date,1,4) == "2013"), fill = "royalblue", alpha=0.3) +
  geom_area(data = TS[grep("^2014",TS$date),], fill = "gold", alpha=0.3) +
  geom_area(data = TS[str_detect(TS$date,"^2015"),], fill = "green", alpha=0.3) + 
  geom_area(data = TS[grep("[^2012|2013|2014|2015]",substr(TS$date,1,4)),], fill="cyan1", alpha=0.3)

# 0을 기준으로 위아래 다른색 채우기 
# 막대
ggplot(TS, aes(x=date, y=value)) +
  geom_col(data = TS[TS$value <= 0,], fill = "Coral1", alpha = .3) +
  geom_col(data = TS[TS$value > 0,], fill = "royalblue1", alpha = .3) +
  geom_hline(yintercept = 0, color="black") +
  theme_bw()

# 시계열 
TS %>% select(date,value) %>% 
  melt(id=c("date")) %>%
  mutate(area = ifelse(value > 0,"up","down")) %>%
  ggplot(aes(x=date, y=value)) + 
  geom_area(aes(fill=area), alpha=0.3) +
  geom_line() +
  geom_hline(yintercept = 0, color='black')

ggplot(TS, aes(x = date, y = value)) +
  geom_area(data = subset(TS, value <= 0), fill = "Coral1", alpha=0.3) +
  geom_area(data = subset(TS, value >= 0), fill = "cyan", alpha=0.3) +
  theme_bw()
