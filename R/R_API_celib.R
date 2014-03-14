####
### API needs JSON format input and gives JSON outputs
### This program :
# 1. converts an input data to a json file
# 2. get the results from the API and converts them to R data the outputs

#####   0. Preparation  #####
# Warning : order matters in packages loading
library(rjson)
library(jsonlite)
library(httr)
setwd("my_repository")
source("R_json.R")

##### 1. R to JSON ####
## from your dataframe to API's input file
	# all possible output variables are in model.py
	# or available from this link : 
	# http://nbviewer.ipython.org/github/openfisca/openfisca-web-notebook/blob/master/liste-des-variables.ipynb

## 1.1 Scenario / Input variables ##

# In this example we use the following case
# Celibataire sans enfant with 4 INDIVIDUAL variables
var <-  4
data <- array(NA, dim=c(var,3))
data[1,] <-  c("cadre", "true", 0)			# or "false"
data[2,] <-  c("activite", "Actif occupé", 1)
data[3,] <-  c("birth", "1970", 0)			# birth year
data[4,] <-  c("sali", "20000", 0)		# taxable income 
# O if boolean of numerical values // 1 if character

## 1.2 Decomposition / Choice of output variables ##
#  This example gives as output :
## 'salsuperbrut' 	# salaire superbrut
## 'salnet'			# salaire net
## 'sali'			# salaire imposable
## 'loyer'			# loyer
## 'revdisp'		# revenu disponible

## FINAL INPUT 
json_input <- R_to_json(data)

##### 2. CALLING THE API (website calculator) ####
## Get the results : Output = Openfisca(Input)
## json output file is converted to R dataframe object
result <- json_to_R(json_input)

