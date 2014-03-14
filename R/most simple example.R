#####   0. Preparation  #####
# On appelle des packages
library(rjson)
library(jsonlite)
library(httr)

# Example with a scenario composed of a family with two kids and two parents
json_celib <- '{
  "scenarios": [{
      "axes": [{"count": 3, "max": 24000, "name": "sali", "min": 0}, 
               {"count": 2, "max": 3000, "name": "loyer", "min": 1000}], 
      "test_case": {
          "foyers_fiscaux": [{"declarants": ["ind0"]}], 
          "individus": [{"cadre": true, "activite": "Actif occupé", "statmarit": "Célibataire", "id": "ind0", "birth": 1970}], 
          "familles": [{"parents": ["ind0"]}], 
          "menages": [{"personne_de_reference": "ind0"}]}, 
      "year": 2013}], 
  "decomposition": [
      {"code": "salsuperbrut", "title": "Salaire super brut"}, 
      {"code": "salnet", "title": "Salaire net"}, 
      {"code": "sali", "title": "Salaire imposable"}, 
      {"code": "loyer", "title": "Loyer"}, 
      {"code": "revdisp", "title": "Revenu disponible"}]
  }'

#Get the results
result_celib <- POST(url='http://api.openfisca.fr/api/1/simulate', body =json_celib,
                     add_headers('Content-Type'= 'application/json',
                                 'User-Agent'='OpenFisca-Notebook'))
response = content(result_celib)
df_out <-as.data.frame(response$value)

# Well organize dataframe :
df_final<-data.frame()
for (i in 1:dim(df_out)[1]){
  values <- t(as.data.frame(df_out$values[[i]]))
  rownames(values)<- c(df_out$code[[i]])  
  df_final <- rbind(df_final,values)
}
