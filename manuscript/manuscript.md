---
title: Modelling distributions in rapidly changing environments using metapopulation models 
author: Victor Cameron, Dominique Gravel
---

**DG** il faudra un peu de fine tuning pour pimper l'intro
**DG** en discussion il faudra revenir sur les quelques études (courte revue de littérature) qui utilisent approche métapop. Revenir aussi sur le papier de Urban. 

## Introduction

*Expected environmental changes have motivated important advancements in distribution modelling.* 
Climate change has already prompted species to shift their range toward higher latitudes and elevations (@parmesan_ecological_2006, @chen_rapid_2011).
To protect ecosystems, we need to predict how species distributions and communities will be affected.
Commonly used models are most often statistical and based on the relationship between abiotic conditions and current species distribution (Urban 2016).
They present several limitations in their ability to model distribution dynamics while they mostly assume single species with restrictive assumptions for dispersal processes and present difficulties when extrapolated to novel environmental conditions.
Our current lack of knowledge and tools for the prediction of species distribution responses to environmental changes poses serious limitations to our predictive abilites.
While most current predictive approaches ignore important biological mechanisms such as demography, dispersal, and biotic interactions, these play key roles in species response to environmental change ().
In response, several calls have been made for models that incorporate the processes mediating species response (Fordham 2013, Urban 2016) and mechanistic approaches have been developped to increase the realism of projections.
Species' biology response to environmental variables make them more robust when extrapolated to novel conditions and outperform correlative approached by minimizing the predictions' uncertainty that accumulates over time. 
Recently developped mechanistic models already improve projections, but more work is required to increase accuracy and usability as they remain rarely used in conservation planning when compared to correlative SDMs (Guisan 2013).
The challenge now lies in the development of models that are i) customizable to the context of specific species and communities and ii) that integrate multiple processes and their interplay (Thuiller 2013, Urban 2016).
We believe that a strong theoretical background is necessary to guide the development of approaches in order to balance the complexity and tractability (Thuiller 2013).

**DG** : peut-être réduire un peu l'importance de la critique sur la simplicité des modèles pour détailler davantage la proposition de Urban. Conclure sur le défi que représente le développeemnt de tels modèles, et de comment gérer la complexité. La théorie peut être une façon pour guider ce développement (Thuiller2013)

*Review of some of the methods such as dynamic range models and forest gap models.*
In regards to recent efforts, explicit modelling of the processes that underlie distribution dynamics are challenging to implement (Hefley, 2017, Briscoe 2021).
Among approaches rooted in ecological theory, dynamic range models are successful at incorporating processes of demography and dispersal to improve the accuracy of species distribution projections (Briscoe 2021).
They are based on the niche theory, predicting species to occur in the landscape for environmental conditions where positive growth rates are observed (Hutchinson 1957, Godsoe 2017).
However, such models are often difficult to parameterize because measuring growth rate is challenging (McGill 2012), and require very specific data on species's biological response to abiotic conditions.
Indeed, on top of being computationally intensive (Snell 2014), the data required for these models are rarely available (Urban 2016).
Furthermore, we find in other situations that local demography its their own is insufficient to explain large-scale species distribution, suggesting that processes at larger scales must be considered (Le Squin 2021).
Such processes should include dispersal limitations, disturbances, biotic interactions, etc… (Urban 2016????, Stephan 2021).

**DG** : la transition vers le spatial est akward

*Another approach recently proposed is derived from metapopulation theory.*
Another approach recently proposed is derived from metapopulation theory.
Like dynamic range models, metapopulation models relate demography to the geographical distribution of the niche (Holt 2009) and equilibrium distributions are only limited by the availability of locally suitable environmental conditions.
By contrast, metapopulation models rest on the assumption that distributions result from the interaction of habitat availability, local extinction, and colonization dynamics (Holt 2000).
Indeed, distribution limits emerge and are shaped by a gradient in any of these three fundamental metapopulation processes (Holt 2000, talluto 2017).
Furthermore, these processes are not only fundamental to the definition of species distribution in a metapopulation context, but also to its dynamics. 
For example, species persistence to climate change may be affected by biotic and abiotic habitat suitability and its ability to occupy suitable habitat, such that distributions do not extend to all favorable abiotic environemntal conditions (@fordham_adapted_2013).
Within metapopulation models, changes in environmental conditions act on specie's demography and dispersal ultimately modulating species response (Svenning 2014), allowing the study of non-equilibrium dynamics of species distributions.
Recent studies have documented species distributions that do not match the distribution of their favorable climate.
For instance, metapopulation models have shown trees at the trailing edge of their distribution to persist a long time despite unfavorable climatic conditions as slow demography delays the extinction of populations.
At the leading edge, dispersal limitation prevent trees to colonize favorable habitats [@talluto_extinction_2017].
Metapopulation models capture processes of crutial importance from which emerge complex distribution dynamics.


*Metapopulation can easily be expanded to include more complexity, such as landscape heterogeneity and biotic interactions.*
We believe that metapopulation theory and its models may be an ideal framework for incoporating several elements of complexity to range dynamics such as landscape heterogeneity, dispersal and biotic interactions.

