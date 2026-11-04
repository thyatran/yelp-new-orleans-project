# Homework 5 - Yelp New Orleans Project
# Step 1: Load packages

library(tidyverse)
library(jsonlite)

# Step 2: File paths
business_file <- "data/raw/yelp_academic_dataset_business.json"
review_file <- "data/raw/yelp_academic_dataset_review.json"

# Step 3: Check that files exist
file.exists(business_file)
file.exists(review_file)

# Step 4: Load business data
business_raw <- jsonlite::stream_in(
  file(business_file),
  verbose = FALSE
)

# Step 5: Inspect data
dim(business_raw)
glimpse(business_raw)

# Step 6: Select relevant business columns
business <- business_raw |>
  select(
    business_id, name, address, city, state,
    postal_code, latitude, longitude,
    stars, review_count, categories
  )

# Step 7: Filter for New Orleans restaurants
new_orleans_restaurants <- business |>
  filter(
    city == "New Orleans",
    state == "LA",
    !is.na(categories),
    str_detect(categories, regex("Restaurants", ignore_case = TRUE))
  ) |>
  mutate(
    postal_code = na_if(postal_code, ""),
    categories = str_squish(categories),
    business_name = str_squish(name)
  ) |>
  distinct(business_id, .keep_all = TRUE)

# Step 8: Inspect filtered data
dim(new_orleans_restaurants)
glimpse(new_orleans_restaurants)

# Step 9: Filter reviews for New Orleans restaurants

restaurant_ids <- new_orleans_restaurants$business_id

review_chunks <- list()

con <- file(review_file, open = "r")

repeat {
  lines <- readLines(con, n = 10000, warn = FALSE)
  
  if (length(lines) == 0) break
  
  chunk <- jsonlite::stream_in(
    textConnection(paste(lines, collapse = "\n")),
    verbose = FALSE
  )
  
  chunk <- chunk |>
    filter(business_id %in% restaurant_ids) |>
    select(
      review_id, business_id, user_id,
      stars, date, text, useful, funny, cool
    )
  
  if (nrow(chunk) > 0) {
    review_chunks[[length(review_chunks) + 1]] <- chunk
  }
}

close(con)

new_orleans_reviews <- bind_rows(review_chunks)

# Step 10: Inspect filtered reviews
dim(new_orleans_reviews)
glimpse(new_orleans_reviews)

# Step 11: Save filtered datasets

dir.create(
  "data/new_orleans",
  recursive = TRUE,
  showWarnings = FALSE
)

saveRDS(
  new_orleans_restaurants,
  "data/new_orleans/business_new_orleans.rds"
)

# saveRDS(
#  new_orleans_reviews,
#  "data/new_orleans/reviews_new_orleans.rds"
# )

# Split reviews into two files for GitHub
n <- nrow(new_orleans_reviews)
mid <- floor(n / 2)

saveRDS(
  new_orleans_reviews[1:mid, ],
  "data/new_orleans/reviews_part1.rds"
)

saveRDS(
  new_orleans_reviews[(mid + 1):n, ],
  "data/new_orleans/reviews_part2.rds"
)

# Step 12: Verify saved files
# Step 12: Verify saved files

file.exists("data/new_orleans/business_new_orleans.rds")
file.exists("data/new_orleans/reviews_part1.rds")
file.exists("data/new_orleans/reviews_part2.rds")