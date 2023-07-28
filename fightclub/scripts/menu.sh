#!/usr/bin/env bash
#
# ABOUT
# These functions setup the main selection menu
# 
# PROVIDES
# print_logo
# print_menu
# get_user_selected_option
# execute_option

# define menu options for options array
# This text will be used in the case statement, keep short
# show state
opt_sh_listen="Show listening connections"
opt_sh_svcs="Show services"
opt_sh_process="Show running processes"
# applications
opt_update="Update system and applications"
opt_purge_tools="Purge hacker tools"
# configure settings
opt_set_ssh="Configure SSH"
opt_set_kernel="Configure kernel defaults"
opt_set_shm="Disable /dev/shm"
# script operations
opt_quit="Quit"

# order of array will set order of options
# Place them in reccomended order of execution
A_OPTIONS=("${opt_update}" 
"${opt_sh_listen}" 
"${opt_sh_process}" 
"${opt_sh_svcs}"
"${opt_purge_tools}" 
"${opt_set_ssh}" 
"${opt_set_kernel}" 
"${opt_set_shm}" 
"${opt_quit}" 
)

num_options="${#A_OPTIONS[@]}"


#######################################
# prints the logo to stdout
# Globals:
#   nil
# Arguments:
#   $0 its own name
# Outputs:
#   Nil
#######################################
function print_logo(){
# SCBC FightClub
logo_b64="ICAgX19fX19fX19fX19fICBfX19fXyAgX19fX18gICAgICBfXyAgIF9fICBfX19fX19fICAgICBf\
XyAKICAvIF9fLyBfX18vIF8gKS8gX19fLyAvIF9fKF8pX18gXy8gLyAgLyAvXy8gX19fLyAvXyBf\
Xy8gLyAKIF9cIFwvIC9fXy8gXyAgLyAvX18gIC8gXy8vIC8gXyBgLyBfIFwvIF9fLyAvX18vIC8g\
Ly8gLyBfIFwKL19fXy9cX19fL19fX18vXF9fXy8gL18vIC9fL1xfLCAvXy8vXy9cX18vXF9fXy9f\
L1xfLF8vXy5fXy8KICAgICAgICAgICAgICAgICAgICAgICAgICAgL19fXy8gICAgICAgICAgICAg\
ICAgICAgICAgICAgICAKCg=="
echo "${logo_b64}" | base64 -d
}


#######################################
# Displays a menu - when nort using select funciton
# Globals:
#   A_OPTIONS
# Arguments:
#   $0 itself
# Outputs:
#   Nil
#######################################
function print_menu(){
    # clean slate
    clear 
    # Logo
    print_logo
    #  Show options like
    # 1) "Option"
    for i in in "${!A_OPTIONS[@]}"; do
        printf "${i}) A_OPTIONS[${i}]"
    done
}

#######################################
# gets menu item by number - when not using select funciton
# Globals:
#   A_OPTIONS
#   REPLY
# Arguments:
#
# Outputs:
#   read sets $REPLY
#######################################
function get_user_selected_option(){
    num_options="${#A_OPTIONS[@]}"
    read -p "Enter a action to take 1 to ${num_options}:"
    if (( "${REPLY}" >= 0 &&  "${REPLY}" <= num_options )); then
        execute_option "${A_OPTIONS["${REPLY}"]}" 
    fi
}

#######################################
# Displays a menu
# Globals:
#   logpath
#   reconpath
# Arguments:
#   $1 option by name
# Outputs:
#   Nil
#######################################
function execute_option(){
    case ${1} in
        "${opt_update}")
            write_log_entry "${logpath}" "Executed: ${opt_update}" 
            apt upgrade && apt update -y
            break
            ;;
        "${opt_purge_tools}")
            write_log_entry "${logpath}" "Executed: ${opt_purge_tools}" 
            apt_purge_tools
            snap_remove
            break
            ;;
        "${opt_set_ssh}")
            write_log_entry "${logpath}" "Executed: ${opt_set_ssh}" 
            config_ssh
            break
            ;;
        "${opt_sh_process}")
            write_log_entry "${logpath}" "Executed: ${opt_sh_process}" 
            ps -aux | tee >> "${reconpath}"
            # TODO analyse
            break
            ;;
        "${opt_sh_listen}")
            write_log_entry "${logpath}" "Executed: ${opt_sh_listen}" 
            ss -tlpn | tee >> "${reconpath}"
            # TODO analyse
            break
            ;;
        "${opt_sh_svcs}")
            write_log_entry "${logpath}" "Executed: ${opt_sh_svcs}" 
            systemctl --type=service | tee >> "${reconpath}"
            # TODO analyse against a list
            break
            ;;
        "${opt_set_kernel}")
            write_log_entry "${logpath}" "Executed: ${opt_set_kernel}"
            set_kernel_networking_security
            set_kernel_sysctlconf
            break
            ;;
        "${opt_set_shm}")
            write_log_entry "${logpath}" "Executed: ${opt_set_shm}" 
            disable_shm
            break
            ;;
        "${opt_quit}")
            write_log_entry "${logpath}" "___FINISHED SCBC FIGHTCLUB___" 
            break 2
            ;;
        "*")
            printf "Enter a number from above range only\n"
            break
            ;;
    esac
}


#######################################
# Runs a menu using select
# Globals:
#   nil
# Arguments:
#
# Outputs:
#   Nil
#######################################
function run_select_menu(){
    while true; do
	# can use "${!A_OPTIONS[@]}"  to iteratre by index vs value or use $REPLY
	# break forces the menu to be reprinted 
	printf "Logs are written to: ${logpath}\n"
	select option in "${A_OPTIONS[@]}"; do
        execute_option "${option}"
	done
done
}