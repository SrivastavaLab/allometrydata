#' Update allometry data.
#'
#' Updates the allometry data sets.
#'
#' This compiles the most recent release of allometry data and adds data from
#' any new allometry data files. Inputs should be XLS files located in
#' \code{../Dropbox/CommunityAnalysis/Allometry}
#'
#' @param dropbox_dir character string indicating the location of your Dropbox
#'   folder. The allometry XLS files are assumed to be in the shared folder:
#'   \code{../CommunityAnalysis/Allometry}
#' @param data_dir character string indicating the directory in which the
#'   compiled data will be saved.
#' @param return_data logical indicating whether or not the data should be
#'   returned after running the update. If no new data are found, nothing
#'   will be returned.
#' @return Saves the compiled data set as an RDS file in the chosen directory.
#'   It is expected that this file will be uploaded to the GitHub repository
#'   as a new release. The data frame of updated data is optionally returned.
#' @examples
#' @export
#' 
update_data <- function(data_dir, dropbox_dir = "/home/a/Dropbox",
                        return_data = FALSE){
  ## To Do:
  ## * Adjust path specification so it will work between operating systems
  
  # I/O Variables
  github_repo    <- "SrivastavaLab/allometrydata"
  dropbox_folder <- paste(dropbox_dir, "CommunityAnalysis/Allometry", sep = "/")
  allometry_filename <- paste(
    data_dir, "/", format(Sys.time(),"%Y%m%d"), "_allometry_data.rds", sep = ""
    )
  
  # Welcome message
  cat("Updating allometry data sets...\n")
  
  # Try to get the latest version of the data from GitHub.
  # If there is no data (thereby generating an error), all XLS files are used.
  allometry_data <- try(
    datastorr::datastorr(repo = github_repo, refetch = TRUE),
    silent = TRUE)
  
  # Create list of XLS files in dropbox_dir
  allometry_files <- list.files(dropbox_folder, pattern = ".xls")
  
  # Use the list of files if new data has been released. Otherwise use only
  # the new files
  if(class(allometry_data) == "try-error"){
    new_files <- allometry_files
  } else {
    old_files <- unique(allometry_data$file)
    new_files <- allometry_files[!which(allometry_files %in% old_files)]
    
    # Exit if there are no new files
    if(length(new_files) == 0){
      cat("No new data found. Exiting update process.")
      return(invisible())
    }
  }

  # Import data from any files that are not already listed
  for(i in 1:length(new_files)){
    filename  <- new_files[i]
    file_path <- paste(dropbox_folder, filename, sep = "/")

    temp_data <- gdata::read.xls(file_path, sheet = 1, method = "csv",
                                 encoding = "UTF-8", stringsAsFactors = F,
                                 na.strings = c("", "NA"))

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

  # Update the existing data
  if(class(allometry_data) == "try-error"){
    final_data <- all_data
  } else{
    final_data <- rbind(allometry_data, all_data)
  }

  # Save data
  saveRDS(final_data, file = allometry_filename)
  
  # Completion message
  cat(paste("Data saved to", allometry_filename, "\n", sep = " "))

  # Return the updated dataset if desired
  if(return_data){
    return(final_data)
  } else {
    return(invisible())
  }
}
