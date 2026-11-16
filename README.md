# Yelp New Orleans Restaurant Analysis

## Project Overview

This project uses the Yelp Open Dataset to compare Cajun/Creole, Seafood, and Southern restaurants in New Orleans, Louisiana. It combines restaurant and review records with geographic boundaries and adjusts ratings for differences in reviewers' usual scoring habits.

**Research question:** Which Cajun/Creole, Seafood, and Southern restaurants in New Orleans rank highest after adjusting for reviewer rating habits, and which census tracts offer the strongest restaurant options?

**Executive summary:** The analysis identifies 648 restaurants in the three selected categories and ranks eligible restaurants using reviewer-normalized ratings. It also compares four geographic systems and uses census tracts to examine which areas have the highest average normalized restaurant scores.

## View the Final Report

**[View the final HTML report](docs/yelp_new_orleans_project.html)**

The report includes tables, maps, results, interpretations, limitations, and AI prompt examples. For a browser-viewable public link, publish the HTML and its supporting assets (for example, using GitHub Pages).

## Key Findings

- **Top restaurants:** 3 Southern Girls ranked first by reviewer-normalized score (1.241), followed by Cafe Porche and snowbar (0.759) and La Vie En Rose Cafe (0.741). The full top 10 and final map appear in Section 8 of the report.
- **Ranking changes:** Pelican Bay moved from 99th to 4th among eligible restaurants after reviewer normalization.
- **Top geographic area:** Census tract `22071003702` had the highest average normalized restaurant score (0.341) among tracts with at least three eligible restaurants.

These rankings depend on the dataset and eligibility rules and should not be interpreted as definitive measures of restaurant quality.

## Data and Methods

- **Source:** [Yelp Open Dataset](https://business.yelp.com/data/resources/open-dataset/).
- **Cleaned data:** 2,259 New Orleans restaurants and 476,421 restaurant reviews.
- **Selected categories:** Cajun/Creole (401 restaurants), Seafood (331), and Southern (155). Because categories overlap, there are 648 unique restaurants in the selected group.
- **Geographic comparison:** Census tracts, ZIP Code Tabulation Areas (ZCTAs), census block groups, and neighborhoods. Census tracts were selected for their balance of geographic detail and restaurant coverage.
- **Reviewer normalization:** For reviewers with at least five reviews in the selected restaurant dataset, each review's score was adjusted by subtracting that reviewer's mean rating. Restaurants required at least five ratings from these active reviewers to qualify for the rankings.
- **Geographic rankings:** Census tracts with at least three eligible restaurants were ranked by the unweighted mean of their restaurants' normalized scores.

## Repository Structure

```text
R/
  import_clean.R                  # Import, filter, and save Yelp data

data/
  raw/                            # Original Yelp JSON files (local only; not committed)
  new_orleans/
    business_new_orleans.rds      # Cleaned restaurant data
    reviews_part1.rds            # Cleaned reviews, first part
    reviews_part2.rds            # Cleaned reviews, second part

geographic_analysis.qmd           # Earlier geographic comparison (Homework 6)
yelp_new_orleans_project.qmd      # Complete final analysis and report
yelp_new_orleans_project.html     # Rendered final report
yelp_new_orleans_project_files/   # Supporting HTML assets
README.md                         # Project overview and instructions
```

*The `data/raw/` directory is used locally and may not appear on GitHub. The report retrieves Census geographic boundaries with `tigris`; a local `data/geography/` directory is not required by the instructions below.*

## How to Access and Reproduce the Analysis

### View results without running code

Open the [rendered HTML report](yelp_new_orleans_project.html) after downloading the repository, or use its published website link if available. The tables and maps are already rendered. Keep `yelp_new_orleans_project_files/` alongside the HTML so its supporting assets load correctly.

### Render the report from the cleaned data

1. Clone or download this repository.
2. Install [R](https://www.r-project.org/), [RStudio](https://posit.co/download/rstudio-desktop/), and [Quarto](https://quarto.org/).
3. Install the R packages used in the report: `tidyverse`, `jsonlite`, `lubridate`, `sf`, `tigris`, `scales`, `viridis`, and `knitr`.
4. Confirm that `business_new_orleans.rds`, `reviews_part1.rds`, and `reviews_part2.rds` are in `data/new_orleans/`.
5. Open `yelp_new_orleans_project.qmd` in RStudio and click **Render**, or run `quarto render yelp_new_orleans_project.qmd` from the repository root.

The report retrieves U.S. Census geographic boundaries using `tigris`, so an internet connection may be needed.

### Re-create the cleaned data from the original Yelp files

1. Download the Yelp Open Dataset from the [official Yelp dataset page](https://business.yelp.com/data/resources/open-dataset/), following its access instructions.
2. Extract the downloaded archive locally.
3. Place `yelp_academic_dataset_business.json` and `yelp_academic_dataset_review.json` in `data/raw/`.
4. From the repository root, run `R/import_clean.R` in RStudio or use `Rscript R/import_clean.R`.

The import script streams the business JSON and processes the much larger review JSON in batches of 10,000 lines, retaining reviews for New Orleans restaurants. It saves the filtered data as RDS files for subsequent analysis.

## Large-Data Management

The original Yelp JSON files are too large to keep in this repository, so they are stored locally in `data/raw/` and excluded from GitHub. Processing the review JSON in chunks reduces memory use, while saving filtered RDS files avoids repeated imports. The cleaned review dataset also exceeded GitHub's 100 MB single-file limit, so it was divided into `reviews_part1.rds` and `reviews_part2.rds`. **Together, these two files contain 476,421 reviews**, and the analysis recombines them with `bind_rows()`.

## Limitations and AI Use

The dataset may not represent all current restaurants or customers. Yelp city labels do not always align with official Census boundaries, and normalized rankings can be sensitive to small reviewer samples. Section 9 of the report discusses these limitations, and Section 11 documents specific AI prompts, follow-up prompts, and verification steps.

## Data Source

[Yelp Open Dataset](https://business.yelp.com/data/resources/open-dataset/)