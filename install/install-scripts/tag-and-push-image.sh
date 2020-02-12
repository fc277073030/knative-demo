KNATIVE_PATH='knative'
KNATIVE_VER='v0.10.0'
REGISTRY_URL='fc277073030'

mkdir $KNATIVE_PATH


# download yaml

echo "download yaml files ..."

cd $KNATIVE_PATH





# get images list

echo "collect image to tmp file ..."


for line in `grep -RI " image: " *.yaml | grep gcr.io`
do 
	if [[ ${line} =~ 'gcr.io' ]]
	then
		if [[ ${line} =~ 'gcr.io/knative-releases/github.com/knative' ]]
		then 
			sub_line1=${line##gcr.io/knative-releases/github.com/knative/}
			sub_line2=${sub_line1%%@sha*}
			container_name=knative_${sub_line2//\//_}

			echo ${line#image:} ${REGISTRY_URL}/${container_name}:${KNATIVE_VER} >> image.tmp
		else 
			sub_line1=${line#image:}
			sub_line2=${sub_line1#*/}
			sub_line3=${sub_line2%%:*}
			container_name=knative_${sub_line3//\//_}

			echo ${line#image:} ${REGISTRY_URL}/${container_name}:${KNATIVE_VER} >> image.tmp;
		fi 
	fi
done

for line in `grep -RI " value: " *.yaml | grep gcr.io`
do 
	if [[ ${line} =~ 'gcr.io' ]]
	then
		if [[ ${line} =~ 'gcr.io/knative-releases/github.com/knative' ]]
		then 
			sub_line1=${line##gcr.io/knative-releases/github.com/knative/}
			sub_line2=${sub_line1%%@sha*}
			container_name=knative_${sub_line2//\//_}

			echo ${line#value:} ${REGISTRY_URL}/${container_name}:${KNATIVE_VER} >> image.tmp
		else 
			sub_line1=${line#value:}
			sub_line2=${sub_line1#*/}
			sub_line3=${sub_line2%%:*}
			container_name=knative_${sub_line3//\//_}

			echo ${line#value:} ${REGISTRY_URL}/${container_name}:${KNATIVE_VER} >> image.tmp;
		fi 
	fi
done
# download image, tag, push

while read line 
do 
	origin_image=`echo ${line} | awk '{print $1}'`
	new_image=`echo ${line} | awk '{print $2}'`

    echo "old:" ${origin_image}
    echo "new:" ${new_image}
	docker pull ${origin_image}
	docker tag ${origin_image} ${new_image}
	docker push ${new_image}

done < image.tmp

cd ..

# done
