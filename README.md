# allometrydata

Allometry data storage for the BWG.

## Installation

```r
devtools::install_github("SrivastavaLab/allometrydata")
```

## Data Access

Allometry data can be accessed directly using this package.

Use `alldata()` to access the most recent version on GitHub.
`alldata_versions(local = FALSE)` will list the versions available online.
`alldata_versions(local = TRUE)` will list the versions available on your
computer.

See `?allometrydata::alldata()` for help.

## Data Update

Data may be updated by an administrator by connecting to your local Dropbox
folder: `CommunityAnalysis/Allometry`. The function `update_data` will
compile any new XLS files from the Allometry folder with the most recent version
of the data on GitHub. The dataset is saved locally and can be uploaded as a new
data release.