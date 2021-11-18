**DG** il faudra un peu de fine tuning pour pimper l'intro
**DG** en discussion il faudra revenir sur les quelques études [courte revue de littérature] qui utilisent approche métapop. Revenir aussi sur le papier de Urban. 

## Introduction

*Expected environmental changes have motivated important advancements in distribution modelling.*\
Climate change has already prompted species to shift their range toward higher latitudes and elevations [@parmesan_ecological_2006;@chen_rapid_2011].
The ability of species to shift their distribution in response to climate change may determine if they will persist.
Prediction of distribution change as climate warms will inform us how to effectively conserve species at risk of extinction.
Commonly used models are most often statistical and based on the relationship between abiotic conditions and current species distribution [@urban_improving_2016].
They present several limitations in their ability to model distribution dynamics while they mostly assume single species with restrictive assumptions for dispersal processes and present difficulties when extrapolated to novel environmental conditions.
Our current lack of knowledge and tools for the prediction of species distribution responses to environmental changes poses serious limitations to our predictive abilites.
While most current predictive approaches ignore important biological mechanisms such as demography, dispersal, and biotic interactions, these play key roles in species response to environmental change [].
In response, several calls have been made for models that incorporate the processes mediating species response [@fordham_adapted_2013;@urban_improving_2016] and mechanistic approaches have been developped to improve the realism of projections.
Species' biology response to environmental variables make them more robust when extrapolated to novel conditions and outperform correlative approaches by minimizing the predictions' uncertainty that accumulates over time. 
Recently developped mechanistic models already improve projections, but more work is required to increase accuracy and usability as they remain rarely employed in conservation planning when compared to correlative SDMs [guisan__2013].
The challenge now lies in the development of models that are i] customizable to the context of specific species and communities and ii] that integrate multiple processes and their interplay [@thuiller_road_2013;@urban_improving_2016].
We believe that a strong theoretical background is necessary to guide the development of approaches in order to balance the complexity and tractability [@thuiller_road_2013].

**DG** : peut-être réduire un peu l'importance de la critique sur la simplicité des modèles pour détailler davantage la proposition de Urban. Conclure sur le défi que représente le développeemnt de tels modèles, et de comment gérer la complexité. La théorie peut être une façon pour guider ce développement [Thuiller2013]

*Review of some of the methods such as dynamic range models and forest gap models.*\
In regards to recent efforts, explicit modelling of the processes that underlie distribution dynamics are challenging to implement [@hefley_when_2017;@briscoe_can_2021].
Among approaches rooted in ecological theory, dynamic range models are successful at incorporating processes of demography and dispersal to improve the accuracy of species distribution projections [@briscoe_can_2021].
They are based on the niche theory, predicting species to occur in the landscape for environmental conditions where positive growth rates are observed [@hutchinson_concludig_1957;@godsoe_integrating_2017].
However, such models are often difficult to parameterize because measuring growth rate is challenging [McGill 2012], and require very specific data on species's biological response to abiotic conditions.
Indeed, on top of being computationally intensive [@snell_using_2014], the data required for these models are rarely available [@urban_improving_2016].
Furthermore, we find in other situations that local demography on its own is insufficient to explain large-scale species distribution, suggesting that processes at larger scales must be considered [@le_squin_climateinduced_2021].
Such processes may include dispersal limitations, disturbances, and biotic interactions [@urban_improving_2016;@stephan_positive_2021].

**DG** : la transition vers le spatial est akward

*Another approach recently proposed is derived from metapopulation theory.*\
Another approach recently proposed is derived from metapopulation theory.
Like dynamic range models, metapopulation models relate demography to the geographical distribution of the niche [@holt_trophic_2009] and equilibrium distributions are only limited by the availability of locally suitable environmental conditions.
By contrast, metapopulation models rest on the assumption that distributions result from the interaction of habitat availability, local extinction, and colonization dynamics [@hanski_metapopulation_2000].
Indeed, distribution limits emerge and are shaped by a gradient in any of these three fundamental metapopulation processes [@hanski_metapopulation_2000;@talluto_extinction_2017].
Furthermore, these processes are not only fundamental to the definition of species distribution in a metapopulation context, but also to its dynamics. 
Species persistence to climate change may be affected by biotic and abiotic habitat suitability and its ability to occupy suitable habitat, such that distributions do not extend to all favorable abiotic environemntal conditions [@fordham_adapted_2013].
Within metapopulation models, changes in environmental conditions act on specie's demography and dispersal ultimately modulating species response [@svenning_influence_2014], allowing the study of non-equilibrium dynamics of species distributions.
Recent studies have documented species distributions that do not match the distribution of their favorable climate and that present extinction debts and colonization credits [@savage_elevational_2015;@talluto_extinction_2017].
For instance, metapopulation models have shown trees at the trailing edge of their distribution to persist a long time despite unfavorable climatic conditions as slow demography delays the extinction of populations.
At the leading edge, dispersal limitation prevent trees to colonize favorable habitats [@talluto_extinction_2017].
Metapopulation models capture processes of crutial importance from which emerge complex distribution dynamics.


