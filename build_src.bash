DOC="build all .nim in ./src"
[[ "$1" == "-h" ]] && echo $DOC && exit
appDir=`dirname "$0"`
prog=filterLog

build(){
	local prog="$1"
	nim c -d:release -o:"$appDir/$prog" "$appDir/src/$prog"
}

for i in `ls src`; do
	build ${i%.nim}
done

