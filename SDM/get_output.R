# Get data back from beluga
setwd('~/Documents/Git/Metapop_ms')

# Get files from "./SDM/results" folder
mainFolder = 'SDM/results'
if(!dir.exists(mainFolder)) dir.create(mainFolder)

  # # Get the data from remote host
  files <- paste0(c("modelPPspatial.RDS",
                    "modelPP.RDS",
                    "spatialModel.png",
                    "fullModel.png"), 
                    collapse = ',')

  # # Download files
  system(paste0('scp vcameron@beluga.calculcanada.ca:projects/def-dgravel/vcameron/Metapop_ms/', mainFolder, '/\\{',  files, "\\} ", " ./SDM/results/"))



