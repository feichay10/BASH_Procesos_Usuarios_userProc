#!/bin/bash

# Alummno: Cheuk Kelly Ng Pante
# Correo Institucional: alu0101364544@ull.edu.es
# Universidad de La Laguna - Ingeniería Informática
# Asignatura: Sistemas Operativos
# Practica de BASH Procesos de Usuarios
# Enlaces de interes:
#     - https://reactgo.com/bash-get-first-character-of-string/#:~:text=To%20access%20the%20first%20character,position%20of%20a%20string%20extraction.
#     - https://linuxhint.com/bash_append_array/
#     - https://linuxconfig.org/how-to-use-arrays-in-bash-script
#     - https://stackoverflow.com/questions/7442417/how-to-sort-an-array-in-bash
#     - https://www.cyberciti.biz/faq/unix-howto-read-line-by-line-from-file/

echo

##### Variables y Constantes #####
PROGNAME=$(basename $0)
USERS=$(ps -A --no-headers -o user:16,time --sort=-time)
USERS_CONT=
USERS_U=
cont=0
us=0
time=1
count=0
num_process=
inv=0
pid=0
arrUser=()
arrUser_=()
arrInter=()
arrPid=()

##### Estilos #####
TEXT_BOLD=$(tput bold)
TEXT_RESET=$(tput sgr0)
TEXT_ULINE=$(tput sgr 0 1)
TEXT_RED=$(tput setaf 1)
TEXT_PURPLE=$(tput setaf 5)
TEXT_YELLOW=$(tput setaf 3)
TEXT_BLUE_CYAN=$(tput setaf 6)

##### Funciones #####
error_exit()
{
  echo "${PROGNAME}: ${1:-"Error desconocido"}" 1>&2
  exit 1
}

usage()
{
  echo "${TEXT_BOLD}${TEXT_RED}usage: ./$PROGNAME [-t N] [-usr] [-u user] [-count] [-inv] [-pid] [-c] [-h]${TEXT_RESET}"
  echo "
  ${TEXT_BOLD}${TEXT_PURPLE}[-t N]${TEXT_RESET}: Indica el tiempo de CPU consumido mayor que N, si no se pasa ningún parametro N será 1 segundo
  ${TEXT_BOLD}${TEXT_PURPLE}[-usr]${TEXT_RESET}: Muestra solo los usuarios conectados en el sistema actualmente
  ${TEXT_BOLD}${TEXT_PURPLE}[-u user]${TEXT_RESET}: Muestra los procesos de un usuario en especifico
  ${TEXT_BOLD}${TEXT_PURPLE}[-count]${TEXT_RESET}: Muestra el numero de procesos por usuario que cumplan las condiciones de tiempo de ejecución
  ${TEXT_BOLD}${TEXT_PURPLE}[-inv]${TEXT_RESET}: La ordenacion se realizará de forma inversa
  ${TEXT_BOLD}${TEXT_PURPLE}[-pid]${TEXT_RESET}: La ordenación se realizará por el PID"
}

# Funcion para comprobar si existe un usuario, si no existe, error_exit
check_user()
{
  id $user > /dev/null 2> /dev/null || error_exit "El usuario ${TEXT_BOLD}${TEXT_RED}$user${TEXT_RESET} no existe en el sistema"
}

func_default()
{
  # echo "El tiempo es: $time"
  # echo "El contador es: $cont"
  if [ "$us" == "1" ]; then
    for i in $USERS; do
      while read line; do
        usuario=$(echo $line | awk '{print $1}')
        tiempo=$(echo $line | tr ':' ' ' | awk '{print $2*3600+$3*60+$4}')
        if [ "$tiempo" -ge "$time" ]; then
          arrUser_+=($usuario)
          count=$((count+1))
        else
          break
        fi
      done <<< $(ps -u $i --no-headers -o user:16,time --sort=-time)
    done
    filter_ord
  else
    while read line; do
      usuario=$(echo $line | awk '{print $1}')
      tiempo=$(echo $line | tr ':' ' ' | awk '{print $2*3600+$3*60+$4}')
      if [ "$tiempo" -ge "$time" ]; then
        arrUser+=($usuario)
        count=$((count+1))
      else
        break
      fi
    done <<< $USERS
    filter_ord
  fi

  IFS=$'\n' uniqued=($(uniq <<<"${sorted[*]}")); unset IFS #IFS=$'\n' --> pone a '\n' como delimitador, convirtiendo a cada linea un elemento, esto lo hago porque sort o uniq opera por lineas
  USERS=${uniqued[@]}                                      # <<< --> hace la expansión del array y le mete la entrada estandar a => sort o uniq
  show_users                                               # unset IFS --> restablece el valor predeterminado de IFS
}

func_contador()
{
  for i in $USERS_CONT; do
    count=0
    for j in $(ps -u $i -o time --no-headers | tr ':' ' ' | awk '{print $1*3600+$2*60+$3}'); do
      if [ "$j" -ge "$time" ]; then
        count=$((count+1))
      fi  
    done
    if [ "$count" == "0" ]; then
      continue
    else
      num_process=$count
    fi
  done
}

