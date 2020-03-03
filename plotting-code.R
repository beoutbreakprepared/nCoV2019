library(dplyr)
library(ggplot2)
source("tools.cleaner.R")
source("outside-hubei-20200301.cleaner.R")


.prop_na_string <- function(x) {
    sum(x == na_string) / length(x)
}

.completeness_data_frame <- function(x) {
    result <- as.data.frame(table(x))
    names(result) <- c("value", "frequency")
    result$value <- as.character(result$value)
    return(result)
}

chosen_theme <- theme_classic() + theme(text = element_text(size = 20))


.mesh <- function(max_age, age_string) {
    if (age_string == na_string) {
        rep(0, max_age + 1)
    } else if (grepl(pattern = anchor_wrap(.rgx_single_age), x = age_string)) {
        age_val <- as.integer(age_string)
        sapply(0:max_age, function(x) as.integer(age_val == x))
    } else if (grepl(pattern = anchor_wrap(.rgx_age_range), x = age_string)) {
        range_vals <- as.integer(unlist(strsplit(x = age_string, split = "-")))
        range_length <- diff(range_vals) + 1
        sapply(0:max_age, function(x) as.integer((range_vals[1] <= x) & (x <= range_vals[2]))) / range_length
    } else {
        stop("Could not parse age string.")
    }
}


tmp_df <- .completeness_data_frame(y$age)



max_age <- 100
acc <- rep(0,max_age + 1)
for (ix in 1:nrow(tmp_df)) {
    age_string <- tmp_df[ix, "value"]
    string_freq <- tmp_df[ix, "frequency"]
    acc <- acc + string_freq * .mesh(max_age, age_string)
}

bin_strings <- function(n, m) unlist(lapply(0:(n-1) * m, function(ix) rep(sprintf("%d-%d", ix, ix + m - 1), each = m)))



plot_df <- data.frame(acc = head(acc, -1), bin = bin_strings(10,10)) %>% group_by(bin) %>% summarise(sum_acc = sum(acc)) %>% as.data.frame


## sex_plots <- function(df) {
##     pdf1 <- .completeness_data_frame(df$sex)
##     plot1 <- ggplot(data = pdf1[pdf1$value != "NA",], mapping = aes(x = value, y = frequency)) +
##         geom_bar(stat = "identity", fill = "white", colour = "black") +
##         annotate("text", x = 1, y = 50, label = sprintf("Proportion missing:\n%f", .prop_na_string(df$sex)), size = 7) +
##         labs(x = "Sex", y = "Frequency") +
##         chosen_theme
##     return(list(plot1))
## }