*Metapopulation can easily be expanded to include more complexity, such as landscape heterogeneity and biotic interactions.*\
We believe that metapopulation theory and its models may be an ideal framework for incoporating several elements of complexity to range dynamics such as landscape heterogeneity, dispersal and biotic interactions.

When studying distribution maps, one sees that most distributions are fragmented [COSEWIC;Box]. 
Spatially realistic metapopulation models have already been developped to deal with fragmentation by incorporating the spatial structure of a patch network [@hanski_metapopulation_1999;@ramiadantsoa_responses_2018].
Such models include the incidence function model, a stochastic patch model known for scaling extinction risk to patch area and colonization probability to immigration rates [@hanski_metapopulation_1999].
Increased extinction risk of populations in isolated distribution fragments is well supported by theory and empirical observations [MacArthur1957,@schnell_estimating_2013,@huang_using_2019]. 
Nontheless, metapopulation theory predicts that species can persist in fragmented landscapes given sufficient dispersal between patches [@hanski_metapopulation_2000].

Furthermore, biotic interactions are key processes in dristribution dynamics [@wisz_role_2013;@urban_improving_2016], but have remained chalenging to model [Guilman_2010;@godsoe_integrating_2017].
In concordance to theory that predicts biotic interactions to affect the rate and extent of distribution changes through demography and dispersal [@svenning_disequilibrium_2013], their effect can be implemented on colonization and extinction rates in metapopulation models [box1;@hanski_metapopulation_1999;@fordham_adapted_2013;@vissault_slow_2020].
For example, theoretical intuitions on the distribution dynamics of a simple two species metapopulation model are presented in Box 1. 

Metapopulation dynamics have mostly been studied under the conditions of equilibrium [@talluto_extinction_2017]. 
Distribution at equilibrium informs on ... and powerfull analytical tools are available to solve the equilibrium state.
On the other hand, environmental changes happen progressively over time and species distributions frequently not match their niche. 

As changes can be slow or fast and gradual or sudden, modelisation of non-equilibrium dynamics by metapopulation models is essential in our understanding of the effect of environmental change on species distribution and of great importance for efficient conservation planning [@hanski_metapopulation_1997,@ovaskainen_transient_2002].
It is especially marked in plants that are limited by slow demography and restricted dispersal [@svenning_disequilibrium_2013;@savage_elevational_2015;@talluto_extinction_2017;@vissault_slow_2020].

The study of distribution dynamics under rapid environmental change can be facilitated by the flexibility of the metapopulation approach to incorporate multiple processes.



**DG** ce qui suit commence à répéter le contenu plus haut. Je prendrais plutôt le temps d'énumérer une série d'arguments qui rendent l'approche métapop si intéressante. Intuition théorique [Box1]. Outils analytiques. Peuvent être étudiés à l'équilibre et pour la transition. Focus d'abord sur la distribution [présecne-absence], on peut intégrer ensuite abondance dans approche hiérarchique. 


 
*Objective of the paper. The purpose of this paper is to demonstrate the value of metapopulation model projections of distribution changes to support decision-making and policy in rapidly changing environments.*\
**DG** merger ce paragraphe avec le précédent ?
**DG** annoncer un peu plus le contenu / organisation du texte qui va suivre. 

