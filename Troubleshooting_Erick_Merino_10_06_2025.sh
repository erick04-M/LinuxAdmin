#!/usr/bin/sh

# Author: Erick Merino
# Date: 10-06-2025
# Troubleshooting for server
#To run command do ./*scriptname*.sh
#this echo will print out a question asking the user which server/version of linux that they are on
{
echo "hello User! Welcome to our trouble shooting tips"

echo "If I may ask which server are you on? are you on ubuntu or centOS" 
read answer
if [ "$answer" = "ubuntu" ] || [ "$answer" = "Ubuntu" ]
#Once we know what version of linux it will ask for general Trouble shooting questions and give some suggestions on how to fix them, when selecting them just
#choose the letter for example if you want to use A then just type A
then 
	echo "great! Now that I know you are on ubuntu" 

	echo "Which trouble shooting tips do you want to learn about" |

	echo "A. No Internet connectivity    B. Setting a Static Ip address and DNS   C. Running a trace for a path to a website of your choice"
	#If they chose answer A The script will give them suggestions on what to do inorder to fix it.
read answer2
     if [ "$answer2" = A ] || [ "$answer2" = a ]
 	then
#so we are going to call our Trouble shooting guide for Internet connectivity and I decided to go for this route as it was easier for me to understand plus it makes the script not as cluttered and we are using the less command so when it prints out the guide it will make it easier to read	
		cat ./Guides/Internet_connectivity.txt | less #if you are having trouble escaping the file once called all you need to do is press q
		echo " This guide will help you try to fix your Internet connectivity issues just try these steps in here and they might fix your issues!"
#If our answer was B or since we used || we can say if the asnwer is b it is going to call our Static IP and DNS guide to be printed on the screen
	elif [ "$answer2" = B ] || [ "$answer2" = b ]
	then
		cat ./Guides/Static_IP_and_DNS.txt | less #in order to stop looking at the file when the script calls it all you need to press is q
		echo "just read this guide that explains how to set a static IP address and DNS, try whats in the guide and they'll help you get it done!" 
#If our user selects C or c as their answer it will say some text before it cats our txt file for our guide 
	elif [ "$answer2" = C ] || [ "$answer2" = c ]
	then
		cat ./Guides/Traceroute_guide.txt | less
		echo " This guide will help you trace the path that packets are taking when going to a website of your choice, just read it over and youll be all set!" 
     fi
elif [ "$answer" = "centOS" ] || [ "$answer" = "CentOS" ]
then
	echo "great! Now that I know you are on CentOS" 

        echo "Which trouble shooting tips do you want to learn about" 

	echo "A. No Internet connectivity    B. Setting a Static Ip address and DNS   C. Running a trace for a path to a website of your choice" 
	read answer2
     		if [ "$answer2" = A ] || [ "$answer2" = a ]
        	then
#so we are going to call our Trouble shooting guide for Internet connectivity and I decided to go for this route as it was easier for me to understand plus it makes the script not as cluttered and we are using the less command so when it prints out the guide it will make it easier to read       
                	cat ./Guides/Internet_connectivity_CentOS.txt | less
			#if you are having trouble escaping the file once called all you need to do is press q
                	echo " This guide will help you try to fix your Internet connectivity issues just try these steps in here and they might fix your issues!" 
#If our answer was B or since we used || we can say if the asnwer is b it is going to call our Static IP and DNS guide to be printed on the screen
        	elif [ "$answer2" = B ] || [ "$answer2" = b ]
        	then
                	cat ./Guides/CentOS_StaticIP_DNS.txt | less #in order to stop looking at the file when the script calls it all you need to press is q
                	echo "just read this guide that explains how to set a static IP address and DNS, try whats in the guide and they'll help you get it  done!" 
#If our user selects C or c as their answer it will say some text before it cats our txt file for our guide 
        	elif [ "$answer2" = C ] || [ "$answer2" = c ]
        	then
                	cat ./Guides/Traceroute_guideCentOS.txt | less
                	echo " This guide will help you trace the path that packets are taking when going to a website of your choice, just read it over and youll be all set!" 
fi
fi
} | tee ./Logs/Troubleshooting_log$(date +"%m_%d-%Y").txt


