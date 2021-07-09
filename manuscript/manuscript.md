---
title: Modelling distributions in rapidly changing environments using metapopulation models 
author: Victor Cameron, Dominique Gravel
---

## Introduction

*Expected environmental changes have motivated important advancements in distribution modelling.* 
Climate change has already prompted species to shift their range toward higher latitudes and elevations (Parmesan 2006, Chen et al. 2011).
To protect ecosystems, we need to predict how species distributions and communities will be affected.
Commonly used models are most often statistical and based on the relationship between abiotic conditions and current species distribution.
They present several limitations in their ability to model distribution dynamics while they mostly assume single species with restrictive assumptions for dispersal processes.
More flexible, but similar models have been proposed to study the role of spatial and biotic sources of complexity in shaping species distributions (j-SDMs; Pollock et al. 2014, Warton 2015).
However, they lack grounding in theoretical ecology and present difficulties when extrapolated to new environmental conditions.
Our current lack of knowledge and tools for the prediction of species distribution responses to environmental changes poses serious limitations on the efficiency of future conservation actions.
While most current predictive approaches ignore important biological mechanisms, these mechanisms are known to play an important role in species distribution response to environmental change (Urban 2016).
More mechanistic approaches are required to project species distribution and several calls have been made for process-based models (Fordham 2013, Urban 2016).
While correlative SDMs are widely used in conservation planning (Guisan 2013), few process-based models are currently used in management of species under climate change.


*Review of some of the methods such as dynamic range models and forest gap models.*
In regards to recent efforts, explicit modelling of the processes that underlie distribution dynamics are challenging to implement (Hefley, 2017, Briscoe 2021).
Process-based models such as dynamic range models and forest gap models relate species abundances to abiotic environmental conditions using population growth rate and dispersal.
They have the advantage of being strongly rooted in ecological theory and take from niche theory in that environmental performance is driven by demographic rates, linking species distributions to population performance (Svenning 2014, Godsoe 2017).
However, these are often difficult to parameterize, data demanding both in quantity and quality, and computationally intensive (Snell 2014). 
Measuring growth rate is challenging (McGill 2012), and require very specific data on species response to abiotic conditions.
Indeed, the data required for these models are rarely available (Urban 2016).
Furthermore, we find in other situations that local dynamics are insufficient to explain large-scale species distribution (Le Squin 2021).
This suggests that processes at larger scales must be considered. 
Such processes should include dispersal limitations, disturbances, biotic interactions, etc… (Urban 2016????, Stephan 2021).


*Another approach recently proposed is derived from metapopulation theory.*
Another approach recently proposed is derived from metapopulation theory.
Like range dynamic models, metapopulation models relate demography to the geographical distribution of the niche (Holt 2009).
Both model families are mechanistic and share the advantage of not being limited by new environmental conditions.
In contrast to range dynamic models, metapopulation models rest on the assumption that distributions result from the interaction of habitat availability, local extinction, and colonization dynamics (Holt 1999).
Indeed, distribution limits emerge and are shaped by a gradient in any of these three fundamental metapopulation processes (Holt 2000, talluto 2017).
Furthermore, these processes are not only fundamental to the definition of species distribution in a metapopulation context, but also to its dynamics. 
For example, species persistence to climate change may be affected by biotic and abiotic habitat suitability and its ability to occupy suitable habitat, such that distributions do not extend to all favorable abiotic environemntal conditions (Fordham 2013).
Within metapopulation models, changes in environmental conditions act on specie's demography and dispersal ultimately modulating species response (Svenning 2014), allowing the study of non-equilibrium dynamics of species distributions.
Recent studies have documented species distributions that do not match the distribution of their favorable climate.
For instance, metapopulation models have shown trees at the trailing edge of their distribution to persist a long time despite unfavorable climatic conditions as slow demography delays the extinction of populations.
At the leading edge, dispersal limitation prevent trees to colonize favorable habitats (Talluto 2017).
Metapopulation models capture processes of crutial importance from which emerge complex distribution dynamics.


*Metapopulation can easily be expanded to include more complexity, such as landscape heterogeneity and biotic interactions.*
An approach based on metapopulation theory can easily be expanded to include more complexity, such as landscape heterogeneity and biotic interactions.
The framework is flexible as the effect of dispersal and mechanisms acting on demography are simultaneously taken into account in spatially explicit models.
These spatially explicit models can take habitat patch specific traits into account. 
For example, metapopulation incidence models are discrete-time stochastic models that take into account habitat patch size and connectivity to other patches to independently influence extinction and colonization processes, and distribution dynamics at the patch-specific level (Hanski 1999).
Distribution dynamics are also affected by biotic interactions (Wisz 2013).
However, biotic interactions have previously been chalenging to model (Guilman 2010, Godsoe 2017).
Theory predicts that biotic interactions affect the rate and extent of distribution changes through demography and dispersal (Svenning 2014).
In this respect, metapopulation models are strongly rooted into theory (Talluto 2017).
For example, metapopulation models have shown that competition in Northestern-American forests may delay the response of warm adapted species to climate warming. 
Despite unfavorable conditions, long-lived boreal trees species could prevent the establishment of better adapted temperate species (Vissault 2020).
Conversely, a two species metapopulation model has shown that prey availability may influence Iberian lynx persistence. 
Trophic interactions affects habitat availability and extinction, thereby being of crutial importance in the context of climate change (Fordham 2013).
Therefore, the metapopulation approach allows for flexibility to include ecologically relevant factors in an ecologically intuitive manner.

 
*Objective of the paper. The purpose of this paper is to demonstrate the value of metapopulation model projections of distribution changes to support decision-making and policy in rapidly changing environments.*
The metapopulation approach is a powerful and flexible tool to simulate distribution changes.
Resulting models can include demographic and dispersal constraints, and biotic interactions which previous approaches have not managed to do explicitly while remaining accessible.
Metapopulation models have the advantage of being parameterizable while being less data demanding than previous models (Vissault 2020) and remaining simple and rooted in ecological theory (Holt 2009).
Furthermore, the data needed to parameterize them is accessible now that time series of species occurrence are available for a broad range of species (Hanski ????, Fordham 2013, Talluto 2017, Vissault 2020).
The purpose of this paper is to demonstrate the value of the metapopulation approach to project distribution changes in rapidly changing environments.
We argue for the potential benefits of the metapopulation approach to improve accuracy of projections. 
Given the availability of data and the simplicity of the approach we see the advantage for decision-making and policy.
To demonstrate the approach, we investigated the changes in the distribution of a bottom-up system, where mismatch between resource distribution and climate warming is expected.


