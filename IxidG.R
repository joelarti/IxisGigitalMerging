ibrary(dplyr)
addtocart <- read.csv(file.choose(), header = T, sep = ",") # reading the add to cart data
sescount <- read.csv(file.choose(), header = T, sep = ",") # reading the session count data
# start structuring the data after all necessary preliminary checks such as:
# dimensions, missing values, class of variables, etc.
sescount$dim_date <- as.Date(sescount$dim_date) # specifying the date variable as such
month <- strftime(sescount$dim_date, %m) # creating the month vector
sescount1 <- sescount %>% mutate(month = as.factor(as.numeric(month))) # attach the month column
sescount3 <- aggregate(cbind(sescount1$sessions, sescount1$transactions, sescount1$QTY),
                       by = list(sescount1$month, sescount1$dim_deviceCategory), FUN = sum)
sescount4 <- sescount3 %>% arrange(Group.1)
names(sescount4) <- c("month", "category", "sessions", "transactions", "QTY")
sescount5 <- sescount4 %>% mutate(ECR = transactions/sessions)

sescount6 <- aggregate(cbind(sescount5$sessions, sescount5$transactions, sescount5$QTY),
                       by = list(sescount5$month), FUN = sum)
names(sescount6) <- c("month", "sessions", "transactions", "QTY")
sescount7 <- sescount6 %>% mutate(ECR = transactions/sessions, addsToCart = addtocart$addsToCart,
                                  category = rep("Overall",12))
sescount7 <- sescount7 %>% select(month, category, sessions, transactions, QTY, addsToCart, ECR)
month.device <- sescount5 # R version of final data frame (Month x Device)
month.summary <- sescount7 # R version of final data frame (Month summary)

# Exporting to xlsx
library(openxlsx)
write.xlsx(month.device, file = "month.device.xlsx", colNames = TRUE)
write.xlsx(month.summary, file = "month.summary.xlsx", colNames = TRUE)