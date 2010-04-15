#!/bin/bash
#Create the directory if $HOME/.potd/ doesn't exist
mkdir -p ~/.potd/
#I like 42 columns for conky, has to be configured for your preferred width.
export conkycolumns=80;
#Get today's astronomy picture and save it to apod.html
load_apod(){
	wget http://antwrp.gsfc.nasa.gov/apod/ -O $HOME/.potd/apod.html
	#Grep the IMG tag from apod and wget it to apod.jpg
	grep IMG $HOME/.potd/apod.html| awk -F\" '{ system("wget http://antwrp.gsfc.nasa.gov/apod/"$2" -O $HOME/.potd/apod.jpg") }'
	#Set the new desktop background on gnome
	/usr/bin/gconftool-2 --type string --set /desktop/gnome/background/picture_filename $HOME/.potd/apod.jpg
	#Format the file to end in the nearest </tag> each line
	perl -p -i -e 'chomp if(!/\>$/)' $HOME/.potd/apod.html;
	#Save the APotD Description on a txt file for conky with the pre-set columns or as closed to it as possible without breaking words.
	perl -e 'my $flag=0; my $curline = "";while(<>){$curline = $_; if ($flag){s/<[^>]*>/ /g; s/\ \ /\ /g; s/([^\n]{0,$ENV{conkycolumns}})(?:\b\s*|\n)/$1\n/gi; print;} last if ($curline =~ /<p>\ <center>/); $flag=1 if (/Explanation\:/); }' ~/.potd/apod.html > $HOME/.potd/conky.txt
}
load_wpod(){
	wget http://en.wikipedia.org/wiki/Wikipedia:Picture_of_the_day -O $HOME/.potd/wpod.html
	grep '<td>.*class=\"image\"' $HOME/.potd/wpod.html| gawk -F\" '{ system("wget http://en.wikipedia.org"$2" -O $HOME/.potd/wpodp.html") }'
	grep 'class=\"fullImageLink\"' $HOME/.potd/wpodp.html|gawk -F'href' '{ print $3 }'|gawk -F\" '{ system("wget "$2" -O $HOME/.potd/wpod.jpg") }'
	#Set the new desktop background on gnome
	/usr/bin/gconftool-2 --type string --set /desktop/gnome/background/picture_filename $HOME/.potd/wpod.jpg
	#Save the EPotD Description on a txt file for conky with the pre-set columns or as closed to it as possible without breaking words.
	perl -e 'my $flag=0;while(<>){ $flag = 0 if(/<\/table>/); if ($flag){s/<[^>]*>/ /g; s/([^\n]{0,$ENV{conkycolumns}})(?:\b\s*|\n)/$1\n/gi; print if(/[A-Za-z0-9]/);} $flag=1 if (/<td>.*class=\"image\"/); }' $HOME/.potd/wpod.html > $HOME/.potd/conky.txt
}
load_epod(){
	#Get today's earth picture and save it to epod.html
	wget http://epod.usra.edu/ -O $HOME/.potd/epod.html
	grep asset-image $HOME/.potd/epod.html|gawk -F\" '{ system("wget "$2" -O $HOME/.potd/epod.jpg") }'
	#Set the new desktop background on gnome
	/usr/bin/gconftool-2 --type string --set /desktop/gnome/background/picture_filename $HOME/.potd/epod.jpg
	#Save the EPotD Description on a txt file for conky with 42 chars or as closed to it as possible without breaking words (based ~/.conkyrc width.)
	perl -e 'my $flag=0;while(<>){ $flag = 0 if(/\"related-clicks"/); if ($flag){s/<[^>]*>/ /g; s/([^\n]{0,$ENV{conkycolumns}})(?:\b\s*|\n)/$1\n/gi; print if(/[A-Za-z0-9]/);} $flag=1 if (/\"entry-body\"/); }' $HOME/.potd/epod.html > $HOME/.potd/conky.txt
}
case "$1" in
  apod|astronomy|nasa|"")
	load_apod
	;;
  wpod|wikipedia|wiki)
	load_wpod
	;;
  epod|earth)
	load_epod
	;;
  *)
	echo "Usage: potd.sh [apod|wpod|epod]" >&2
	exit 3;
	;;
esac