The metapopulation approach is a powerful and flexible tool to simulate distribution changes.
Resulting models can include demographic and dispersal constraints, and biotic interactions which previous approaches have not managed to do explicitly while remaining accessible.
Metapopulation models have the advantage of being parameterizable while being less data demanding than previous models and remaining simple and rooted in ecological theory [@holt_bringing_2009;@vissault_slow_2020].
Furthermore, the data needed to parameterize them is accessible now that time series of species occurrence are available for a broad range of species [Hanski????;@fordham_adapted_2013;@talluto_extinction_2017;@vissault_slow_2020].
The purpose of this paper is to demonstrate the value of the metapopulation approach to project distribution changes in rapidly changing environments.
We argue for the potential benefits of the metapopulation approach to improve accuracy of projections. 
Given the availability of data and the simplicity of the approach we see the advantage for decision-making and policy.

In this paper, we aimed to provide a compeling example for how biodiversity actors interested in projections of distribution change may beneficiate from metapopulation theory.
A case study provides an example of sources of complexity in the resulting distribution dynamics.
We used projections from a SDM to investigate changes in the distribution of a typical species of interest to conservation actors.
Our analyses were made using cimate warming and forest composition change scenarios for a habitat specialist bird, simulating a bottom-up system, where a mismatch between the resource and climate distribution is expected.
We simulated climate warming over a fragmented landscape and assessed distribution changes using measures of patch area and landscape spatial arrangement.
Our results show that a metapopulation approach can project distribution changes with increased accuracy and realism for species of interest to policy and decision makers.


*The model was inspired to simulate the Bicknell's thrush, a bird characteristic of species of interest to decision makers and policy [COSEWIC].*\
**DG** Mettre emphase surtout sur les éléments qui rendent la grive intéressants : associé aux sommets de montagne, structure naturellement en patch. Dépendance au climat et à l'habitat. Espèce à statut précaire. 

The model was inspired by the Bicknell's thrush, a threatened bird characteristic of species of interest to decision makers and policy [COSEWIC].
The Bicknell's thrush is know to be associated with perturbed, dense fir forests, mostly at high elevations, resulting in a fragmented and highly restricted distribution in Canada [@cadieux_spatially_2019].
Unfavorable climatic conditions are predicted to increase at the edges of mountaintops fir forest patches with the warming of climate and the limited response capacity of boreal tree species [BOX, COSEWIC, @vissault_slow_2020].
Climate change could therefore pose a major threat to the persistence of the Bicknell's thrush in Canada.
In the following sections, we demonstrate the added value of the metapopulation approach to project the Bicknell's thrush distribution in Canada.



## Methods

### Studied region

