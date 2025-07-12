#!/bin/sh

# Now in module working directory

get_md5() {
    local file="$1"
    if [ -z "$file" ]; then
        echo "Usage: get_md5 <file>" >&2
        return 1
    fi

    if [ ! -f "$file" ]; then
        echo "Error: File '$file' does not exist." >&2
        return 1
    fi

    # 检测系统类型，选择正确的 MD5 命令
    if [ "$(uname)" = "Linux" ]; then
        # Linux: md5sum 输出格式 "hash filename"，取第 1 行第 1 列
        md5_cmd="md5sum"
		md5_value=$($md5_cmd "$file" | tr " " "\n" | sed -n 1p)
    elif [ "$(uname)" = "Darwin" ]; then
        # macOS: md5 输出格式 "MD5 (filename) = hash"，取第 4 列
        md5_cmd="md5"
		md5_value=$($md5_cmd "$file" | awk '{print $1}')
    else
        echo "Error: Unsupported OS: $(uname)" >&2
        return 1
    fi

    echo "$md5_value"
}

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
	md5value=$(get_md5 "${MODULE}.tar.gz")
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
