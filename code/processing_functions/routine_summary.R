###################################################################
### Code to process recreated line lists to produce githb outputs #
###################################################################
library(ggplot2)
#Unique source compiler

#expects a dataset formatted as per ncov_hubei.csv with x$source
#anticipate adding in a clean citation format at some stage DMP 20200125

sourceCompilR<-function(dataset, citation_format = FALSE, citation_key){
  sources<-dataset$source
  sources<-unique(sources)
}

sexSummary <- function(dataset, plot = TRUE) {
  #drop ID = NA, indicative of placeholders
  dataset <- subset(dataset,!is.na(dataset$ID))
  sex_string <- dataset$sex
  total <- length(sex_string)
  male <- length(sex_string[sex_string == "male"])
  female <- length(sex_string[sex_string == "female"])
  unknown <- length(sex_string[sex_string == ""])
  
  bar_plot <- data.frame(
    sex = c("male", "female", "unknown"),
    count = c(male, female, unknown)
  )
  
  ggplot(data = bar_plot, aes(x = sex, y = count)) +
    geom_bar(stat = "identity", fill = "steelblue") +
    geom_text(aes(label = count),
              vjust = 1.6,
              color = "white",
              size = 3.5) +
    theme_minimal() +
    ggtitle(paste0("Reported sex ratio = ", round(male/female, 2),":1" ))
}