*The Bicknell's thrush breeding range was projected for the region where the majority of its habitat is identified*\
The Bicknell's thrush breeding range was projected for the region where the majority of the canadian occurences are identified [cosewic].
Populations were primarily found in the province of Québec, in the regions of the Eastern Townships, Gaspésie, and Réserve faunique des Laurentides [fig. 1].
The landcape is characterized by a mix of boreal, mixed and temperate tree species driven by important latitudinal and elevational gradients in climate.
Abundance of fir increases in prevalence with altitude and latitude.
Mean annual temperatures ranges from -3.8 to 7°C and mean annual precipitations from 793 to 1735 mm [SOURCE].
climate data were interpolated from climate station records for the 1981-2010 period to produce a time series of annual means using BioSim [https://cfs.nrcan.gc.ca/projects/133] [McKenney 2013?!?].
Data on elevation was gathered using the elevatr R package [SOURCE] and maxed at 1535m.
All data were rasterized at a 250m2 resolution. 

### Bicknell's thrush breeding range

We estimated the number of observation per 250m2 (intensity) of Bicknell's thrush using downweighted poisson regression [@renner_point_2015]. 
We modeled observation reccords and speudo absences as a function of climate, elevation, and forest habitat composition (weighted_presence_and_pseudoAbsences ~ mean_annual_temperature * mean_annual_temperature^2 * mean_annual_precipitations + elevation + fir_biomass * fir_proportional_biomass).
We randomly positioned pseudo absences to cover most environmental variability such to maximize the accuracy of the likelihood estimation [@renner_point_2015].
Mean annual temperature (-16.04) and precipitations (-0.0014), elevation (-0.017), and proportional fir biomass (3.51) are strongly associated with Bicknell's thrush breeding range.
The quadratic temperature term is significantly negative (-0.67), consistent with expert expectations [COSEWIC].
The model shows a decrease in Bicknell's thrush intensity at low elevation of the southern end and at the northern end of its distribution area.

*We defined the extent of the breeding range using these maps along ith a threshold of one individual per square kilometer which was the value that yielded the best match between predictions and observations according to AUC measures.*

### Data


<!----
*The Bicknell's thrush breeding range was modeled using a downweighted poisson regression in combination with unpublished data of CDPNQ*\
The Bicknell's thrush breeding range was modeled using a downweighted poisson regression adapted from @renner_point_2015 in combination with unpublished data of the Centre de données sur le patrimoine naturel du Québec [@sos-pop_banque_2021].
The dataset consisted of 6079 observations of nidification behaviours between 1994 and 2020.
We rasterized occurences on a 250m2 square grid to remove any potential effects of temporal and spatial speudo replication to obtain a observed-not observed map.
We defined 5,000,000 pseudo absences - corresponding to the computational limit imposed by the algorithm - randomly distributed accross the landscape [@renner_point_2015] and set weights to some small values at presence locations and to large values to the area of the study region divided by the number of points at pseudo absences locations [@renner_point_2015].
The model returned intensity maps corresponding to the limiting expected number of presence points per unit area [abundance per 250m^2 cell].
We defined the extent of the breeding range using these maps along ith a threshold of one individual per square kilometer which was the value that yielded the best match between predictions and observations according to AUC measures.

*The model was designed using expert knowledge on habitat and climatic niche characteristics and identified a temperature threshold that interacts with elevation*\
We defined the model using expert knowledge of the Bicknell's thrush to capture its main habitat and climate requirements.
we used the interaction between fir biomass and proportional biomass as well as elevation to capture the preference for dense and disturbed forests characterized by dense fir stands.
Climate preference was represented using the interaction between mean annual temperature and precipitations.


- habitat: High elevation, coastal or boreal
- Disturbed habitat: Dense boreal [coniferous] forests
	- Habitat characterized by: forest type, forest density, and forest height
- Interaction between elevation and MAT and MAP
	- Population densities generally increase with elevation in adequate forest stands [cosewic2009]
- [Intensity ~ MAT * MAP * Elevation + forest type + forest density + forest height]
- Model coefficients summary
	- Intensity increased with elevation. 
	- Temperature had positive effect up to optimum then decrease predicted intensities


### Data

--->

### Scenario and analyses

*To estimate the impacts of climate warming on Bicknell's thrush breeding range, we projected it for increasing climate temperatures where the habitat remained fixed*\
- Temperature increased from current to +4°C [would corresponds to RCP ...]
- lag in boreal species response [BOX, COSEWIC, @vissault_slow_2020]
- **Uncertainty** ... ran X projections ?!?

*Analyses were conducted for Québec and for two subregions of interest to metapopulation dynamics*\
Analyses were conducted separately for the region of Québec as well as two subregions.
The Réserve faunique des Laurentides is mountenous, being part of Laurentians mountain chain, and is part of the boreal forest.
It is at the northern edge of the Bicknell's thrush distribution, but has a high concentration of populations.
The Eastern Townships is situated in the southern most part of Québec where the dominating forest habitat type is temperate forest. 
The landscape is characterized by the presence of the Appalachian mountain chain and the monteregiennes mountains creating a highly fragmented landscape for the bicknell's thrush.

*We defined the extent of bicknell's thrush breeding range using an arbritrary intensity threshold of 0.05.*\
We defined the extent of bicknell's thrush breeding range using the gridded intensity maps returned by the model. 
We converted intensities to breeding range distributions by seting distribution limits using an arbritrary intensity threshold of 0.05.
Individual habitat patches within the breeding range were defined as the ensembles of the immediate neighbouring cells.

*We assessed changes in the distribution of the breeding range with measures of temporal [°C] trends in ...suitable... variables for each climate scenaro: i] n, ii] area, and iii] distance*\
Changes to the breeding range and habitat distribution were assessed using the "raster" package.
We determined the number of populations, the population sizes and the connectivity of the landscape using measures of the number of patches, the areas of patches [km2], and the inter-patch distances [km].
Under initial conditions, Québec region contained 3954 patches in the Bicknell's thrush breeding range and **XXX** patches in its habitat map, the Réserve faunique des Laurentides 2295 and **XXX**, and the Eastern Townships 44 and **XXX**.
Patch area varied from 0.04km2 to 2029.95km2 in the breeding range and **XXX**km2 to **XXX**km2 in its habitat map while interpatch distances varied from 0.002km to 9.964km


