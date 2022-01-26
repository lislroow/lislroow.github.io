#!/bin/bash

shopt -s extglob

BASEDIR="$( cd $( dirname "$0" ) && pwd -P)"

function AlertMsg() {
  cscript /e/util/script/MessageBox.vbs "$@"
}

function GetUniqDir() {
  local origin="$1"
  if [ ! -e "${origin}" ]; then
    echo "${origin}"
  else
    for((i=1; i<2001; i++));
    do
      local next_dir="${origin}-${i}"
      if [ ! -e "${next_dir}" ]; then
        echo "${next_dir}"
        break;
      fi
    done
  fi
}

function GetUniqFile() {
  local origin="$1"
  if [ ! -e "${origin}" ]; then
    echo "${origin}"
  else
    for((i=1; i<2001; i++));
    do
      local next_file="${origin%.*}-${i}.${origin##*.}"
      if [ ! -e "${next_file}" ]; then
        echo "${next_file}"
        break;
      fi
    done
  fi
}


function backup() {
  local targets=()
  case "$1" in
    all)
      targets+=("centos")
      targets+=("eclipse")
    ;;
    centos)
      targets+=("centos")
    ;;
    eclipse)
      targets+=("eclipse")
    ;;
  esac
  
  curr_date=`date +'%Y%m%d'`
  
  for target in "${targets[@]}"
  do
    case "${target}" in
      centos)
        # backup [centos8-develop]
        local bak_dir=$(GetUniqDir "/e/centos8-develop_${curr_date}")
        echo "bak_dir=${bak_dir}"
        mkdir "${bak_dir}"
        cp -R /z/centos8-develop/* "${bak_dir}"
      ;;
      eclipse)
        # backup [develop]
        local bak_file=$(GetUniqFile "/e/develop_${curr_date}.zip")
        echo "bak_file=${bak_file}"
        /e/util/7z/7za.exe a -mx1 -mmt "${bak_file}" /z/develop
      ;;
    esac
  done
}

function off() {
  rundll32.exe powrprof.dll SetSuspendState
}

case "$1" in
  @(c)@(entos)*)
    backup "centos";
  ;;
  @(e)@(clipse)*)
    backup "eclipse";
  ;;
  *)
    backup "all";
  ;;
esac

AlertMsg "backup complete: ${BASEDIR}/${0##*/} $1"
