#!/usr/bin/env bash

set -e

show_usage() {
  echo "Usage: $(basename $0) takes exactly 1 argument (install | uninstall)"
}

if [ $# -ne 1 ]
then
  show_usage
  exit 1
fi

check_env() {
  if [[ -z "${RALPM_TMP_DIR}" ]]; then
    echo "RALPM_TMP_DIR is not set"
    exit 1
  
  elif [[ -z "${RALPM_PKG_INSTALL_DIR}" ]]; then
    echo "RALPM_PKG_INSTALL_DIR is not set"
    exit 1
  
  elif [[ -z "${RALPM_PKG_BIN_DIR}" ]]; then
    echo "RALPM_PKG_BIN_DIR is not set"
    exit 1
  fi
}

install() {
  wget https://github.com/AttifyOS/nmap/releases/download/v7.92/nmap_7.92_amd64.snap -O $RALPM_TMP_DIR/nmap_7.92_amd64.snap
  sudo snap install $RALPM_TMP_DIR/nmap_7.92_amd64.snap --devmode
  sudo snap connect nmap:network-control
  rm $RALPM_TMP_DIR/nmap_7.92_amd64.snap
  echo "==============================="
  echo "To run nmap as root please add /snap/bin in sudoers secure_path"
  echo "More info: https://askubuntu.com/q/1402370"
  echo "==============================="

}

uninstall() {
  sudo snap remove nmap
}

run() {
  if [[ "$1" == "install" ]]; then 
    install
  elif [[ "$1" == "uninstall" ]]; then 
    uninstall
  else
    show_usage
  fi
}

check_env
run $1