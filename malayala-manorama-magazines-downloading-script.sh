#!/bin/bash
#danialjose at gmail dot com
#License : GPL V 3

#Script to download epaper from Hindu
#No more subscription .. pls donate the money to Free Sotware Foundation http://gnu.org
#As always /// Its free to use...

#Get user to select edition
edition_choice=([0]=MMFast [1]=MMKarshakasree [2]=MMSamp [3]=MMVanitha [4]=MMMan [5]=MMWeek [6]=MMBhasha [7]=%5CMMWeekly )
edition_name=([0]=MMFast [1]=MMKarshakasree [2]=MMSamp [3]=MMVanitha [4]=MMMan [5]=MMWeek [6]=MMBhasha [7]=MMWeekly )
echo "MM Magazines are"
echo "-------------------------------------------------"
echo "0. Fast Track"
echo "1. Karshaka Sree"
echo "2. Sambathyam"
echo "3. Vanitha"
echo "4. The Man"
echo "5. The Week (Error with default date -01, change _01_ to _15_ or _30_ manualy)"
echo "6. Bashaposhini (Not working)"
echo "7. Manorama Weekly"
echo "-------------------------------------------------"
while true; do
    read -p "Enter magazine you wish to selec[0-3]: " ed
    case $ed in
       [01234567]) 
 echo "Thanks." 
 break;;
        * ) echo "Please select the correct numeric serial.";;
    esac
done

url_prefix=([7]=http://eweekly.manoramaonline.com/ManoramaLibrary/${edition_choice[$ed]}/`date -dnext-saturday +%Y`/`date -dnext-saturday +%m`/`date -dnext-saturday +%d`/${edition_choice[ed]}_`date -dnext-saturday +%Y`_`date -dnext-saturday +%m`_`date -dnext-saturday +%d`)
folder_format=([7]=`date -dnext-saturday +%Y``date -dnext-saturday +%m``date -dnext-saturday +%d`)

#spider the selected edition using wget to estimate number of pages
#define max incremental page limit
max_spider=200
echo "Estimating number of pages in magazine edition"
#start spider for main editon
 for ((  j = 1 ;  j <= $max_spider;  j++  ))
    do
      #prepend zero to single digits
      _PR='_PR'
      pageno=`printf "%03d" $j`  
      echo "Searching for Page $pageno"
      if [ -z ${url_prefix[$ed]} ]; then
            I_FILE="http://eweekly.manoramaonline.com/ManoramaLibrary/${edition_choice[ed]}/`date +%Y`/`date +%m`/01/${edition_choice[ed]}_`date +%Y`_`date +%m`_01_$pageno$_PR.jpg"
      else
            I_FILE="${url_prefix[$ed]}_${pageno}${_PR}.jpg"
      fi
 debug=`wget --spider $I_FILE 2>&1`
 echo $debug
      if [[ $debug =~ .*link!!!.* ]]
      then
      break
      fi
done
clear
#decrement counter
(( j = j - 1 ))
npages_A=$j
echo "Estimating number of pages in magazine edition supplement"

if [ -z ${folder_format[$ed]} ]; then
    ty_dir="$HOME/Desktop/${edition_name[ed]}`date +%m``date +%y`"
else
    ty_dir="$HOME/Desktop/${edition_name[ed]}${folder_format[$ed]}"
fi
#mkdir to store individual pages
mkdir $ty_dir
echo "Please be patient..Bandwidth intensive operation starts..;-)"
echo "Downloading Main Paper .. total $npages_A pages"
    for ((  i = 1 ;  i <= npages_A;  i++  ))
    do
      #prepend zero to single digits
      pageno=`printf "%03d" $i`  
      echo "Downloading Page $pageno"
      O_FILE="$ty_dir/A$pageno.jpg"
      if [ -z ${url_prefix[$ed]} ]; then
            I_FILE="http://eweekly.manoramaonline.com/ManoramaLibrary/${edition_choice[ed]}/`date +%Y`/`date +%m`/01/${edition_choice[ed]}_`date +%Y`_`date +%m`_01_$pageno$_PR.jpg"
      else
            I_FILE="${url_prefix[$ed]}_${pageno}${_PR}.jpg"
      fi

      wget -q -O $O_FILE $I_FILE 
      
    done
    
echo "All downloads are finished, Please close this window and enjoy reading!"


#This Script is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free #Software Foundation; either version 3 of the License, or (at your option) any later version.

#This Script is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or #FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

#You should have received a copy of the GNU General Public License along with this script; if not, write to the Free Software Foundation, Inc., 51 #Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
