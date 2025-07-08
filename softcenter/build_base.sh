#!/bin/sh

# Now in module working directory

md5_cmd=$(command -v md5sum || command -v md5)

do_build_result() {
	rm -f ${MODULE}/.DS_Store
	rm -f ${MODULE}/*/.DS_Store
	rm -f ${MODULE}.tar.gz

	if [ -z "$TAGS" ];then
		TAGS="其它"
	fi
	
	# add version to the package
	cat > ${MODULE}/version <<-EOF
	${VERSION}
	EOF
	
	tar -zcvf ${MODULE}.tar.gz $MODULE
	md5value=$($md5_cmd ${MODULE}.tar.gz | tr " " "\n" | sed -n 1p)
	cat > ./version <<-EOF
	${VERSION}
	${md5value}
	EOF
	cat version
	
	DATE=$(date +%Y-%m-%d_%H:%M:%S)
	cat > ./config.json.js <<-EOF
	{
	"version":"$VERSION",
	"md5":"$md5value",
	"home_url":"$HOME_URL",
	"title":"$TITLE",
	"description":"$DESCRIPTION",
	"tags":"$TAGS",
	"author":"$AUTHOR",
	"link":"$LINK",
	"changelog":"$CHANGELOG",
	"build_date":"$DATE"
	}
	EOF
	
	#update md5
	python ../softcenter/gen_install.py stage2
}
