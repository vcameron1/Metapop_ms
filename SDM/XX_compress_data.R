#==============================
# Compress data
# Marc 2022
# Victor Cameron
#==============================


# explana_dat
explana_dat <- data.table::fread("~/Documents/Git/Metapop_ms/SDM/explana_dat_df.csv")
#data.table::fwrite(explana_dat, "~/Documents/Git/Metapop_ms/SDM/explana_dat_df.csv.gz", row.names = FALSE, compress = "gzip")
saveRDS(explana_dat[,-"V1"], "~/Documents/Git/Metapop_ms/SDM/explana_dat_df.rds", compress = "bzip2")


# Projection data
# Load RCP45 projections
RCP45_2020_df <- data.table::fread("./SDM/RCP45_2020_df.csv")
RCP45_2040_df <- data.table::fread("./SDM/RCP45_2040_df.csv")
RCP45_2070_df <- data.table::fread("./SDM/RCP45_2070_df.csv")
RCP45_2100_df <- data.table::fread("./SDM/RCP45_2100_df.csv")
saveRDS(RCP45_2020_df[,-"V1"], "./SDM/RCP45_2020_df.rds", compress = "bzip2")
saveRDS(RCP45_2040_df[,-"V1"], "./SDM/RCP45_2040_df.rds", compress = "bzip2")
saveRDS(RCP45_2070_df[,-"V1"], "./SDM/RCP45_2070_df.rds", compress = "bzip2")
saveRDS(RCP45_2100_df[,-"V1"], "./SDM/RCP45_2100_df.rds", compress = "bzip2")
# save(RCP45_2020_df, RCP45_2040_df, RCP45_2070_df, RCP45_2100_df, "./SDM/RCP45_df.RData")

# Load Biomass data
biomass_2020_df <- data.table::fread("./SDM/biomass_2020_df.csv")
saveRDS(biomass_2020_df[,-"V1"], "./SDM/biomass_2020_df.rds", compress = "bzip2")
rm("biomass_2020_df")
biomass_2040_df <- data.table::fread("./SDM/biomass_2040_df.csv")
saveRDS(biomass_2040_df[,-"V1"], "./SDM/biomass_2040_df.rds", compress = "bzip2")
rm("biomass_2040_df")
biomass_2070_df <- data.table::fread("./SDM/biomass_2070_df.csv")
saveRDS(biomass_2070_df[,-"V1"], "./SDM/biomass_2070_df.rds", compress = "bzip2")
rm("biomass_2070_df")
biomass_2100_df <- data.table::fread("./SDM/biomass_2100_df.csv") 
saveRDS(biomass_2100_df[,-"V1"], "./SDM/biomass_2100_df.rds", compress = "bzip2")
rm("biomass_2100_df")

# saveRDS(biomass_2020_df,biomass_2040_df,biomass_2070_df,biomass_2100_df,"./SDM/biomass_df.RData")