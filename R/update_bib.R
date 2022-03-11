################################################
#    ---- BibTeX Citation Organizer ----
# Will Vieira
# November 7, 2019
# Last update: May 12, 2020
# Adapted from Garrick Aden-Buie: <http://garrickadenbuie.com>
################################################


################################################
# Steps
#   - Set up
#   - Find citation keys in markdown document
#   - Compare document keys with those present in the local bib file
#   - Add missing citations to the local bib file if necessary
################################################



#             ---- Set Up ----

# Citation entries to keep, all others are skipped
keep <- c('author', 'title', 'journal', 'year', 'volume', 'number',
          'pages', 'month', 'editor', 'publisher', 'doi', 'url')

#args <- commandArgs(trailingOnly = TRUE)
#infile <- args[1]
infile <- 'manuscript/manuscript.md'

# Local bib file (specific to project)
localBibFile <- 'manuscript/references.bib'

# Check if local bib exists
bibAlready <- file.exists(localBibFile)

# Global bib URL
globalURL <- gsub('\"', '', gsub('bibliography: \"', '', grep('bibliography', readLines('metadata.yml'), value = T)))

#



#    ---- Find citation keys in markdown ----

stripCitekeys <- function(infile){
  indoc <- file(infile, open = 'r')
  cat(paste('Finding citations in:', infile, '\n'))
  citations <- c()
  count = 1
  for(line in readLines(indoc, warn = F)){
    count = count + 1
    if(stringr::str_detect(line, '@')) {
      candidate <- unlist(stringr::str_extract_all(line, "(?<=@)\\w+"))
      if(length(candidate) != 0){
        citations <- c(citations, candidate)
      }
    }
  }
  close(indoc)
  return(unique(citations))
}

citations <- stripCitekeys(infile)

# Remove known bug keys
toRemove <- c('fig', 'ref')
citations <- citations[!citations %in% toRemove]

#



#    ---- Compare document keys with those present in the local bib file ----

# First check if local bib is updated with manuscript
if(bibAlready)
{
  # get local keys
  localBib <- RefManageR::ReadBib(file = localBibFile)
  localKeys <- unlist(lapply(localBib, function(x) x[1]$key))
  
  # All cited keys are present in the local bib?
  needDownload <- !all(citations %in% localKeys)
  
}else
{
  needDownload <- TRUE
}

# Download global bib only if necessary
if(needDownload)
{
  # Set Master BibTeX file location
  tmp <- tempfile()
  download.file(url = globalURL, destfile = tmp, quiet = TRUE)
  globalBib <- suppressWarnings(RefManageR::ReadBib(file = tmp, check = FALSE))
  globalKeys <- unlist(lapply(globalBib, function(x) x[1]$key))
}
#



#    ---- Add missing citations to the local bib file if necessary ----

# If true, load it and add the missing references
if(bibAlready) {
  
  # test if it is necessary to update (remove a reference)
  toRemove <- localKeys[!(localKeys %in% citations)]
  if(length(toRemove) != 0)
  {
    cat('Removing', length(toRemove), 'references from the', localBibFile, 'file:\n', paste(toRemove, collapse = '\n'), '\n')
    localBib <- localBib[which(!(unlist(localBib$key) %in% toRemove))]
  }
  
  # test if it is necessary to update (add a reference)
  refsToAdd <- citations[which(!(citations %in% localKeys))]
  if(length(refsToAdd) != 0) {
    cat('Adding', length(refsToAdd), 'references to the', localBibFile, 'file:\n', paste(refsToAdd, collapse = '\n'), '\n')
    localBib <- c(localBib, globalBib[which(globalKeys %in% refsToAdd)])
    
    # Check for refs in document that are not in the global bib
    wrongKeys <- refsToAdd[!(refsToAdd %in% globalKeys)]
  }
  
  # save file
  RefManageR::WriteBib(localBib, file = localBibFile)      
  
}else { # Othewise just write a bibfile with the references
  
  cat('Creating bib file:', localBibFile, '\n')
  
  # get all references
  refsToAdd <- globalBib[which(globalKeys %in% citations)]
  if(length(refsToAdd) != 0) {
    cat('Adding', length(refsToAdd), 'references to the', localBibFile, 'file:\n',
        paste(refsToAdd, collapse = '\n'), '\n')
  }
  
  # save file
  RefManageR::WriteBib(refsToAdd, file = localBibFile)
  
}

#



#    ---- Extra work ----

# tell me if there's any wrong keyword (to  check)
if(exists('wrongKeys'))
{
  if(length(wrongKeys) > 0) {
    cat('These are the following keys I did not find on the main bibfile: \n',
        paste(wrongKeys, collapse = '\n'), '\n')
  }
}

#