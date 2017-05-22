#!/bin/bash

SSH_FILE="/home/augustomarinho/.ssh_machines"
SSH_TEMP_FILE="/home/augustomarinho/.ssh_machines.tmp"
MACHINE_NUMBER=1
MACHINES=${MACHINES:-}
SELECTION=${SELECTION:-"0"}
USER=${USER:-`id -u -n`}

listar_maquinas () {
echo "LISTA DE MAQUINAS"
while IFS='' read -r MACHINES || [[ -n "$MACHINES" ]]; do
    echo $MACHINE_NUMBER") " $MACHINES
    let "MACHINE_NUMBER++"
    echo $MACHINES >> $SSH_TEMP_FILE
done < $SSH_FILE |  sed -r 's/;/       /g'
}

filtrar_maquinas () {
MINLEN=2
#clear
#echo "Start typing (minimum $MINLEN characters)..." 
# get one character without need for return 
while read -n 1 -s i 
do
    # get ascii value of character to detect backspace
    n=`echo -n $i|od -i -An|tr -d " "`
    if (( $n == 47 ))
    then 
       ler_opcao
       break
    elif (( $n == 127 )) # if character is a backspace...
    then 
        if (( ${#in} > 0 )) # ...and search string is not empty
        then 
            in=${in:0:${#in}-1} # shorten search string by one
            # could use ${in:0:-1} for bash >= 4.2 
        fi
    elif (( $n == 27 )) # if character is an escape...
    then
        #exit 0 # ...then quit
        echo "Bye"
        echo "$line"
        exit 0
    else # if any other char was typed... 
        echo $n
        in=$in$i # add it to the search string
    fi
    clear 
    echo "Search: \""$in"\"" # show search string on top of screen
    if (( ${#in} >= $MINLEN )) # if search string is long enough...
    then    
        #find "$@" -iname "*$in*" $SSH_FILE # ...call find, pass it any parameters given
        #grep -R $in $MACHINES

        while IFS='' read -r line || [[ -n "$line" ]]; do
          if echo "$line" | grep -q "$in"; then
              echo $MACHINE_NUMBER") " $line
              echo $line >> $SSH_TEMP_FILE
              let "MACHINE_NUMBER++"
          fi
        done < $SSH_FILE | sed -r 's/;/       /g'
    fi
done
}

conectar_ssh () {
  MACHINE=$(sed "${SELECTION}q;d" $SSH_TEMP_FILE | cut -d ';' -f 2)
  #echo "ssh $USER@"$MACHINE
  ssh $USER"@"$MACHINE
}

ler_opcao () {
  echo -n "Qual maquina conectar ? (0) filtar "
  read SELECTION

case "$SELECTION" in
        "0")
            filtrar_maquinas
            ;;
        *)
            conectar_ssh
            exit 1
esac
}

limpar_temps () {
  touch $SSH_TEMP_FILE
  rm $SSH_TEMP_FILE
}


#MAIN SCRIPT
if [ ! -z "$1" ]; then
  USER=$1
fi

limpar_temps
listar_maquinas
ler_opcao
