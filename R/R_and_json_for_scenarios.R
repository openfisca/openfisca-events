#####   0. Preparation  #####
# On appelle des packages suivants. Attention: Il est important des les appeler dans cet ordre !!
library(rjson)
library(jsonlite)
library(httr)

#####   1. JSON to R  #####
# On récupère un dictionnaire, par exemple 


json_celib <- '{"scenarios": [{"axes": [{"count": 3, "max": 24000, "name": "sali", "min": 0}, {"count": 2, "max": 3000, "name": "loyer", "min": 1000}], "test_case": {"foyers_fiscaux": [{"declarants": ["ind0"]}], "individus": [{"cadre": true, "activite": "Actif occupé", "statmarit": "Célibataire", "id": "ind0", "birth": 1970}], "familles": [{"parents": ["ind0"]}], "menages": [{"personne_de_reference": "ind0"}]}, "year": 2013}], "decomposition": [{"code": "salsuperbrut", "title": "Salaire super brut"}, {"code": "salnet", "title": "Salaire net"}, {"code": "sali", "title": "Salaire imposable"}, {"code": "loyer", "title": "Loyer"}, {"code": "revdisp", "title": "Revenu disponible"}]}'

celib <- fromJSON(json_celib)

str(celib)
str(celib$scenarios$axes)
str(as.data.frame(celib$scenarios$test_case))

foyers_fiscaux <-as.data.frame(celib$scenarios$test_case$foyers_fiscaux)
individus <-as.data.frame(celib$scenarios$test_case$individus)
menages <-as.data.frame(celib$scenarios$test_case$menages)
year <-as.data.frame(celib$scenarios$test_case$year)


# Get the results
result_celib <- POST(url='http://api.openfisca.fr/api/1/simulate', body =json_celib,
          add_headers('Content-Type'= 'application/json',
                      'User-Agent'='OpenFisca-Notebook'))
fromJSON(result_celib)
response = content(result_celib)
str(response)
as.data.frame(response$value)

