#Hashing for de-dupe
#Samuel V. Scarpino (s.scarpino@northeastern.edu) 
#Jan. 30th 20202

###########
#libraries#
###########
require(FeatureHashing)

###########
#Functions#
###########
#I. remove columns with no variation
remove_zero_variability <- function(x){
  #find which columns have >1 unique entry so that we can remove those without any variability.
  x_unqiue <- unique(x)
  len_x_factor <- length(x_unqiue)
  which_g1 <- len_x_factor > 1
}

#II.  Data prep
prep_data <- function(data){
  #1. remove columns with no variation.
  data_remove_zero_variability <- data[sapply(data, remove_zero_variability)]
  
  #2. change all NAs to 0 (critical that this be second to avoid counting NAs when removing no variability)
  data_remove_zero_variability_na_0 <- data_remove_zero_variability
  data_remove_zero_variability_na_0[is.na(data_remove_zero_variability_na_0)] <- 0
  
  return(data_remove_zero_variability_na_0)
}

#III. Hashing and distance
hash_PC_dist <- function(data){
  data_dataframe <- as.data.frame(data)
  
  #hash
  dat_hashed <- hashed.model.matrix(~., data=data, hash.size=2^12, transpose=FALSE)
dat_hashed <- as(dat_hashed, "matrix")
  
  #remove zero variance columns after hash
  dat_hashed <- dat_hashed[ ,apply(dat_hashed, 2, var, na.rm = TRUE) != 0]
  
  #principle component analysis to reduce the dimensionality before calculating the distances
  dat_hashed_pr <- prcomp(x = dat_hashed, retx = TRUE, center = TRUE, scale = TRUE, tol = 0.5) #tol is what sets where we start throwing away PCs
  
  #calculate pairwise distances (this is the slow step)
  dist_dat_hashed <- dist(dat_hashed_pr$x)
  dist_dat_hashed <- as.matrix(dist_dat_hashed)
  
  #setting diagonal to NA
  diag(dist_dat_hashed) <- NA
  
  #normalizing scores
  min_score <- min(as.numeric(dist_dat_hashed)[-which(as.numeric(dist_dat_hashed) == 0)], na.rm = TRUE)
  if(min_score == 0){
    all_scores <- as.numeric(dist_dat_hashed)
  }else{
    all_scores <- as.numeric(dist_dat_hashed)/min_score
  }

  #determining the cutoff
  cutoff <- quantile(all_scores, probs = 0.0005, na.rm = TRUE)
  
  return(list("Distances" = dist_dat_hashed, "Cutoff" = cutoff))
}

#IV. Find matches
find_matches <- function(distances, cutoff){
  matches <- list()
  means <- rep(NA, nrow(distances))
  
  min_score <- min(distances[-which(distances == 0)], na.rm = TRUE)

  #iterate over the rows to find matches
  for(i in 1:nrow(distances)){
    matches_i <-  c()
    #normalize distances
    if(min_score == 0){
      scores_i <- distances[i,]
    }else{
      scores_i <- distances[i,]/min_score
    }
    
    #find matches
    matches_i <-  c(i, which(scores_i < cutoff))
    
    if(length(matches_i) > 1){#will be len 1 if it only finds itself as a match
      matches[[i]] <- matches_i
      means[i] <- mean(scores_i[matches_i], na.rm = TRUE)
    }
  }
  return(list("Matches" = matches, "Mean_distances" = means))
}

main <- function(data){
  prepped_data <- prep_data(data = data)
  hashed_dists <- hash_PC_dist(data = prepped_data)
  matches <- find_matches(distances = hashed_dists$Distances, cutoff = hashed_dists$Cutoff)
}