filter_ord()
{
  if [ "$pid" == "1" ]; then
    if [ "$us" == "1" ]; then
      IFS=$'\n' sorted=($(sort <<<"${arrUser_[*]}")); unset IFS # Ordena el array, los usuarios
    else
      IFS=$'\n' sorted=($(sort <<<"${arrUser[*]}")); unset IFS  # Ordena el array, los usuarios
    fi

    IFS=$'\n' uniqued=($(uniq <<<"${sorted[*]}")); unset IFS # Coge el array de usuarios ordenados y coge los elementos unicos del array

    # Bucle para añadir los usuarios unicos del array uniqued a otro array
    for i in ${uniqued[@]}; do
      arrPid+=($(ps -u $i --no-headers -o pid --sort=-time | head -n 1 | awk '{print $1}'))
    done
    
    if [ "$inv_" == "-r" ]; then
      IFS=$'\n' sorted=($(sort -n -r <<<"${arrPid[*]}")); unset IFS # Ordena el array de forma numerica (PID) a la inversa en caso de que se active el flag 
    else
      IFS=$'\n' sorted=($(sort -n <<<"${arrPid[*]}")); unset IFS # Ordena el array de forma numerica (PID)
    fi

    arrPid=()  # Borra los elementos del array

    # Bucle para coger los usuarios de los pid´s guardados en el array --> arrPid()
    for pid_ in ${sorted[@]}; do
      arrPid+=($(ps --no-headers -p $pid_ -o user))
    done

    USERS=${arrPid[@]}
    show_users
    exit 0
  elif [ "$inv" == "1" ]; then
    if [ "$us" == "1" ]; then
      IFS=$'\n' sorted=($(sort -r <<<"${arrUser_[*]}")); unset IFS # Ordena de forma inversa el array que contiene los usuarios
    else
      IFS=$'\n' sorted=($(sort -r <<<"${arrUser[*]}")); unset IFS # Ordena de forma inversa el array que contiene los usuarios
    fi
  else
    if [ "$us" == "1" ]; then
      IFS=$'\n' sorted=($(sort <<<"${arrUser_[*]}")); unset IFS # Ordena el array que contiene los usuarios
    else
      IFS=$'\n' sorted=($(sort <<<"${arrUser[*]}")); unset IFS # Ordena el array que contiene los usuarios
    fi
  fi
}

show_users()
{
  if [ "$USERS" == "" ]; then
    echo "No hay ningun usuario que cumpla con la condición de tiempo=$time segundos"
  else
    printf "%-26s %-3s %-15s %-3s %-15s %-3s %-22s %-3s %-33s %-3s %-12s\n" "${TEXT_BOLD}USER${TEXT_RESET}" "|" "${TEXT_BOLD}UID${TEXT_RESET}" "|" "${TEXT_BOLD}GID${TEXT_RESET}" "|" "${TEXT_BOLD}Num_Process${TEXT_RESET}" "|" "${TEXT_BOLD}PID_Process_more_time${TEXT_RESET}" "|" "${TEXT_BOLD}Total_Time_Process_consume${TEXT_RESET}"
    printf "=================|=========|=========|================|===========================|===============================\n"
    for i in $USERS; do
    if [ "$cont" == "1" ]; then
      USERS_CONT=$i
      func_contador
    else
      num_process=$(ps -u $i --no-headers | wc -l)
    fi
      printf "%-16s %-3s %-5s %-3s %-5s %-3s %-12s %-3s %-23s %-3s %-20s\n" "$i" "|" "$(id -u $i)" "|" "$(id -G $i | awk '{print $1}')" "|" "$num_process" "|" "$(ps -u $i --no-headers -o pid --sort=-time | head -n 1 | awk '{print $1}')" "|" "$(ps -u $i --no-headers -o time --sort=-time | head -n 1)"
    done
  fi
}

if [ "$1" == "" ]; then
  func_default
else
  while [ "$1" != "" ]; do
    case $1 in
      -t )
        if [ "$2" == "" ] || [ "$(echo ${2:0:1})" == "-" ]; then 
          time=1
        elif [[ ! "$2" =~ ^[0-9]+$ ]]; then # Si se introduce cualquier caracter diferente a algun numero --> error_exit
          error_exit "El parametro introducido: ${TEXT_BOLD}${TEXT_RED}$2${TEXT_RESET} no soportado"
        else  
          time=$2
          shift
        fi
      ;;
      -usr ) 
        USERS_WHO=$(who | awk '{print $1}' | sort -f | uniq)
        USERS=$USERS_WHO
        us=1
        usr_=1 # Para hacer la interseccion de -u -usr
      ;;
      -u )
        if [ "$2" == "" ] || [ "$(echo ${2:0:1})" == "-" ]; then
          error_exit "Debe introducir algun usuario despues de la opcion -u"
        fi
        while [ "$2" != "" ]; do
          if [ "$(echo ${2:0:1})" == "-" ]; then   # Cojo el primer caracter de un string para ver si es una opcion "-" y lo comparo 
            break
          else
            user=$2 # Variable para llevar $2 a la funcion check_user y comprobar que ese usuario existe en el sistema
            check_user 
            arrUser+=($2)
          fi
          shift
        done
        us=1
        u_=1  # Para hacer la interseccion de -u -usr
        USERS_U=${arrUser[@]}
        USERS=$USERS_U
      ;;
      -count )
        cont=1
        ;;
      -inv )
        inv=1
        inv_=-r # Var bool para que en caso de que se ejecute -pid -inv a la vez haga la inversa del pid
      ;;
      -pid )
        pid=1
      ;;
      -c )
        c=1
      ;;
      -h | --help )
        usage
        echo
        exit 0
      ;;
      *)
        error_exit "${TEXT_BOLD}${TEXT_RED}La opción introducida no está disponible${TEXT_RESET}"
    esac
    shift
  done

  # Intersección de -u y -usr
  if [ "$usr_" == "1" ] && [ "$u_" == "1" ]; then
    for i in $USERS_WHO; do
      for j in $USERS_U; do
        if [ "$i" == "$j" ]; then
          arrInter+=($j)
        fi
      done
    done  
    USERS=${arrInter[@]}
  fi

  # Llamada a la funcion principal
  func_default
fi

echo