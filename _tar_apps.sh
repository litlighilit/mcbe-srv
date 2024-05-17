
appDir=`dirname "$0"`
appDir=`realpath "$appDir"`
appName=`basename "$appDir"`
destDir=${1-"$HOME/Download"}
destDir="${destDir%%/}"

appPre="$destDir/${appName}_"
cd "$appDir"
version=`cat version.txt`
tar cf "$appPre$version.tar" .
lversion="lastest"
ln -s "$appPre$version.tar" "$appPre$lversion.tar"
cd -

