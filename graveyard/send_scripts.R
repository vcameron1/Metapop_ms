###########
# Save scripts to Beluga
# Victor Cameron
# August 2021
##########

# Files to send from data folder
filesData <- paste0(c("./data_clean/bioclim_sQ.RDS", "./data_clean/elev_sQ.RDS", "./data_clean/forestCover_sQ.RDS"), collapse=' ')
system(paste0('scp ', filesData, ' vcameron@beluga.calculcanada.ca:projects/def-dgravel/vcameron/Metapop_ms/data_clean/'))

# Files to send from SDM folder
filesSDM <- paste0(c("./SDM/GRBI_SDM.sh", "./SDM/GRBI_mapSpecies.R"), collapse=' ')
system(paste0('scp ', filesSDM, ' vcameron@beluga.calculcanada.ca:projects/def-dgravel/vcameron/Metapop_ms/SDM/'))

# Files to send from mapSpecies folder
dirmapSpecies <- list.dirs("./mapSpecies", full.names = TRUE, recursive = F)
filesmapSpecies <- list.files("./mapSpecies", full.names = TRUE)
filesmapSpecies <- paste0(filesmapSpecies[!filesmapSpecies %in% dirmapSpecies], collapse=' ')
system(paste0('scp ', filesmapSpecies, ' vcameron@beluga.calculcanada.ca:projects/def-dgravel/vcameron/Metapop_ms/mapSpecies/'))

filesdata <- paste0(list.files("./mapSpecies/data", full.names = TRUE), collapse=' ')
system(paste0('scp ', filesdata, ' vcameron@beluga.calculcanada.ca:projects/def-dgravel/vcameron/Metapop_ms/mapSpecies/data'))

filesman <- paste0(list.files("./mapSpecies/man", full.names = TRUE), collapse=' ')
system(paste0('scp ', filesman, ' vcameron@beluga.calculcanada.ca:projects/def-dgravel/vcameron/Metapop_ms/mapSpecies/man'))

filesr <- paste0(list.files("./mapSpecies/r", full.names = TRUE), collapse=' ')
system(paste0('scp ', filesr, ' vcameron@beluga.calculcanada.ca:projects/def-dgravel/vcameron/Metapop_ms/mapSpecies/r'))

filesvignettes <- paste0(list.files("./mapSpecies/vignettes", full.names = TRUE), collapse=' ')
system(paste0('scp ', filesvignettes, ' vcameron@beluga.calculcanada.ca:projects/def-dgravel/vcameron/Metapop_ms/mapSpecies/vignettes'))
