# ============================================================
#   Statistical Data Analysis & EDA
#   Tools: R (ggplot2, dplyr, tidyr, corrplot)
# ============================================================

# ── Install packages if needed ───────────────────────────────
packages <- c("ggplot2", "dplyr", "tidyr", "corrplot", "scales")
installed <- packages %in% rownames(installed.packages())
if (any(!installed)) install.packages(packages[!installed], repos = "https://cran.r-project.org")

library(ggplot2)
library(dplyr)
library(tidyr)
library(corrplot)
library(scales)

# ── Output directory ─────────────────────────────────────────
dir.create("plots", showWarnings = FALSE)
cat("libraries loaded\n")


# ============================================================
# 1. GENERATE SYNTHETIC DATASET
# ============================================================

set.seed(42)
n <- 200

data <- data.frame(
  employee_id    = 1:n,
  department     = sample(c("Engineering", "Marketing", "Sales", "HR", "Finance"), n, replace = TRUE),
  age            = round(rnorm(n, mean = 35, sd = 8)),
  salary         = round(rnorm(n, mean = 60000, sd = 15000)),
  experience_yrs = round(runif(n, min = 1, max = 20)),
  performance    = round(rnorm(n, mean = 75, sd = 12)),
  satisfaction   = round(runif(n, min = 1, max = 10), 1),
  gender         = sample(c("Male", "Female"), n, replace = TRUE, prob = c(0.55, 0.45))
)
View(data)

# Clamp values to realistic bounds
data$age         <- pmax(22, pmin(65, data$age))
data$salary      <- pmax(30000, pmin(120000, data$salary))
data$performance <- pmax(40, pmin(100, data$performance))

cat("ataset created:", nrow(data), "rows x", ncol(data), "columns\n\n")


# ============================================================
# 2. DESCRIPTIVE STATISTICS
# ============================================================

cat("=" , strrep("=", 30), "\n")
cat("  DESCRIPTIVE STATISTICS\n")
cat("=" , strrep("=", 30), "\n")

numeric_cols <- c("age", "salary", "experience_yrs", "performance", "satisfaction")
##summary of the data
stats_summary <- data %>%
  select(all_of(numeric_cols)) %>%
  summarise(across(everything(), list(
    Mean   = ~round(mean(.),   2),
    Median = ~round(median(.), 2),
    SD     = ~round(sd(.),     2),
    Min    = ~round(min(.),    2),
    Max    = ~round(max(.),    2)
  ))) %>%
  pivot_longer(everything(),
               names_to  = c("Variable", "Stat"),
               names_sep = "_") %>%
  pivot_wider(names_from = Stat, values_from = value)

print(as.data.frame(stats_summary))


# ============================================================
# 3. CORRELATION ANALYSIS
# ============================================================

cat("\n Correlation Matrix (numeric variables):\n")

cor_matrix <- cor(data[, numeric_cols], use = "complete.obs")
print(round(cor_matrix, 3))

png("plots/01_correlation_matrix.png", width = 500, height = 400)
corrplot(cor_matrix,
         method  = "color",
         type    = "upper",
         addCoef.col = "black",
         tl.col  = "black",
         tl.srt  = 45,
         title   = "Correlation Matrix — Employee Data",
         mar     = c(0, 0, 2, 0))
dev.off()
print(cor_matrix)
cat("saved: plots/01_correlation_matrix.png\n")


# ============================================================
# 4. SALARY DISTRIBUTION
# ============================================================

p1 <- ggplot(data, aes(x = salary)) +
  geom_histogram(aes(y = after_stat(density)),
                 bins = 30, fill = "#4C72B0", color = "white", alpha = 0.8) +
  geom_density(color = "#DD4444", linewidth = 1.2) +
  geom_vline(aes(xintercept = mean(salary)),
             color = "darkgreen", linetype = "dashed", linewidth = 1) +
  scale_x_continuous(labels = comma) +
  labs(title    = "Salary Distribution",
       subtitle = paste("Mean =", comma(round(mean(data$salary))),
                        "| SD =", comma(round(sd(data$salary)))),
       x = "Salary (ZAR)", y = "Density") +
  theme_minimal(base_size = 13) +
  theme(plot.title = element_text(face = "bold"))

ggsave("plots/02_salary_distribution.png", p1, width = 8, height = 5)
print(p1)
cat("saved: plots/02_salary_distribution.png\n")


# ============================================================
# 5. SALARY BY DEPARTMENT (BOXPLOT)
# ============================================================

dept_stats <- data %>%
  group_by(department) %>%
  summarise(
    mean_salary = mean(salary),
    median_salary = median(salary),
    count = n()
  ) %>%
  arrange(desc(mean_salary))

cat("\n📊 Salary by Department:\n")
print(as.data.frame(dept_stats))

p2 <- ggplot(data, aes(x = reorder(department, salary, median), y = salary, fill = department)) +
  geom_boxplot(alpha = 0.8, outlier.colour = "red", outlier.shape = 16) +
  geom_jitter(width = 0.15, alpha = 0.3, size = 1.2) +
  scale_y_continuous(labels = comma) +
  coord_flip() +
  labs(title    = "Salary Distribution by Department",
       subtitle = "Boxplot with individual data points",
       x = "Department", y = "Salary") +
  theme_minimal(base_size = 13) +
  theme(legend.position = "none",
        plot.title = element_text(face = "bold"))

ggsave("plots/03_salary_by_department.png", p2, width = 9, height = 6)
print(p2)
cat("saved: plots/03_salary_by_department.png\n")


