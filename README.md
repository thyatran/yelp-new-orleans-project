# Yelp New Orleans Restaurant Analysis

## Overview
This project uses the Yelp Open Dataset to analyze restaurants in New Orleans, Louisiana.

## Homework 5
- Downloaded and imported the Yelp business and review datasets.
- Filtered businesses to New Orleans restaurants.
- Filtered reviews to match those restaurants.
- Saved the cleaned datasets as RDS files.

## Dataset
- 2,259 New Orleans restaurants
- 476,421 restaurant reviews

## Project Structure
- `R/import_clean.R`: Data importing and filtering
- `data/raw/`: Original Yelp JSON files (not uploaded)
- `data/new_orleans/`: Filtered RDS datasets

**Note:** The filtered reviews dataset was originally over 100 MB, exceeding GitHub's file size limit. To upload the complete dataset, it was split into two RDS files (`reviews_part1.rds` and `reviews_part2.rds`). Both files retain all 476,421 reviews and can be combined for analysis.

## Data Source
Yelp Open Dataset:
https://business.yelp.com/data/resources/open-dataset/