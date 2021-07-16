---
title: Intuitions from metapopulation theory using differential equations of a simple bottom-up model
author: Victor Cameron
---

*Examination of the predictions of a simple two species metapopulation model presents dynamics that differ from widespread correlative approaches.*
Predictions of a simple two species metapopulation model present dynamics that differ from widespread correlative approaches.
To demontrate the complexity arising in metapopulation distribution dynamics, consider a simple resource–consumer system in which each local patch can be colonized by a resource ($R$) and its consumer ($P$), given that the resource establishes first and the abiotic environmental conditions ($E$) are adequate;

$$
\frac{dR}{dt} = c_{R}(E)R(1-R) - e_{R}(E)R
$$

$$
\frac{dP}{dt} = c_{P}(E)P(R(E)-P) - e_{P}(E)P
$$

Where $c$ is the colonization rate and $e$ the extinction rate. Both are species-specific demographic functions of the abiotic environment. 
A consumer persists in equilibrium in a balance between resource availability, colonization, and extinctions:

$$
P^{*} = R^{*} - \frac{e_{P}}{c_{P}}
$$

and its distribution limit is defined by $P^{*} = 0$, such that it is located where $R = \frac{e}{c}$. Thus, it occurs where resource availability is balanced by the ratio of extinction and colonization.
**DG** une transition serait utile. Quelque chose du genre : Range limits over an environmental gradient are determined by the specific functions for colonization and extinction, along with the distribution of the resource over that gradient and the landscape configuration. We provide three examples below illustrating how metapopulation theory can reveal the complexity of range dynamics under climate warming.

*Resource mismatch effect on consumer distribution shift.*
This implies that environmental mismatch of the lower trophic level - change of resource availability for given environmental conditions - affects top-level distribution shift in scenario of abiotic conditions change (Fig 1A).
The top trophic level distribution includes environmental conditions for which resource availability (R, green line) is superior to its extinction to colonization ratio (e/c, orange line).
At equilibrium, the abiotic conditions contained within a species distribution remain stable despite environmental change; the distribution shifts instantaneously (Fig 1A., shaded area).
If we observe an environmental mismatch of the resource (Fig 1A., arrow) such that $R > R^{*}$ (Fig 1A., green dashed line), the consumer could reach a greater equilibrium prevalence. Conversely, if $R < R^{*}$, the equilibrium prevalence is less.
Therefore, low trophic level response to abiotic conditions change influences the top species distribution, both in extent and in the position of its distribution limits.
Thus, the position of the top trophic level distribution limit can shift if the lower-level species is environmentaly mismatched, modifying its response to new environmental conditions.


*Non-linear response of occupancy with climate change in metapopulations contrasts with the linear response of a standard SDM.*
**DG** transition ajoutée : 
An implicit assumption of standard SDMs is that a reduction in suitable habitat availability translates into an equivalent reduction in species range (Thomas2004; Fig 1B; full line).). 
Such reductions in suitable habitats may however precipitate the decline of a species in a metapopulation setting. 
The consumer's equilibrium prevalence equation (equation 3) shows that non-linear response of prevalence can arise in metapopulations from a linear change in environmental conditions (Fig 1B).
This prediction contrasts with the linear response of a standard SDM.
SDMs assume distributions to remain within equilibrium abiotic environmental conditions and to respond instantaneously, therefore projecting linear changes in consumer prevalence (Fig 1B; full line).
In contrast, distribution changes from the metapopulation approach are projected from the combined effects of new environmental conditions on demographic performance and on resource availability. 
Imagine a landscape composed of a set of habitat patches with a gradient in abiotic environmental conditions. The linear contraction of the landscape's favourable environmental conditions here has two effects: first a reduction in resource availability $R$ from what follows a loss of suitable habitat area ($A$), increases extinction rates $e$ ($e = \frac{e/A}$) (Hanski 2000).
Resource availability and habitat patch area being correlated, the effect of environmental change on prevalence is amplified (Hanski 2000).
The amplification effect may not be important at first while suitable habitat is abundant, but increases as habitat availability decreases, supporting an acceleration of metapopulation prevalence loss to a constant abiotic environmental shift (Hanski 2000, Ovaskainen 2002).

*The effect of environmental change on lower trophic levels can propagate up and affect higher trophic levels.*
The net effect of more favourable abiotic conditions to a top-level species could nonetheless be detrimental if the environment becomes less favourable to the lower trophic levels (Fig. 1C).
It is therefore critical to document the correlation in the response to the environment between trophic levels. 
Fig C illustrates that top trophic level occupancy increases (green) as conditions change benefits both top and lower levels (2nd quadrant) or as one level benefit more than the other suffers (1st and 4rth quadrants).
Conversely, a decrease in top-level species prevalence (red) is caused by less favourable conditions to the top-level species (quadrant 1), to the bottom level species (quadrant 4) or to both (quadrant 3).
Perfect matching of both levels' environmental performance is represented by the dashed line.  
Thus, the environmental correlation between trophic levels - the relative position of environmental optimum and environmental breadth - may have counter-intuitive effects on top-level species response.
This highlights that the response of both trophic levels are important to explain the system's reponse.


*In regard to these intuitions, a metapopulation approach presents projections of greater complexity and increased realism*

![Intuitions from a two species metapopulation model.](./img/concept.png){ width=100% }
**Figure 1:** Panel A shows that the distribution of the top trophic level is affected by the bottom level prevalence. 
Panel B presents the response of a top trophic level species to a linear environmental change in time as projected by a metapopulation model (precipitated response; stripped line) and a standard SDM (linear response; full line). 
Panel C shows that the response of a bottom trophic species to an environmental change influence the response of higher levels.