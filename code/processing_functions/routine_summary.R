###################################################################
### Code to process recreated line lists to produce githb outputs #
###################################################################
library(ggplot2)
library(gridExtra)
library(grid)
#Unique source compiler

#expects a dataset formatted as per ncov_hubei.csv with x$source
#anticipate adding in a clean citation format at some stage DMP 20200125

sourceCompilR<-function(dataset, citation_format = FALSE, citation_key){
  sources<-dataset$source
  sources<-unique(sources)
}

sexSummary <- function(dataset, plot = TRUE) {
  #drop ID = NA, indicative of placeholders
  dataset<-subset(dataset, !dataset$country=="")
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

countrySummary<-function(dataset){
  dataset<-subset(dataset, !dataset$country=="")
  unique_countries<-unique(dataset$country)
  
  summary_output<-data.frame(country = unique_countries, count = rep(NA, length(unique_countries)))
  for(i in 1:nrow(summary_output)){
    subset_data<-subset(dataset, dataset$country == summary_output$country[i])
    summary_output$count[i]<-nrow(subset_data)
    
    # if(summary_output$country[i] == "Taiwan, China"){
    #   summary_output$country[i]<-"Taiwan, Province of China"
    # }
  }
  summary_output<-summary_output[rev(order(summary_output$count)),]
  grid.table(summary_output)
}
