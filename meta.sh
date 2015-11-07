SERIESID="SH999932" # misc

if [ -f SERIESID ]
then
    SERIESID=$(cat SERIESID) 
fi


#OAD="2008-05-10T06:00:00Z"
export TZ=Zulu
#TIME="2008-05-11T01:37:00Z"
STITLE=${PWD##*/}
#EXTENSION=m4v
#EXTENSION=mp4
NUMFILES=$(ls *.$EXTENSION | wc -l)
if [ "$NUMFILES" -gt "1" ]
then
    ISEPISODE=true
else
    ISEPISODE=false
fi
ENUM=1
for f in *.avi *.mp4 *.mkv *.m4v *.mpg
do
    echo "processing $f"

    OAD=$(date "+%Y-%m-%dT%H:%M:%SZ")
    TTITLE="$f"
    ETITLE="$f"

    DESC=$TTITLE
    if [ -f "$f.desc" ]
    then
        DESC=$(cat "$f.desc")
    fi

    # title and seriesTitle are the same in examples
    echo "s|TTITLE|$STITLE|g" > "meta.$f.sed"
    echo "s|STITLE|$STITLE|g" >> "meta.$f.sed"
    echo "s|ETITLE|$ETITLE|g" >> "meta.$f.sed"
    echo "s|ENUMBER|$ENUM|g" >> "meta.$f.sed"
    echo "s|ISEPISODE|$ISEPISODE|g" >> "meta.$f.sed"
    echo "s|DESC|$DESC|g" >> "meta.$f.sed"
    echo "s|SERIESID|$SERIESID|g" >> "meta.$f.sed"
    echo "s|OAD|$OAD|g" >> "meta.$f.sed"
    TIME=$(date "+%Y-%m-%dT%H:%M:%SZ")
    echo "s|TIME|$TIME|g" >> "meta.$f.sed"
    sed -f "meta.$f.sed" /ttools/meta.tmpl > "$f.txt"
    ENUM=`expr $ENUM + 1`
done;
rm *.sed
echo "$SERIESID:$STITLE" >> /ttools/seriesIds.txt

