#####   0. Preparation  #####
# On appelle des packages
library(jsonlite)
library(httr)

#####   1. JSON to R  #####
# On récupère un dictionnaire, par exemple 

# json_data <-'{"scenarios": [{"foyers_fiscaux": [{"declarants": ["ind0"]}], "menages": [{"personne_de_reference": "ind0"}], "familles": [{"parents": ["ind0"]}], "year": 2013, "legislation_url": "http://api.openfisca.fr/api/1/default-legislation", "individus": [{"sali": 50000, "activite": "Actif occup\\u00e9", "statmarit": "C\\u00e9libataire", "cadre": true, "birth": "1970-01-01", "id": "ind0"}]}]}'
# celib <- fromJSON(json_data)

# Example with a scenario composed of a family with two kids and two parents
json_couple <- '{"scenarios": [{"foyers_fiscaux": [{"personnes_a_charge": ["ind2", "ind3"],"declarants": ["ind0", "ind1"]}], "menages": [{"conjoint": "ind1", "enfants": ["ind2", "ind3"], "personne_de_reference": "ind0"}], "familles": [{"parents": ["ind0", "ind1"], "enfants": ["ind2", "ind3"]}], "year": 2013, "legislation_url": "http://api.openfisca.fr/api/1/default-legislation", "individus": [{"sali": 35000, "activite": "Actif occupé", "statmarit": "Marié", "birth": "1970-01-01", "id": "ind0"}, {"sali": 35000, "activite": "Actif occupé", "statmarit": "Marié", "birth": "1970-01-02", "id": "ind1"}, {"activite": "étudiant, élève", "id": "ind2", "birth": "2000-01-03"}, {"activite": "étudiant, élève", "id": "ind3", "birth": "2000-01-04"}]}]}'

couple <- fromJSON(json_data_couple)
#                        

foyers_fiscaux <-as.data.frame(couple$scenarios$foyers_fiscaux)
individus <-as.data.frame(couple$scenarios$individus)
menages <-as.data.frame(couple$scenarios$menages)
year <-as.data.frame(couple$scenarios$year)

individus

# Get the results
result_couple <- POST(url='http://api.openfisca.fr/api/1/simulate', body =json_couple,
          add_headers('Content-Type'= 'application/json',
                      'User-Agent'='OpenFisca-Notebook'))

response = content(result_couple)
str(response)
str(response$value)
str(response[5])

json_couple2 <- '{"scenarios": [{"foyers_fiscaux": [{"personnes_a_charge": ["ind2", "ind3"],"declarants": ["ind0", "ind1"]}], "menages": [{"conjoint": "ind1", "enfants": ["ind2", "ind3"], "personne_de_reference": "ind0"}], "familles": [{"parents": ["ind0", "ind1"], "enfants": ["ind2", "ind3"]}], "year": 2013, "legislation_url": "http://api.openfisca.fr/api/1/default-legislation", "individus": [{"sali": 35000, "activite": "Actif occupé", "statmarit": "Marié", "birth": "1970-01-01", "id": "ind0"}, {"sali": 35000, "activite": "Actif occupé", "statmarit": "Marié", "birth": "1970-01-02", "id": "ind1"}, {"activite": "étudiant, élève", "id": "ind2", "birth": "2000-01-03"}, {"activite": "étudiant, élève", "id": "ind3", "birth": "2000-01-04"}]}], "decomposition" : ["revdisp"]}'

# Get the results
result_couple2 <- POST(url='http://api.openfisca.fr/api/1/simulate', body =json_couple2,
          add_headers('Content-Type'= 'application/json',
                      'User-Agent'='OpenFisca-Notebook'))

response2 = content(result_couple2)
str(response2)



#####   3. R to JSON  #####
