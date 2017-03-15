 #!/usr/bin
 #Marley Paige
 
i=0
fn="$2"
echo 'parsing layout listMetadata.'
echo "writing to $fn"
echo '<?xml version="1.0" encoding="UTF-8"?><Package xmlns="http://soap.sforce.com/2006/04/metadata"><types>' > $fn

#Loop through listMetadata output
while IFS='' read -r line || [[ -n "$line" ]]; do
  if [ "$line" != "[sf:listMetadata] ************************************************************" ]
  then       
    tmp=`echo "$line" | sed 's/\[sf\:listMetadata\]//g'`
    tmpParse=`echo "$tmp" | sed 's/FileName\: layouts\///g'`
    if [ ${#tmp} != ${#tmpParse} ]
    then 
      fileName=$tmpParse   
      i=0
    fi
    i=`expr $i + 1`
    if [ $i == 4 ]
    then
      nameSpace=`echo "$tmp" | sed 's/Namespace Prefix\: null//g'`
      if [ ${#nameSpace} == ${#tmp} ]
      then
        fileName=`echo "$fileName" | sed 's/\.layout//g'` 
        nameSpace=`echo "$nameSpace" | sed 's/Namespace Prefix\: //g'`
        nameSpace=`echo "$nameSpace" | sed 's/^ *//;s/$//'`
        members=`echo $fileName | sed 's/\-/\-'"$nameSpace"'__/g'`
        echo "<members>$members</members>" >> $fn
      fi
    fi    
  fi
    
done < "$1"
echo '<name>Layout</name></types><version>39.0</version></Package>' >> $fn
