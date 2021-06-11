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
# consumer: logical, whether the consumer is dependent on the resource or not

consumerOcc <- function(resOpt=0.5, consOpt=0.5, E=0.5, consumer=TRUE){
  
  # Test
  ## Normal distribution
  # E <- seq(0,1,le=100)
  # plot(dnorm(E, mean = resOpt, sd = 0.15), x=E) 
  # points(dnorm(E, mean = consOpt, sd = 0.5), x=E)
  ## Quadratic function
  #plot(1-4*(E-resOpt)^2, x=E, ylim=c(0,1))
  #points(1-4*(E-consOpt)^2, x=E, ylim=c(0,1))
  ## Absolute value function
  #points(y=1 - 2*abs(E - consOpt), x=E)

  
  # Resource prevalence (Pr=1-e/c)
  Pr <- 1-4*(E-resOpt)^2 # Quadratic function
    #dnorm(E, mean = resOpt, sd = 0.15) # Normal distribution
  
  # Consumer prevalence
  Pc <- #if(consumer){ Pr - (1 - (1 - 2*abs(E - consOpt)))}else{ 1 - 2*abs(E - consOpt)} # Absolute value function
    Pr - (1 - (1-4*(E-consOpt)^2)) # Quadratic function
    #Pr-(1-dnorm(E, mean = consOpt, sd = 0.15)) # Normal distribution
  
  # return
  return <- c('Pconsumer' = Pc)
  
  return(return)
}
