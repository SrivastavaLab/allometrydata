update_data <- function(data_dir = "/home/a/Dropbox/CommunityAnalysis/Allometry",
                        github_repo = "SrivastavaLab/allometrydata"){
  # Look for Github Token or force setup of the token

  # Try to get the latest version of the data from GitHub.
  # If there is no data (thereby generating an error), allometry_data
  # will be set to FALSE.
  allometry_data <- try(datastorr::datastorr(repo = github_repo), silent = TRUE)

  if(class(allometry_data) == "try-error"){
    allometry_data <- NA
  }

  # Create list of files in data_dir (should definitely be in Dropbox)
  # Possibly restrict this to the Dropbox/CommunityAnalysis/Allometry folder
  # For now, I can keep it in my data_dir so it won't really work otherwise
  allometry_files <- list.files(data_dir, pattern = ".xls")

  # Check the list of file names against those ones attached to the data set
  if(is.na(allometry_data)){
    new_files <- allometry_files
  } else {
    # Get the list of only new files
  }

  # Import data from any files that are not already listed
  # Slash direction needs to depend on OS
  # May need to do some editing of data types
  for(i in 1:length(new_files)){
    filename  <- new_files[i]
    file_path <- paste(data_dir, filename, sep = "/")

    temp_data <- gdata::read.xls(file_path, sheet = 1, method = "csv",
                                 encoding = "UTF-8", stringsAsFactors = F)

    # Select the expected list of column names.  Extra columns will disappear.
    # Gives error if column is missing.
    temp_data <- subset(temp_data,
                        select = c("bwg_name", "name", "length_mm", "wet_mass_mg",
                                   "dry_mass_mg", "length_measured_as",
                                   "number_of_individuals", "stage",
                                   "size_category", "instar_number"))

    # Add a column for filename
    temp_data$file <- filename

    # Compile all data into one data frame
    if(i == 1){
      all_data <- temp_data
    } else {
      all_data <- rbind(all_data, temp_data)
    }
  }

  # Add a column for data type (measurement vs. category definition)
  all_data$type <- NA
  for(i in 1:nrow(all_data)){
    if(is.na(all_data$wet_mass_mg[i]) &
       is.na(all_data$dry_mass_mg[i]) &
       !is.na(all_data$length_mm[i])  &
       !is.na(all_data$size_category[i])){
      all_data$type[i] <- "category_definition"
    } else {
      all_data$type[i] <- "field_measurement"
    }
  }

  # Update the data frame
  if(is.na(allometry_data)){
    final_data <- all_data
  } else{
    final_data <- rbind(allometry_data, all_data)
  }

  # Save data
  saveRDS(final_data, file = "_data/allometry_data.rds")

  # Release the data to GitHub
  datastorr::release(github_repo, "0.0.0.9000",
                     filename = "_data/allometry_data.rds")

  return(invisible())
}
