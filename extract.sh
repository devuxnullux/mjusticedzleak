 FILES=*.txt
 out=extract.csv
 for f in $FILES
 do
  #echo "Processing $f file..."
  # Récuperer les string alpha majuscule ayant une longueur superieure a 4 charactere : '[A-Z]\{4,\}'
  # Récuperer la premiere occurence qui doit correspondre au nom : head -1
  ## elliminer le string avec le caractere ( : grep -v '(' # no more needed
  ## enlever le retour a la ligne qui apparait de temps a autre : tr -d '\r' # no more needed
  # supprimer les 7 premier octets UTF-8 pour rtl :cut -c 7-
  # inverser la chaine et supprimer les 7 derniers octets et réinverser la chaine : rev | cut -c 7- | rev
  #nom=$(grep -e '[A-Z]\{4,\}' $f | grep -v '(' | tr -d '\r'  | cut -c 7- | rev | cut -c 7- | rev)
  nom=$(grep -e '[A-Z]\{4,\}' $f | head -1 | cut -c 7- | rev | cut -c 7- | rev)
  # append name to file
  echo -n $nom >> $out
  echo -n ',' >> $out 
  # Recupérer la seule date ayant un format YYYY/MM/DD
  date=$(grep -o '[0-9]\{4\}/[0-9]\{2\}/[0-9]\{2\} :' $f | awk 'FS=" " {print $1}' | tr -d '\n')
  if [ -z "$date" ] # Si date est nulle cela veux dire que le champs est probablement pour un né présumé
	then
      # Si présumé la date n'est que YYYY
	  date=$(grep -o '[0-9]\{4\} :' $f | awk 'FS=" " {print $1}' | tr -d '\n')
	fi 
  echo -n $date >> $out
  fpdf=$(echo "${f%.*}".pdf) # get the original pdf file name
  echo ','$fpdf >> $out
 done
