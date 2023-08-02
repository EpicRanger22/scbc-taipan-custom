#!/usr/bin/env bash
#
# ABOUT
# These functions recon the system
# 
# PROVIDES
# recon_get_processes
# recon_get_services
# recon_get_listening

#######################################
# what
# Globals:
#   nil
# Arguments:
#   $0 its own name
# Outputs:
#   Nil
#######################################
function get_system_recon(){
    ps -aux  >> "${reconpath}"
    ss -tlpn >> "${reconpath}"
    systemctl --type=service >> "${reconpath}"
    
} 

#######################################
# what
# Globals:
#   nil
# Arguments:
#   $0 its own name
# Outputs:
#   Nil
#######################################
function recon_get_processes(){
    write_log_entry "${reconpath}" "====== running processestree view\n"
    pstree -p >> "${reconpath}"
    write_log_entry "${reconpath}" "====== running processes\n "
    ps -aux >> "${reconpath}"
    
}

#######################################
# what
# Globals:
#   nil
# Arguments:
#   $0 its own name
# Outputs:
#   Nil
#######################################
function recon_get_services(){
    write_log_entry "${reconpath}" "====== services"
    systemctl --type=service >> "${reconpath}"
    # TODO analyse against a list
}

#######################################
# what
# Globals:
#   nil
# Arguments:
#   $0 its own name
# Outputs:
#   Nil
#######################################
function recon_get_listening(){
    write_log_entry "${reconpath}" "====== listening services; look here for anything that should not be running\n"
    ss -tlpn | egrep --color=always -i '^|sshd|systemd-resolve|cupsd' >> "${reconpath}"
}

#######################################
# WIP
# Globals:
#   nil
# Arguments:
#   $0 its own name
# Outputs:
#   Nil
#######################################
function analyse_recondata(){
    #printf "todo\n"
    sleep 2
    
}

#######################################
# WIP
# Globals:
#   nil
# Arguments:
#   $0 its own name
# Outputs:
#   Nil
#######################################
function check_for_admins(){
    grep -i sudo /etc/group
    grep -i adm /etc/group
    
}

#######################################
# WIP
# Globals:
#   nil
# Arguments:
#   $0 its own name
# Outputs:
#   Nil
#######################################
function check_recently_installed(){
    write_log_entry "${reconpath}" "====== recently installed apps\n"
    #use apt search <appname>
    
    grep -i 'install\s' /var/log/dpkg.log* >> "${reconpath}"
    zgrep -i 'install\s' /var/log/dpkg.log.*.gz >> "${reconpath}"
    
}