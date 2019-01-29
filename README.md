
<!-- README.md is generated from README.Rmd. Please edit that file -->
allometrydata
=============

Allometry data storage for the BWG.

Installation
------------

``` r
devtools::install_github("SrivastavaLab/allometrydata")
```

Data Access
-----------

Allometry data can be accessed directly using this package.

Access the most recent version on GitHub.

``` r
allometrydata::alldata()
```

List the versions available online:

``` r
allometrydata::alldata_versions(local = FALSE)
#> [1] "v.0.0.0.9000"
```

List the versions available on your computer:

``` r
allometrydata::alldata_versions()
#> [1] "v.0.0.0.9000"
```

For help:

``` r
?allometrydata::alldata()
```

Data Versions
-------------

See [releases](https://github.com/SrivastavaLab/allometrydata/releases) for the most recent versions of the data.

Data Update
-----------

Data may be updated by an administrator by connecting to your local Dropbox folder: `CommunityAnalysis/Allometry`. The function `update_data` will compile any new XLS files from the Allometry folder with the most recent version of the data on GitHub. The dataset is saved locally and can be uploaded as a new data release.

Data updates keep the original data largely as is, with a few exceptions:

1.  Only the following expected columns are retained: `bwg_name`, `name`, `length_mm`, `wet_mass_mg`, `dry_mass_mg`, `length_measured_as`, `number_of_individuals`, `stage`, `size_category`, `instar_number`
2.  Two columns are added to better describe the data. `file` gives the filename from which the line of data came. `type` distinguishes between measurements gathered in the field (`field_measurement`) and entries used to define a size category by giving a corresponding length (`category_definition`). Notably, data that fall into the `category_definition` type do not include biomass measurements as they do not represent an actual measurement.
3.  Any blanks are converted to `NA`