*To quantify the habitat-climate mismatch [correlation between forest and climate distribution].*\


*We evaluated the effects of change in the distribution of the breeding range on the Bicknell's thrush metapopulation dynamics [metapop effect] using metapopulation capacity*\
We evaluated changes in landscape connectivity using the metapopulation capacity.
Metapopulation capacity measures persistence of the metapopulation given the spatial configuration of the landscape by integrating effects of dispersal, patch areas and inter-patch distances [@hanski_metapopulation_2000].
Dispersal was modeled as a decreasing exponential function evaluated for a range of average dispersal distances.


### R code availability

We performed all analyses in the R programming language [@r_core_team_r_2021] and provided all scripts to process the data and to run the analyses openly available in the github repository <https://github.com/vcameron1/Metapop_ms>.

<!----
### Model structure 
*We illustrate the applicability of the approach by expanding a metapopulation model to two species.*
We illustrate the applicability of the approach by expanding a metapopulation model to two species.
We formulate a spatially explicit metapopulation model in which we have the focal species be dependent on climatic conditions and forest dynamics [@ovaskainen_transient_2001].
We represented the landscape as a grid of square cells that we hereafter refer to as patches or habitat patches.
Each patch is caracterized by a type of forest habitat of either temperate, mixed, boreal, or regeneration state and climate conditions [@vissault_slow_2020;will].
The model describes transitions between forest states and the Bicknell's thrush occupancy state in local habitat patches on 5 years time steps.
Transitions from one state to another are determined by colonization and extinction probabilities.
Empty boreal forest patch may become occupied by the Bicknell's thrush if colonists from neighbouring populations reach the patch and establish. 
These are stochastic functions of the number of neighbouring populations and their size [climate suitability], the interpatch distance, and the propagule pressure.
Until environmental conditions become unfavorable or a stochastic extinction event occurs, the Bicknell's thrush may remain present in a patch.
It may go extinct if the forest state changes due to establishment of temperate species, if the climate conditions become unsuitable, or if a stochastic disturbance occurs.

We define $X_{t}$, a stochastic variable that represents the occurrence of the Bicknell's thrush at time $t$ and summarize the entire model as a probability function:

$$
P[X_{t+1} | X_{t}, A, N, B]
$$

Where the probability of occurrence is influenced by the patch occupancy state at the previous time step [$X_{t}$], climatic conditions [$A$], the species prevalence in the landscape [$N$], and the forest state [$B$].
For a patch to be occupied, it either must have been occupied previously and not gone extinct or have been empty and got colonized: 

$$
P[X_{i,t+1} = 1] = 1 - P[X_{i,t+1} = 0|X_{i,t} = 1]P[X_{i,t} = 1] + P[X_{i,t+1} = 1|X_{i,t} = 0]P[X_{i,t} = 0]
$$

The probability of an occupied patch to go extinct is given by:

$$
P[X_{i,t+1} = 0|X_{i,t} = 1] = \frac{e}{A_{i} B_{i}}
$$

Where $A_{i}$ is the climate suitability of patch $i$, $B_{i}$ the habitat state in patch $i$, and e is a constant. We make the assumption that more favorable climatic conditions increases suitability of patches - environmental performance - which tend to hold larger populations and that larger populations have decreased extinction risk [brown_1984,@talluto_extinction_2017,@osorioolvera_population_2019].

Colonization probability follows a decreasing exponential function and is the sum of the distances between patches $i$ and $j$, and the average migration distance $1/\alpha$, multiplied by climate environmental performance, habitat type and presence at previous time step:

$$
P[X_{i,t+1} = 1|X_{i,t} = 0] = \sum{[- \alpha d_{ij}] X_{j} A_{j} A_{i} B_{i}}
$$

The propagule pressure of patch $i$ increases with the number of neighbouring populations, the size of population [climate suitability], and decreasing distance.




Description verbable de la dynamique
Schémas ? [Box 2]
Description / inteprétation des probabilités de transition
	
### Parameterization 
*To simulate landscape-wide forest dynamics, we used a state and transition model [Vissault 2020].*
Artificial Landscape [elevational gradient], cell size
Dispersal kernels [vegetation, bird]
Vegetation transitions: We track the state of the forest in patches.
Landscape structure: landscape devided in a lattice of identical cells/patches

*Sources of data*

