#####   0. Preparation  #####
# On appelle des packages suivants. Attention: Il est important des les appeler dans cet ordre !!
library(rjson)
library(jsonlite)
library(httr)
library(plyr)
library(reshape2)
library(ggplot2)


#### A convenient function 
simulate_json <- function(json_object){
    object <- fromJSON(json_object)
    ## Get axes
    axes = celib$scenarios$axes[[1]]["name"]

    ## Get the results
    result <- POST(url='http://api.openfisca.fr/api/1/simulate', body =json_object,
                         add_headers('Content-Type'= 'application/json',
                                     'User-Agent'='OpenFisca-Notebook'))
    #fromJSON(result)
    response = content(result)

    ## Rework the results
    data = as.data.frame(response$value)
    values = as.data.frame(t(as.data.frame(data$values)))
    title = as.data.frame(data$title)
    names(title) = "description"
    code = as.data.frame(data$code)
    names(code) <- "code"

    ## Building the computed melted value data.frame
    df = cbind(values,title,code)
    rownames(df) <- NULL
    df$code %in% axe_code$name
    mdf = melt(df, id.vars = c("description","code"), variable.name="axis")

    ## Building the melted axis
    extracted_axis= df[df$code %in% axe_code$name,]
    x = melt(extracted_axis, id.vars ="code", variable.name = "axis")

    axes_var= dcast(x, axis~code)
    output = merge(mdf, axes_var)
    for (axe in axes$name){
        output[,axe] = as.numeric(output[,axe])
    }
    return(output)}


#####   1. JSON to R  

json_celib <- '{"scenarios":
[{"axes":
      [{"count": 10000, "max": 50000, "name": "sali", "min": 0},
       {"count": 2, "max": 3000, "name": "loyer", "min": 1000}],
  "test_case":
      {"foyers_fiscaux":
           [{"declarants":
                 ["ind0"]}],
       "individus":
           [{"cadre": true,
             "activite": "Actif occupé",
             "statmarit": "Célibataire",
             "id": "ind0", "birth": 1970}],
       "familles":
           [{"parents": ["ind0"]}],
       "menages":
           [{"personne_de_reference": "ind0"}]},
  "year": 2013}],
  "decomposition":
    [{"code": "salsuperbrut", "title": "Salaire super brut"},
     {"code": "salnet", "title": "Salaire net"},
     {"code": "sali", "title": "Salaire imposable"},
     {"code": "loyer", "title": "Loyer"},
     {"code": "revdisp", "title": "Revenu disponible"}]}'

celib <- fromJSON(json_celib)
foyers_fiscaux <-as.data.frame(celib$scenarios$test_case$foyers_fiscaux)
individus <-as.data.frame(celib$scenarios$test_case$individus)
menages <-as.data.frame(celib$scenarios$test_case$menages)
year <-as.data.frame(celib$scenarios$test_case$year)

#####  2. Compute the the various income

output = simulate_json(json_celib)

#####  3. Plot the various income
p = ggplot(subset(output, loyer==1000), aes(x = sali, y=value, color=description, group=description)) + geom_line()
p



