# Chemostat_phytoplankton_carbon_storage

## General description
Matlab code for chemostat model with phytoplankton with carbon storage capacity. The code is flexible to the number of phytoplankton species and carbon storage capacities. The model aims to capture phytoplankton carbon storage under diel light cycles, who can store extra carbon during the day and allocate it for growth at night.

## Storage_chemostat_model.m
This is the master script to run the model and choose parameterization: choose the number of phytoplankton species, growth parameters including carbon storage capacity, and chemostat model parameters (dilution rate and nutrient supply concentration).

## broch81 folder
Set of equations estimating diel light cycles at different latitudes, according to Brock, T.D., 1981. Calculating solar radiation for ecological studies. Ecol. Modell. 14, 1–19.

## darwin_traits.m
Parameters of phytoplankton functional types of the Darwin model that can be chosen for the chemostat model runs

## equations.m
Differential equations of the chemostat - carbon storage phytoplankton model

## lipid_data.m
Nine days long high frequency time-series (every 4h) of nanophytoplankton storage lipid concentrations at station ALOHA, Hawaii: Becker, K. W. et al., 2018. Daily changes in phytoplankton lipidomes reveal mechanisms of energy storage in the open ocean. Nat. Commun. 9, 5179