### Scenarios & analysis
*To project Bicknell's thrush distribution changes, we simulated forest successional dynamics and metapopulation dynamics under climate warming scenarios.*
Climate dependence of colonization and extinction

Following initial equilibrium state, we simulated increasing temperatures in habitat patches as constant increments over 100 years. 
The total warming followed an intermediate scenario with increases of 0.09°C at each time step for 20 time steps [RCP4.5;IPCC2013].


*We assessed distribution changes with measures of cumulative changes and their temporal trends.*
Although it is possible to get a basic understanding of distribution changes through equilibrium distributions alone, temporal trends or transient phases caracterize the actual dynamics of the Bicknell's thrush response and are crutial for biodiversity conservation [@boulangeat_transient_2018].
Distribution shifts and abundance declines from climate warming are often gradual and cause species' distributions to be out of equilibrium with their niche distribution.
We assessed distribution changes with measures of cumulative changes and their temporal trends.
In addition to distribution maps, we present 3 metrics relevant to decision making and policy: prevalence, distribution extent, and **metapopulation capacity** [@hanski_metapopulation_2000;@huang_using_2019].
Prevalence is the proportion of patches occupied by the Bicknell's thrush in the landscape and captures the effective metapopulation size. 
Distribution extent is a measure of the realized niche breadth and is the range of **temperatures** at which it is present.
Metapopulation capacity measures directly the extinction risk through its relation with the extinction threshold fixed by the ratio of extinction to colonization rates [@hanski_metapopulation_2000].
It captures the effect of the landscape spatial structure as it is percieved by the species on the landscape's ability to support a persisting metapopulation.
--->

## Results

### Impacts of climate warming on Bicknell's thrush breeding range

Climate warming had a strong effect on Bicknell's thrush breeding range within all studied regions [Fig. 1]. 
Although intense warming had severe negative effects, this pattern was not apparent in all regions for moderate warming [Fig. 2].
The directionality and extent of change varied with latitude and extent of warming.

*Our results show a general decline in the number of patches following climate warming [Fig. 2].*\
Climate warming induced a general decline in the number of patches within the Bicknell's thrush breeding range [Fig. 2].
The rate of decline was most important at first where fifty or more percent of the patches of all regions were lost within the first 1.5°C increase in temperature, but declined with further warming.
All of the breeding range within the Estern Townships diseappeared after 2.6°C increase in temperature.

*Increase in abitat amount was observed for low to intermediate levels of climate warming [0 to +1°C], but severe decreases were observed for greater important climate warming*\
A large proportion of patches and habitat amount in Québec are within the Réserve faunique des Laurentides.
The dynamics of the later has important effects on the first.
We observed a significant increase of habitat amount in both Québec and in the Réserve faunique des Laurentides for the first degree of warming and then a gradual acceleration of habitat amount loss.
Dynamics in the Eastern townships were different, where warming immediately lead to rapid loss of habitat amount. 

*Density distribution of patch area show little change for a temperature increase of +2°C*\
The Bicknell's thrush breeding range within all regions was mainly comprized of small sized patches [<1 km2] with very few large patches [>50km2, Fig. 2].
Despite important changes in the number of patches and the habitat amount for all reagions, a 2°C increase in temperature showed little effect over the density distribution of patch area where the proportion of small, to meadium, to large patches remained mostly constant.
Changes to the area distributions were greater after 4 degrees of warming with a decrease in the proportion of very small patches [<1km2>] and the increase of slightly larger patches [~1km2].

*Climate warming reduces the proportion occupied by large inter-patch distance*\
Warming-induced changes to the distribution of inter-patch distance show a decrease in the longest distances which can be attributable to the general loss of patches.
Smaller interpatch distances increased in proportion in all regions and effects increased with the severity of the warming.


### Effect of temperature warming on habitat and climate distribution [Mismatch]

*habitat [suitable] moving toward boreal forest, leaving behind M and T*\


### Cumulative impacts of habitat amount and connectivity

