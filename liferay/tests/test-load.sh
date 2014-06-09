#!/bin/bash


apps=( 
''
'calendar-portlet'
'notifications-portlet'
'sync-web'
'web-form-portlet'
'resources-importer-web'
'kaleo-web'
)

N=500

i=0

url="http://172.17.0.4:8080"

while [ $i -lt $N ];do
    i=$((i+1))
    n=$((20+RANDOM%80)) 
    c=$((1+RANDOM%10)) 
    path="/${apps[$((RANDOM%${#apps[*]}))]}"
    echo ":: i=$i n=$n c=$c path=$path"
    ab -n $n -c $c ${url}${path}
    


done
