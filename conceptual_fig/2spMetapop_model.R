#### 
# title: Two sepcies metapopulation model
# This function computes the difference in performance (occupancy or prevalence) of a consumer for given start and final environmental values
# author: Victor Cameron
# date: 26/05/2021
####

####
# Params
# resOpt: Ressource environnemental optimum ([0,1])
# consOpt: Consumer environnemental optimum ([0,1])
# E: Environmental value at which to compute prevalence 
####

#### Model ####

# Two sepcies metapopulation
# This function computes the difference in performance (occupancy or prevalence) of a consumer for given start and final environmental values
# resOpt: Ressource environnemental optimum ([0,1])
# consOpt: Consumer environnemental optimum ([0,1])
# E: Environmental value at which to compute prevalence

consumerOcc <- function(resOpt=0.5, consOpt=0.5, E=0.5){
  
  # Test
  # E <- seq(0,1,le=100)
  # plot(dnorm(E, mean = resOpt, sd = 0.1)/3, x=E) # Normal distribution
  # points(Pc, x=E)
  # points(dnorm(E, mean = consOpt, sd = 0.15)/3, x=E)
  
  # Resource prevalence (Pr=1-e/c)
  Pr <- dnorm(E, mean = resOpt, sd = 0.5) 
  
  # Consumer prevalence
  Pc <- Pr-(1-dnorm(E, mean = consOpt, sd = 0.5)) 
  
  # return
  return <- c('Pconsumer' = Pc)
  
  return(return)
}