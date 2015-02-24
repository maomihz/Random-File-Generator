trap "clean" INT TERM QUIT KILL

clean() {
	cd ..
	echo
	echo cleaning...
	if [ -d $CURFOLDER ]; then
		rm -rf $CURFOLDER
	fi
	exit
}

gen() {
	CURFOLDER=$(date '+%F_%H-%M-%S')
	mkdir "$CURFOLDER"
	cd "$CURFOLDER"
	echo Generating Folder $CURFOLDER
	for i in $(seq 1 100)
	do
		echo -n "generating file $i... "
		FILENAME=$RANDOM
		head -c $(($RANDOM*2048)) /dev/urandom | base64 >$FILENAME
		echo $(du -h $FILENAME | cut -d '	' -f 1)
		mv $FILENAME $(openssl sha1 $FILENAME | cut -d ' ' -f 2)
	done
	cd ..
}

rand() {
	cat /dev/urandom |
	od -t u4 |
	head -n 1 |
	cut -d '	' -f 2
}

echo "Program will not exit until you hit Ctrl-C"
while true
do
	gen
done
