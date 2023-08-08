#!/usr/bin/env bash
#
# ABOUT
# These functions manage the antivirus
# 
# PROVIDES


#######################################
# what
# Globals:
#   nil
# Arguments:
#   $1
# Outputs:
#   Nil
#######################################
function install_clamav(){
    # get clam installed
    apt install -y clamav clamav-daemon clamtk
    # update the sigs
    systemctl stop clamav-freshclam
    freshclam
    # restart clam
    systemctl start clamav-freshclam
}

#######################################
# what
# Globals:
#   nil
# Arguments:
#   $1
# Outputs:
#   Nil
#######################################
function launch_clamav_gui(){
    (clamtk) &

}

#######################################
# what
# Globals:
#   nil
# Arguments:
#   $1 directory to scan
# Outputs:
#   Nil
#######################################
function launch_clamav_scan(){
    clamscan -i "${1}"

}