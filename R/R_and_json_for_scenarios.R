#####   0. Preparation  #####
# On appelle des packages
#library(rjson)
#install.packages("jsonlite", repos="http://cran.r-project.org")
#install.packages("httr", repos="http://cran.r-project.org")
library(rjson)
library(jsonlite)
library(httr)

#####   1. JSON to R  #####
# On récupère un dictionnaire, par exemple 
# json_data <-'{"scenarios": [{"foyers_fiscaux": [{"declarants": ["ind0"]}], "menages": [{"personne_de_reference": "ind0"}], "familles": [{"parents": ["ind0"]}], "year": 2013, "legislation_url": "http://api.openfisca.fr/api/1/default-legislation", "individus": [{"sali": 50000, "activite": "Actif occup\\u00e9", "statmarit": "C\\u00e9libataire", "cadre": true, "birth": "1970-01-01", "id": "ind0"}]}]}'
# celib <- fromJSON(json_data)

json_data_couple <- '{"scenarios": [{"foyers_fiscaux": [{"personnes_a_charge": ["ind2", "ind3"],"declarants": ["ind0", "ind1"]}], "menages": [{"conjoint": "ind1", "enfants": ["ind2", "ind3"], "personne_de_reference": "ind0"}], "familles": [{"parents": ["ind0", "ind1"], "enfants": ["ind2", "ind3"]}], "year": 2013, "legislation_url": "http://api.openfisca.fr/api/1/default-legislation", "individus": [{"sali": 35000, "activite": "Actif occupé", "statmarit": "Marié", "cadre": true, "birth": "1970-01-01", "id": "ind0"}, {"sali": 35000, "activite": "Actif occupé", "statmarit": "Marié", "cadre": true, "birth": "1970-01-02", "id": "ind1"}, {"activite": "étudiant, élève", "id": "ind2", "birth": "2000-01-03"}, {"activite": "étudiant, élève", "id": "ind3", "birth": "2000-01-04"}]}]}'

Rd <- fromJSON(json_data_couple)
Rd
str(Rd)

json_result_couple <- POST(url='http://api.openfisca.fr/api/1/simulate', body =json_data_couple,
          add_headers('Content-Type'= 'application/json',
                      'User-Agent'='OpenFisca-Notebook'))

a = content(json_result_couple)
a
str(a)
result_couple <- fromJSON(json_result_couple)

                                        #Dans couple$scenarios il y a : 
ff<-as.data.frame(Rd$scenarios$foyers_fiscaux)
ind <-as.data.frame(Rd$scenarios$individus)
men <-as.data.frame(Rd$scenarios$menage)
year <-as.data.frame(Rd$scenarios$year)
legislation<-as.data.frame(Rd$scenarios$legislation_url)

#####   2. Work on scenario : exemple  #####
# On met ind1 comme chômeur 
#attention, c'est le 2e car on a commencé à ind0 et que R compte à partir de 1, pas comme Python
ind$activite[2]<-"Chômeur" 

# On rajoute un enfant à la liste des enfants
enfants <-as.data.frame(ff$personnes_a_charge)
enfants[3,1]  = c("ind2")

ff$personnes_a_charge<-"ind2" "ind3" "ind4"
class(ff$personnes_a_charge)
ff$personnes_a_charge[[length(ff$personnes_a_charge)+1]] <- c("ind4"

#####   3. R to JSON  #####