# ============================================================
# 6. PERFORMANCE VS SALARY SCATTER PLOT
# ============================================================

p3 <- ggplot(data, aes(x = experience_yrs, y = salary, color = department)) +
  geom_point(alpha = 0.7, size = 2.5) +
  geom_smooth(method = "lm", se = TRUE, color = "black", linewidth = 1) +
  scale_y_continuous(labels = comma) +
  labs(title    = "Salary vs Years of Experience",
       subtitle = "Linear trend with 95% confidence interval",
       x = "Years of Experience", y = "Salary",
       color = "Department") +
  theme_minimal(base_size = 13) +
  theme(plot.title = element_text(face = "bold"))

ggsave("plots/04_salary_vs_experience.png", p3, width = 10, height = 6)
print(p3)
cat("saved: plots/04_salary_vs_experience.png\n")


# ============================================================
# 7. PERFORMANCE SCORE DISTRIBUTION BY GENDER
# ============================================================

p4 <- ggplot(data, aes(x = performance, fill = gender)) +
  geom_density(alpha = 0.6) +
  geom_vline(data = data %>% group_by(gender) %>% summarise(m = mean(performance)),
             aes(xintercept = m, color = gender),
             linetype = "dashed", linewidth = 1.1) +
  labs(title    = "Performance Score Distribution by Gender",
       subtitle = "Density plot with mean indicators",
       x = "Performance Score", y = "Density",
       fill = "Gender", color = "Gender") +
  theme_minimal(base_size = 13) +
  theme(plot.title = element_text(face = "bold"))

ggsave("plots/05_performance_by_gender.png", p4, width = 9, height = 5)
print(p4)
cat("saved: plots/05_performance_by_gender.png\n")


# ============================================================
# 8. EMPLOYEE COUNT BY DEPARTMENT (BAR CHART)
# ============================================================

p5 <- data %>%
  count(department) %>%
  ggplot(aes(x = reorder(department, n), y = n, fill = department)) +
  geom_col(alpha = 0.85, width = 0.6) +
  geom_text(aes(label = n), hjust = -0.2, size = 4.5) +
  coord_flip() +
  ylim(0, max(table(data$department)) + 10) +
  labs(title = "Employee Count by Department",
       x = "Department", y = "Number of Employees") +
  theme_minimal(base_size = 13) +
  theme(legend.position = "none",
        plot.title = element_text(face = "bold"))

ggsave("plots/06_employee_count.png", p5, width = 8, height = 5)
print(p5)
cat("saved: plots/06_employee_count.png\n")


# ============================================================
# 9. SATISFACTION VS PERFORMANCE
# ============================================================

p6 <- ggplot(data, aes(x = satisfaction, y = performance, color = department)) +
  geom_point(alpha = 0.6, size = 2) +
  geom_smooth(method = "lm", se = FALSE, aes(group = 1),
              color = "black", linewidth = 1.2) +
  labs(title    = "Job Satisfaction vs Performance Score",
       subtitle = "Overall linear trend across all departments",
       x = "Job Satisfaction (1-10)", y = "Performance Score",
       color = "Department") +
  theme_minimal(base_size = 13) +
  theme(plot.title = element_text(face = "bold"))

ggsave("plots/07_satisfaction_vs_performance.png", p6, width = 10, height = 6)
print(p6)
cat("aved: plots/07_satisfaction_vs_performance.png\n")


# ============================================================
# 10. STATISTICAL TESTS
# ============================================================

cat("\n", strrep("=", 50), "\n")
cat("  STATISTICAL TESTS\n")
cat(strrep("=", 50), "\n")

# T-test: salary difference between genders
male_salary   <- data$salary[data$gender == "Male"]
female_salary <- data$salary[data$gender == "Female"]
ttest_result  <- t.test(male_salary, female_salary)

cat("\n🔬 T-Test: Salary difference between genders\n")
cat("   Male mean salary:   ", round(mean(male_salary)),   "\n")
cat("   Female mean salary: ", round(mean(female_salary)), "\n")
cat("   p-value:            ", round(ttest_result$p.value, 4), "\n")
cat("   Conclusion: ", ifelse(ttest_result$p.value < 0.05,
                              "Significant difference (p < 0.05)",
                              "No significant difference (p >= 0.05)"), "\n")

# Correlation test: experience vs salary
cor_test <- cor.test(data$experience_yrs, data$salary)
cat("\n🔬 Correlation Test: Experience vs Salary\n")
cat("   Pearson r: ", round(cor_test$estimate, 4), "\n")
cat("   p-value:   ", round(cor_test$p.value, 4), "\n")
cat("   Conclusion:", ifelse(cor_test$p.value < 0.05,
                             "Significant correlation",
                             "No significant correlation"), "\n")

# ANOVA: performance across departments
anova_result <- aov(performance ~ department, data = data)
anova_summary <- summary(anova_result)
cat("\n🔬 ANOVA: Performance across Departments\n")
cat("   F-value: ", round(anova_summary[[1]]$`F value`[1], 4), "\n")
cat("   p-value: ", round(anova_summary[[1]]$`Pr(>F)`[1], 4), "\n")
cat("   Conclusion:", ifelse(anova_summary[[1]]$`Pr(>F)`[1] < 0.05,
                             "Significant difference between departments",
                             "No significant difference between departments"), "\n")


# ============================================================
# DONE
# ============================================================

cat("\n", strrep("=", 50), "\n")
cat("NALYSIS COMPLETE — plots saved to /plots\n")
cat(strrep("=", 50), "\n")

