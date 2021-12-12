#!/bin/bash
# Script para comprobar los procesos que hay en el sistema
# Usage: ./checkprocesstime.sh [time]

PROGNAME=$(basename $0)

TEXT_RESET=$(tput sgr0)
TEXT_BOLD=$(tput bold)
TEXT_RED=$(tput setaf 1)

USERS=$(ps --no-headers -A -o user | sort -f | uniq)
time=

error_exit()
{
  echo "${PROGNAME}: ${1:-"Error desconocido"}" 1>&2
  exit 1
}

check_process()
{
  for i in $USERS; do # Bucle para recorrer los usuarios ejecutando mas de un proceso o usuarios conectados en el sistema
    count=0
    for j in $(ps -u $i --no-headers -o pid); do # Bucle para recoger los procesos de los usuarios y guardar su pid
      for k in $(ps --no-headers -p $j -o times); do # Bucle para sacar los tiempos en seg del pid recogido en el anterior bucle
        if [ "$k" -ge "$time" ]; then
          echo "$((count+1))) $(ps -p $j --no-headers -o user,times --sort=-user)"
          count=$((count+1))
        fi
      done
    done
    if [ "$count" == "0" ]; then
      continue
    else
      echo "El usuario ${TEXT_RED}${TEXT_BOLD}$i${TEXT_RESET} tiene $count procesos que cumplen la condición"
      echo
    fi
  done  
}

# Main Function
if [ "$1" == "" ]; then
  error_exit "Introduzca algun tiempo en segundos"
elif [[ ! "$1" =~ ^[0-9]+$ ]]; then # Cualquier caracter diferente a algun numero
  error_exit "El parametro introducido: ${TEXT_BOLD}${TEXT_RED}$1${TEXT_RESET} no soportado"
else
  echo "El tiempo es: $1"
  echo
  time=$1
  check_process
fi