When studying distribution maps, one sees that most distributions are fragmented [COSEWIC, Box]. 
Spatially realistic metapopulation models have already been developped to deal with fragmentation by incorporating the spatial structure of a patch network [@hanski_metapopulation_1999, @ramiadantsoa_responses_2018].
Such models include the incidence function model, a stochastic patch model known for scaling extinction risk to patch area and colonization probability to immigration rates [@hanski_metapopulation_1999].
Increased extinction risk of populations in isolated distribution fragments is well supported by theory and empirical observations (MacArthur 1957, Schnell 2013, Huang 2019). 
Nontheless, metapopulation theory predicts that species can persist in fragmented landscapes given sufficient dispersal between patches [@hanski_metapopulation_2000].

Furthermore, biotic interactions are key processes in dristribution dynamics (Wisz 2013, Urban 2016), but have remained chalenging to model (Guilman 2010, Godsoe 2017).
In concordance to theory that predicts biotic interactions to affect the rate and extent of distribution changes through demography and dispersal (Svenning 2014), their effect can be implemented on colonization and extinction rates in metapopulation models [@box 1; @hanski_metapopulation_1999, @fordham_adapted_2013, @vissault_slow_2020].
For example, theoretical intuitions on the distribution dynamics of a simple two species metapopulation model are presented in Box 1. 

Metapopulation dynamics have mostly been studied under the conditions of equilibrium [@talluto_extinction_2017]. 
Distribution at equilibrium informs on ... and powerfull analytical tools ara available to solve the equilibrium state.
On the other hand, environmental changes happen progressively over time and species distributions frequently not match their niche. 
As changes can be slow or fast and gradual or sudden, modelisation of non-equilibrium dynamics by metapopulation models is essential in our understanding of the effect of environmental change on species distribution and of great importance for efficient conservation planning (Hanski&Simberloff1997, Boulangeat 2018, @vissault_slow_2020).

The study of distribution dynamics under rapid environmental change can be facilitated by the flexibility of the metapopulation approach to incorporate multiple processes.



**DG** ce qui suit commence à répéter le contenu plus haut. Je prendrais plutôt le temps d'énumérer une série d'arguments qui rendent l'approche métapop si intéressante. Intuition théorique (Box1). Outils analytiques. Peuvent être étudiés à l'équilibre et pour la transition. Focus d'abord sur la distribution (présecne-absence), on peut intégrer ensuite abondance dans approche hiérarchique. 

In this respect, metapopulation models are strongly rooted into theory [@talluto_extinction_2017].
For example, metapopulation models have shown that competition in Northestern-American forests may delay the response of warm adapted species to climate warming. 
Despite unfavorable conditions, long-lived boreal trees species could prevent the establishment of better adapted temperate species (Vissault 2020).
Conversely, a two species metapopulation model has shown that prey availability may influence Iberian lynx persistence. 
Trophic interactions affects habitat availability and extinction, thereby being of crutial importance in the context of climate change (Fordham 2013).
Therefore, the metapopulation approach allows for flexibility to include ecologically relevant factors in an ecologically intuitive manner.

 
*Objective of the paper. The purpose of this paper is to demonstrate the value of metapopulation model projections of distribution changes to support decision-making and policy in rapidly changing environments.*
**DG** merger ce paragraphe avec le précédent ?
**DG** annoncer un peu plus le contenu / organisation du texte qui va suivre. 

The metapopulation approach is a powerful and flexible tool to simulate distribution changes.
Resulting models can include demographic and dispersal constraints, and biotic interactions which previous approaches have not managed to do explicitly while remaining accessible.
Metapopulation models have the advantage of being parameterizable while being less data demanding than previous models (Vissault 2020) and remaining simple and rooted in ecological theory (Holt 2009).
Furthermore, the data needed to parameterize them is accessible now that time series of species occurrence are available for a broad range of species (Hanski ????, Fordham 2013, Talluto 2017, Vissault 2020).
The purpose of this paper is to demonstrate the value of the metapopulation approach to project distribution changes in rapidly changing environments.
We argue for the potential benefits of the metapopulation approach to improve accuracy of projections. 
Given the availability of data and the simplicity of the approach we see the advantage for decision-making and policy.

In this paper, we present a case study as a demonstration of application of the approach and then discuss sources of complexity in the observed distribution dynamics.
We used simulations to investigate changes in the distribution of a typical species of interest to conservation actors.
Our analyses were made using a forest composition state and transition model coupled to a metapopulation model of an habitat specialist bird, simulating a bottom-up system, where a mismatch between the resource distribution and climate warming is expected.
We simulated climate warming over a fragmented landscape and assessed distribution changes using presence-absences, abundances, and transiant dynamics.
Our simulations show that a metapopulation approach provides projections with 1) increased accuracy and realism for species of interest to policy and decision makers and 2) transitory dynamics.


*The model was inspired to simulate the Bicknell's thrush, a bird characteristic of species of interest to decision makers and policy (COSEWIC).*
**DG** Mettre emphase surtout sur les éléments qui rendent la grive intéressants : associé aux sommets de montagne, structure naturellement en patch. Dépendance au climat et à l'habitat. Espèce à statut précaire. 

