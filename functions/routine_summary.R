#Unique source compiler

#expects a dataset formatted as per ncov_hubei.csv with x$source
#anticipate adding in a clean citation format at some stage DMP 20200125

sourceCompilR<-function(dataset, citation_format = FALSE, citation_key){
  sources<-dataset$source
  sources<-unique(sources)
}