*Loss in capacity is precipitated by loss of landscape connectivity*\
Habitat amount varied importantly under climate warming scenario [Fig. 3]. 
We observed for a range of short and long dispersal distances both important change and constance to the metapopulation capacity [metapopulation persistence] in response to variation in habitat amount.
The effect of habitat amount on metapopulation capacity differed depending on the region and the severity of the climate warming. 
Changes in habitat amount in the region of Québec and in the Eastern Townships lead to an amplified response of amplitude of the capacity where dispersal distances increased sensitivity of the capacity response.
In opposition, metapopulation capacity did not vary significantly with habitat amount in the Réserve faunique des Laurentides under 2.6°C increase in temperature and the change in capacity was of lesser amplitude for greater dispersal distances.
Changes to the connectivity within regions showed different dynamics between Québec and the Réserve faunique des Laurentides while habitat amount variation were similar [Fig. 3]. 

- Changes in habitat availability are amplified in capacity
- Weird: M area increases, but not connectivity
- ET area amount and capacity decreases sharply
- Increase in habitat amount in QC causes spikes in capacity
- Increases in habitat amount has most effect on capacity for greater dispersal distance [connectivity]


## Discussion

*Paragraphe 1. Our objective was to develop a tool relevant to decision-making and policy that can manage the complexity arising from biotic interactions and dispersal.*\
Our study reveals that the extent of the response to climate warming is likely to be impacted by bottom-up interactions and landscape structure.
We derived three observations from metapopulation theory
	1. We found that a *mismatch* of the consumer and its favourable climate emerges as a property of the metapopulation approach. Using a metapopulation approach, we showed that climate warming could lead to a decrease in the environmental *correlation between trophic levels*.
	2. precipitation of the decline with habitat shrinking and connectivity
	3. importance of the correlation in the environmental response between trophic levels
inspired by a real case scenario, we have shown how theory could be relevant to decision-making and policy.
In this study, we did not consider a parametrized model for the Bicknell's thrush.

*Cette approche est intéressante, mais a déjà commencée à être explorée: revue de littérature*\
Many studies have investigated distribution change using metapopulation theory [@fordham_adapted_2013;@schnell_estimating_2013;@talluto_extinction_2017;@huang_using_2019;@vissault_slow_2020], but much fewer to manage the complexity arising from biotic interactions and dispersal in context of rapid environmental change.
Some aspects have however been explored, starting with the development of the theoretical basis for metapopulation dynamics on heterogenous landscapes. 
Spatially realistic metapopulation theory has allowed modelling of distribution dynamics in species living in fragmented landscapes[@hanski_metapopulation_1998;@hanski_habitat_1999;@hanski_metapopulation_2000;@hanski_spatially_2001].
The coupling of spatially explicit metapopulation model with dynamic climate change represent a significant conceptual advancement toward increasingly realistic projections [@anderson_dynamics_2009].
The approach reveals distribution dynamics that other methods fail to capture, demonstrating the importance of approaches intergrating dynamic processes.
The simulation study of the Iberian lynx distribution is the first study to consider the interplay of climate change and trophic interactions using a metapopulation approach [@fordham_adapted_2013].
It showed that these factors could be explicitely considered together, exhibiting distribution dynamics of greater complexity and realism.
Moreover, the use of the metapopulation approach has made possible the study of non-equilibrium distributions - the result of a mismatch between optimal and realized climates -, by the scaling of local processes at the entire distribution [@talluto_extinction_2017].
Recently, the approach was extended to non-equilibrium dynamics of distribution shift in response to climate warming, opening the way for the study of non-linear dynamics of migration [@vissault_slow_2020].
The metapopulation framework that we propose here builds on these previous developments to andvance toward simultaneously projecting changes in demography and dispersal in response to climate change and the multi-species effects of biotic interactions on the distribution of species.

The use of the metapopulation theory to inform conservation goes as far back as 1985 [Shaffer 1985] for species with patchy population structure and has since been used to account for specific spatial and population dynamics [@hanski_metapopulation_1997;@fordham_adapted_2013;@huang_using_2019]. 
In response to exploitation pressure from the logging compagnies and an extinction risk increasing rapidly, a spatially explicit metapopulation model was used to define the amount of prestine forest needed to assure the survival of the northern spotted owl [*Strix occidentalis caurina*] in North-ouestern United-States [Shaffer 1985, Lamberson 1994].
More recently, the incidence function model [IFM] has been used to study the large scale population dynamics of the Glanville fritillary [*Meliteae cinxia*] who's distribution has shrunk in Europe to become highly fragmented.
The application of these models to case studies demonstrates the value of the metapopulation approach in describing the distribution dynamics of species while being strongly rooted in theory and simple enough to be parameterized using available ecological data [@hanski_metapopulation_1999].

