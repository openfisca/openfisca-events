## This program defines functions to convert a openfisca input data into json format

# auxiliary functions to work with characters chain
# le probleme etant d'ecrire des " dans des chaines avec la fonction paste()
guillemets <- function(x){ noquote(paste("",x, "", sep='"')) } 

## Parties inchangees
	chaine <- "[{"
	# debut de la chaine
	chaine_deb <- '{"scenarios": 
		[{ 
		"test_case": {
			"foyers_fiscaux": 
				[{"declarants": ["ind0"]}], 
			"individus":' 

	# fin de la chaine
	chaine_fin <- ', "statmarit": "Célibataire", "id": "ind0" }],
				"familles": [{"parents": ["ind0"]}], 
				"menages": [{"personne_de_reference": "ind0"}]
					}, 
		"year": 2013}],
	"decomposition": 
		[{"code": "salsuperbrut", "title": "Salaire super brut"}, 
		 {"code": "salnet", "title": "Salaire net"}, 
		 {"code": "sali", "title": "Salaire imposable"}, 
		 {"code": "loyer", "title": "Loyer"}, 
		 {"code": "revdisp", "title": "Revenu disponible"}]
	}'

R_to_json <- function(data) {
	# liste des variables entre guillemets
	names_var <- guillemets(data[,1])
	# distinction entre variables nombres ou characteres
	index <- data[,3]
	# application des guillemets si besoin
	edit_values <- guillemets(data[data[,3]==1][2])
	edit_data <- array(NA, dim=c(var,2))
	edit_data[,1] <-  names_var
	edit_data[index==1,2] <-  edit_values 
	edit_data[index==0,2] <- data[index==0,2]

	for (i in 1:(var-1)) {
		chaine <- paste(chaine,paste(edit_data[i,1], ": ",edit_data[i,2], ", ", sep = ""))
	}
	chaine <- paste(chaine,paste(edit_data[var,1], ": ",edit_data[var,2], sep = ""))
	noquote(chaine)
	j_out <- noquote(paste(chaine_deb, chaine, chaine_fin, sep=""))
	return(j_out)
}
json_to_R <- function(input){
	result_sim <-  POST(url='http://api.openfisca.fr/api/1/simulate', body = input,
          add_headers('Content-Type'= 'application/json',
                      'User-Agent'='OpenFisca-Notebook'))
	res <- content(result_sim)
	#str(res) #the R-structure of the previous object
	df_out<-data.frame(res$value)
	df_final <- data.frame()
	for (i in 1:dim(df_out)[1]){
 		values <- t(as.data.frame(df_out$values[[i]]))
 		rownames(values)<- c(df_out$code[[i]])
		df_final <- rbind(df_final,values)
	}
#	colnames(df_final) <- "Values"
	ifelse(result_sim $status_code != 200,print("Error during calculation"),return(df_final))
}


