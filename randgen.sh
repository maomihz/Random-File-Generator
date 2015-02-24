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
	echo -n "generating file $i... "
	FILENAME=$RANDOM.tmp
	
	cat /dev/urandom |
	od -t x4 |
	cut -d ' ' -f 2- |
	tr -d ' ' |
	tr -d '\n' |
	fold -w 80 |
	head -n $(($RANDOM * 32)) > $FILENAME
	
	echo $(du -h $FILENAME | cut -d '	' -f 1)
	mv $FILENAME $(openssl sha1 $FILENAME | cut -d ' ' -f 2)

}

genfolder() {
	CURFOLDER=$(date '+%F_%H-%M-%S')
	mkdir "$CURFOLDER"
	cd "$CURFOLDER"
	echo Generating Folder $CURFOLDER
	for i in $(seq 1 100); do
		gen
	done 
	cd ..
}

rand() {
	cat /dev/urandom |
	od -w4 -t u4 |
	head -n 1 |
	cut -d ' ' -f 2- |
	tr -d ' '
}


echo "Program will not exit until you hit Ctrl-C"
while true
do
	genfolder
done