Metapopulation theory and models affect how conservation priorities are defined at a variety of scales.
The conservation of ecological corridors is the current focus of important initiatives worldwide [CorridorAppalachien,NCC,WesternWildwayNetworkPriorityCorridorProject] while habitat fragmentation is a criterion of threat for the IUCN Red List [IUCN].
Metapopulation theory predicts the scaling of extinction risk with increasing habitat isolation, something other non spatially explicit approaches do not do.
Equally, assisted colonization and habitat restoration are put forward as means to support species persistence by increasing respectively colonization rates and habitat availability [@ricciardi_assisted_2009,@willis_assisted_2009,@fordham_adapted_2013].
Metapopulation theory main contribution to conservation ecology has been to direct attention on the effect of spatial configuration of the landscape on species persistence. 



Hanski --> théorie
Araujo [Nature climate change, proceeding B., Talluto, Steve, State occupancy models [voir ref steve]]
Utilisation pour la conservation: nothern spotted howl [https://scholar.google.com/scholar?hl=fr&as_sdt=0%2C5&q=The+metapopulation+and+species+conservation%3A+the+special+case+of+the+northern+spotted+owl&btnG=]
Papillons [Hanski]
A des incidences sur comment on conserve [milieu de la conservation inspiré par l'approche: connectivité]

*Paragraph 2. habitat-abiotic mismatch*\

*Paragraph 3. Metapopulation approach. Importance of connectivity. Mountain tops.*\

- Habitat amount decrease --> capacity decline precipitated
	- connectivity [fragmentation + isolation + habitat amount] loss


*Paragraph 4. Importance of environmental correlation between trophic levels. We don’t really know that.*\

*Paragraph 5. Although metapopulation models are easy to parameterize, they require species-specific colonization, extinction, and dispersal information.*\

*Paragraph 6. Several other factors could also impact the system's reponse to climate warming.* \
Several other factors could also impact the system's reponse to climate warming.
The model described here is best suited for habitat specialists that depend for their presence on the prior establishment of another species that they do not impact, but it could also be generalized to other types of interactions [see @gravel_trophic_2011 for an examle of a very general model].
Positive and negative effects of the consumer on its resource could influence differently the system's response to climate warming.
For example, resource remouval by the consumer may reduce competition of resource types and decrease response lag, accelerating the consumer's decline at the scale of the landscape [@vissault_slow_2020,will].
Prolongued occupancy of the resource by the consumer may on the other hand increase resource mismatch and support source-sink dynamics.
In addition to biotic interactions, lanscape structure could affect metapopulation persistence through situations where enhanced connectivity and source-sink dynamics could delay prevalence decline or where the access to suitable habitat could be limited by dispersal and precipitate motapopulation extinction [@hanski_metapopulation_2000].
Finally, metapopulation dynamics at the landscape level could be affected by the interaction of climate warming and natural disturbances.
Regime of forest fires and spruce budworm outbreaks are expected to respectively increase and decrease in severity [].
Both are important drivers of forest dynamics and our results show that modifications in resource spatial distribution could be important for the consumer response.

*Paragraph 7. Retour sur la grive.* \
We have shown that metapopulation models are tools of value for conservation practitionners.

## Figures

*??? Box 1. Cartoon representation of the various effects of climate change on landscape suitability*\
Patch contraction\
Patch extinction\
dispersal limitation\
Connectivity reduction\

*Box 2. Integrating biotic interactions into metapopulation models.*\
[Intuitions from metapopulation theory using differential equations of a simple bottom-up model, with corresponding figures]
	1. Conceptual representation of resource mismatch effect on consumer distribution shift.
	2. Non-linear response of occupancy with climate change in metapopulations versus the linear response of a standard SDM
	3. The effect of environmental change on lower trophic levels can propagate up and affect higher trophic levels. The effect of more favourable abiotic conditions to a top level species could be detrimental if the environment becomes less favourable for the lower trophic level. Figure : change in prevalence of a top species [color] as a function of the optimal temperature of the lower trophic level [x axis] and the higher trophic level [y axis]. 


*Fig 2. Regional maps of initial and projected Bicknell's thrush distribution after 100 years of climate warming.*\

*Fig 3. Projection of regional distribution change over 100 years of constant climate warming.*\

\newpage


# References