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

.bin_strings <- function(n, m) {
    unlist(lapply(0:(n-1) * m, function(ix) rep(sprintf("%d-%d", ix, ix + m - 1), each = m)))
}

histogram_date_strings <- function(age_df) {
    df <- .completeness_data_frame(age_df)
    max_age <- 99
    acc <- rep(0,max_age + 1)
    for (ix in 1:nrow(df)) {
        age_string <- df[ix, "value"]
        string_freq <- df[ix, "frequency"]
        acc <- acc + string_freq * .mesh(max_age, age_string)
    }
    tmp <- data.frame(acc = acc, bin = .bin_strings(10,10))
    tmp %>% group_by(bin) %>% summarise(sum_acc = sum(acc))
}


female_plot_df <- y %>% filter(sex == "female") %>% select(age) %>% histogram_date_strings() %>% mutate(sex = "female")
male_plot_df <- y %>% filter(sex == "male") %>% select(age) %>% histogram_date_strings()  %>% mutate(sex = "male")
plot_df <- bind_rows(female_plot_df, male_plot_df)

y %>% filter(sex != "NA") %>% filter(age != "NA") %>% select(age, sex)
tmp1 <- y %>% filter(sex != "NA") %>% filter(age != "NA") %>% nrow
tmp2 <- sum(plot_df$sum_acc)
stopifnot(tmp1 == tmp2)
rm(tmp1)
rm(tmp2)

chosen_theme <- theme_classic() + theme(text = element_text(size = 20), axis.text.x = element_text(angle = -30))


sex_age_plot <- ggplot(plot_df, aes(x = bin, y = sum_acc, colour = sex)) +
    ## geom_line(mapping = aes(group = sex))
    geom_bar(stat = "identity", position = "dodge", fill = "white", size = 1) +
    annotate("text", x = 2, y = 0.8 * max(plot_df$sum_acc), label = sprintf("Proportion missing:\n%.2f", 1 - sum(plot_df$sum_acc) / nrow(y)), size = 6) +
    labs(x = "Age", y = "Frequency", colour = "Sex") +
    ggtitle("Sex stratified age distribution from XXX") +
    chosen_theme




## tmp1 <- y %>% select(country, date_confirmation)
## mask <- grepl(pattern = na_string, x = tmp1$date_confirmation)
## tmp2 <- tmp1[!mask,]
## mask <- is.na(tmp2$country)
## tmp2 <- tmp2[!mask,]
## tmp2$date <- strpdate(tmp2$date_confirmation)
## total_cases <- tmp2 %>% group_by(country) %>% summarise(num_cases = length(date))
## ten_case_countries <- total_cases %>% filter(num_cases >= 10) %>% as.data.frame()
## mask <- sapply(tmp2$country, function(x) x %in% ten_case_countries$country)
## tmp3 <- tmp2[mask,]
## tmp4 <- tmp3 %>% group_by(country) %>% summarise(first_case = min(date))
## tmp5 <- tmp4 %>% select(first_case) %>% unlist() %>% sort.int(index.return = TRUE) %>% `$`("ix")
## tmp6 <- tmp4$country[tmp5]

## plot_df <- tmp3 %>% filter(!is.na(country)) %>% filter(country != "NA") %>% mutate(sorted_country = factor(country, levels = tmp6)) %>% left_join(total_cases)

## cases_through_time <- ggplot(plot_df, aes(x = date, y = sorted_country, fill = log10(num_cases))) +
##     geom_density_ridges(bandwidth=2,
##                         jittered_points = TRUE,
##                         position = position_points_jitter(width = 0.5, height = 0),
##                         point_shape = '|',
##                         point_size = 3,
##                         point_alpha = 1,
##                         alpha = 0.7,) +
##     scale_fill_gradient2() +
##     labs(x = "Date", y = "Country", fill = "Log10 cases") +
##     ggtitle("Confirmed cases in ten countries with most confirmed cases through time")




## tmp1 <- y %>% select(country, date_onset_symptoms)
## mask <- grepl(pattern = na_string, x = tmp1$date_onset_symptoms)
## tmp2 <- tmp1[!mask,]
## mask <- is.na(tmp2$country)
## tmp2 <- tmp2[!mask,]
## tmp2$date <- strpdate(tmp2$date_onset_symptoms)
## total_cases <- tmp2 %>% group_by(country) %>% summarise(num_cases = length(date))
## ten_case_countries <- total_cases %>% filter(num_cases >= 3) %>% as.data.frame()
## mask <- sapply(tmp2$country, function(x) x %in% ten_case_countries$country)
## tmp3 <- tmp2[mask,]
## tmp4 <- tmp3 %>% group_by(country) %>% summarise(first_case = min(date))
## tmp5 <- tmp4 %>% select(first_case) %>% unlist() %>% sort.int(index.return = TRUE) %>% `$`("ix")
## tmp6 <- tmp4$country[tmp5]

## plot_df <- tmp3 %>% filter(!is.na(country)) %>% filter(country != "NA") %>% mutate(sorted_country = factor(country, levels = tmp6)) %>% left_join(total_cases)

## cases_through_time <- ggplot(plot_df, aes(x = date, y = sorted_country, fill = log10(num_cases))) +
##     geom_density_ridges(bandwidth=2,
##                         jittered_points = TRUE,
##                         position = position_points_jitter(width = 0.5, height = 0),
##                         point_shape = '|',
##                         point_size = 3,
##                         point_alpha = 1,
##                         alpha = 0.7,) +
##     scale_fill_gradient2() +
##     labs(x = "Date", y = "Country", fill = "Log10 cases") +
##     ggtitle("Onset of symptoms in three countries with most confirmed cases through time")
