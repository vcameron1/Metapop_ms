################################################
#    ---- Results download ----
# Victor Cameron
# August 21, 2023
################################################

#             ---- Set Up ----

# Local result file (specific to project)
localResFile <- 'SDM/results/BITH_metrics_QC.RDS'

# Check if local results exists
needDownload <- !file.exists(localResFile)

# Global Res URL
globalURL <- gsub('\"', '', gsub('results: \"', '', grep('results', readLines('metadata.yml'), value = T)))

# Download results only if necessary
if(needDownload)
{
  download.file(url = globalURL, destfile = localResFile, quiet = TRUE)
}