*The model was inspired to simulate the Bicknell's thrush, a bird characteristic of species of interest to decision makers and policy (COSEWIC).*
The model was inspired to simulate the Bicknell's thrush, a bird characteristic of species of interest to decision makers and policy (COSEWIC).
We assess distribution change using abundances and transiant dynamics (Boulangeat 2018).
We demonstrate the ability of a coupled metapopulation model to project the Bicknell's thrush distribution in Northestern America and the forest response to different climate changes scenarios.
The Bicknell's thrush breeding range is defined by cool climates, elevation and habitat type (COSEWIC, Cadieux 2019). 
This habitat specialist is found in a fragmented landscape composed of mountain tops dominated by stands of boreal forest, and connected through dispersal (COSEWIC 2009).


## Methods

### Model structure 
*We illustrate the applicability of the approach by expanding a metapopulation model to two species.*
Description verbable de la dynamique
Schémas ? (Box 2)
Description / inteprétation des probabilités de transition
	
### Parameterization 
*To simulate landscape-wide forest dynamics, we used a state and transition model (Vissault 2020).*
Dispersal kernels (vegetation, bird)
Vegetation transitions
Landscape structure

### Scenarios & analysis
*To project Bicknell's thrush distribution changes, we simulated forest successional dynamics and metapopulation dynamics under climate warming scenarios.*
Climate dependence of colonization and extinction

*We assessed distribution changes with measures of cumulative changes and their temporal trends.*

## Results


## Discussion

*Paragraphe 1. Our objective was to develop a tool relevant to decision-making and policy that can manage the complexity arising from biotic interactions and dispersal.*
Our study reveals that the extent of the response to climate warming is likely to be impacted by bottom-up interactions and landscape structure.
We derived three observations from metapopulation theory
	1. We found that a *mismatch* of the consumer and its favourable climate emerges as a property of the metapopulation approach. Using a metapopulation approach, we showed that climate warming could lead to a decrease in the environmental *correlation between trophic levels*.
	2. precipitation of the decline with habitat shrinking and connectivity
	3. importance of the correlation in the environmental response between trophic levels
inspired by a real case scenario, we have shown how theory could be relevant to decision-making and policy.
In this study, we did not consider a parametrized model for the Bicknell's thrush.

*Paragraph 2. habitat-abiotic mismatch*

*Paragraph 3. Metapopulation approach. Importance of connectivity. Mountain tops.*

*Paragraph 4. Importance of environmental correlation between trophic levels. We don’t really know that.*

*Paragraph 5. Although metapopulation models are easy to parameterize, they require species-specific colonization, extinction, and dispersal information.*

*Paragraph 6. Several other factors could also impact the system's reponse to climate warming.* Metapopulation models are very general and easy to expand. 
Can be generalized to other interactions (see e.g. Gravel and Massol for a very general model). 
More complex landscape structures. 

*Paragraph 7. Retour sur la grive.* 
We have shown that metapopulation models are tools of value for conservation practitionners.

## Figures

*??? Box 1. Cartoon representation of the various effects of climate change on landscape suitability*
Patch contraction
Patch extinction
dispersal limitation
Connectivity reduction

*Box 2. Integrating biotic interactions into metapopulation models.*
(Intuitions from metapopulation theory using differential equations of a simple bottom-up model, with corresponding figures)
	1. Conceptual representation of resource mismatch effect on consumer distribution shift.
	2. Non-linear response of occupancy with climate change in metapopulations versus the linear response of a standard SDM
	3. The effect of environmental change on lower trophic levels can propagate up and affect higher trophic levels. The effect of more favourable abiotic conditions to a top level species could be detrimental if the environment becomes less favourable for the lower trophic level. Figure : change in prevalence of a top species (color) as a function of the optimal temperature of the lower trophic level (x axis) and the higher trophic level (y axis). 


*Fig 2. Regional maps of initial and projected Bicknell's thrush distribution after 100 years of climate warming.*

*Fig 3. Projection of regional distribution change over 100 years of constant climate warming.*