The model was inspired to simulate the Bicknell's thrush, a threatened bird characteristic of species of interest to decision makers and policy (COSEWIC).
The Bicknell's thrush is found during its breeeding season on mountaintops doninated by dense coniferous forests and cool climate (COSEWIC, Cadieux 2019).
Unfavorable climatic conditions are predicted to increase at the edges of boreal forest patches with the warming of climate and the lag in boreal species response [BOX, COSEWIC, @vissault_slow_2020].
With preferences for habitats and specific climate requirements, the Bicknell's thrush is a good example of a species with a fragmented distribution structure.
As a result, its breeding range is highly restricted in Canada.
Climate change could therefore pose a major threat to the persistence of the Bicknell's thrush in Canada.
In the following sections, we demonstrate the ability of a coupled metapopulation model to project the Bicknell's thrush distribution in Northestern America and the forest response to different climate changes scenarios.



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

*Cette approche est intéressante, mais a déjà commencée à être explorée: revue de littérature*
Many studies have investigated distribution change using metapopulation theory [@fordham_adapted_2013,@Schnell_estimating_2013,@talluto_extinction_2017,@huang_using_2019], but much fewer to manage the complexity arising from biotic interactions and dispersal in context of rapid environmental change.
Some aspects have however been explored, starting with the development of the theoretical basis for metapopulation dynamics on heterogenous landscapes. 
Spatially realistic metapopulation theory has allowed modelling of distribution dynamics in species living in fragmented landscapes[@hanski_metapopulation_1998,@hanski_habitat_1999,@hanski_metapopulation_2000,@hanski_spatially_2001].
The coupling of spatially explicit metapopulation model with dynamic climate change represent a significant conceptual advancement toward increasingly realistic projections [@anderson_dynamics_2009].
The approach reveal distribution dynamics that other methods fail to capture, demonstrating the importance of moving toward approaches intergrating dynamic processes.
The simulation study of the Iberian lynx distribution is the first study to consider the interplay of climate change and trophic interactions using a metapopulation approach [@fordham_adapted_2013].
It showed that these factors could be explicitely considered together, exhibiting distribution dynamics of greater complexity and realism.
Moreover, the use of the metapopulation approach has made possible the study of non-equilibrium dynamics in species distributions by the scaling of local processes at the entire distribution [@talluto_extinction_2017].
Recently, the approach was extended to non-equilibrium dynamics of distribution shift in response to climate warming, highliting the role of competition while modeling only demography and dispersal [@vissault_slow_2020]. 
The metapopulation framework that we propose here builds on these previous developments to andvance toward simultaneously projecting changes in demography and dispersal in response to climate change and the multi-species effects of biotic interactions on the distribution of species.

The use of the metapopulation theory to inform conservation goes as far back as 1985 (Shaffer 1985) for species with patchy population structure and has since been further developed to account for specific spatial and population dynamics (Hanski&Simberloff1997, Fordham 2013, Huang 2020). 
In response to exploitation pressure from the logging compagnies and an extinction risk increasing rapidly, a spatially explicit metapopulation model was used to define the amount of prestine forest habitat needed to assure the survival of the northern spotted owl (*Strix occidentalis caurina*) in North-ouestern United-States (Shaffer 1985, Lamberson 1994).
More recently, the incidence function model (IFM) has been used to study the large scale population dynamics of the Glanville fritillary (*Meliteae cinxia*) who's distribution has shrunk in Europe to become highly fragmented.
The application of the IFM to the fritillary case study demonstrates the value of the metapopulation approach in describing the distribution dynamics of the species while being strongly rooted in theory and simple enough to be parameterized using available ecological data [@hanski_metapopulation_1999].

Metapopulation theory and models affect how conservation priorities are defined at a variety of scales.
The conservation of ecological corridors is the current focus of important initiatives worldwide [CorridorAppalachien,NCC,WesternWildwayNetworkPriorityCorridorProject] while habitat fragmentation is a criterion of threat for the IUCN Red List [IUCN].
Metapopulation theory predicts the scaling of extinction risk with increasing habitat isolation, something other non spatially explicit approaches do not do.
Equally, assisted colonization and habitat restoration are put forward as means to support species persistence by increasing respectively colonization rates and habitat availability [@Ricciardi_assisted_2009,@willis_assisted_2009,@fordham_adapted_2013].
Metapopulation theory main contribution to conservation ecology has been to direct attention on the effect of spatial configuration of the landscape on species persistence. 



Hanski --> théorie
Araujo (Nature climate change, proceeding B., Talluto, Steve, State occupancy models (voir ref steve))
Utilisation pour la conservation: nothern spotted howl (https://scholar.google.com/scholar?hl=fr&as_sdt=0%2C5&q=The+metapopulation+and+species+conservation%3A+the+special+case+of+the+northern+spotted+owl&btnG=)
Papillons (Hanski)
A des incidences sur comment on conserve (milieu de la conservation inspiré par l'approche: connectivité)

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
