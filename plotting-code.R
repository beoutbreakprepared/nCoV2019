library(dplyr)
library(ggplot2)
source("tools.cleaner.R")
source("outside-hubei-20200301.cleaner.R")



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


#' Plot showing the age distribution of cases stratified by sex.

sex_age_plot <- ggplot(plot_df, aes(x = bin, y = sum_acc, colour = sex)) +
    ## geom_line(mapping = aes(group = sex))
    geom_bar(stat = "identity", position = "dodge", fill = "white", size = 1) +
    annotate("text", x = 2, y = 0.8 * max(plot_df$sum_acc), label = sprintf("Proportion missing:\n%.2f", 1 - sum(plot_df$sum_acc) / nrow(y)), size = 6) +
    labs(x = "Age", y = "Frequency", colour = "Sex") +
    ggtitle("Sex stratified age distribution from XXX") +
    chosen_theme



#' Plot showing how the delay between onset of symptoms and hospitalisation has changed over time.

onset_dates <- strpdate(y$date_onset_symptoms)
hosp_dates <- strpdate(y$date_admission_hospital)
plot_df <- data.frame(onset_date = onset_dates, delay = hosp_dates - onset_dates) %>% filter(!is.na(delay))

delay_hosp_plot <- ggplot(plot_df, aes(x = as.Date(onset_date, origin = "1970-01-01"), y = delay)) +
    geom_jitter(width = 0.5, height = 0.5) +
    labs(x = "Date of symptom onset", y = "Days after symptom onset until hospitalisation") +
    ggtitle("Delay from symptom onset to hospital admission XXX") +
    chosen_theme +
    theme(axis.text.x = element_text(angle = 0))




#' Plot showing how the delay between onset of symptoms and confirmation has changed over time.

onset_dates <- strpdate(y$date_onset_symptoms)
conf_dates <- strpdate(y$date_confirmation)
plot_df <- data.frame(onset_date = onset_dates, delay = conf_dates - onset_dates) %>% filter(!is.na(delay))

delay_conf_plot <- ggplot(plot_df, aes(x = as.Date(onset_date, origin = "1970-01-01"), y = delay)) +
    geom_jitter(width = 0.5, height = 0.5) +
    labs(x = "Date of symptom onset", y = "Days after symptom onset for confirmation") +
    ggtitle("Delay from symptom onset to confirmation XXX") +
    chosen_theme +
    theme(axis.text.x = element_text(angle = 0))
