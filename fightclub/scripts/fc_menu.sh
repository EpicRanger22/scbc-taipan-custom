#!/usr/bin/env bash
#
# ABOUT
# These functions setup the main selection menu
#
# ADDING AN OPTION
# 1. add a new option variable and assign a dsiplay name
# 2. add the option to the option array; this is the display order
# 3. add a case statemeent and execution instructions to the function "execute_option"
# 
# PROVIDES
# print_logo
# print_menu
# get_user_selected_option
# execute_option

# 1
# define menu options for options array
# This text will be used in the case statement, keep short
# show state
opt_sh_tips="FightClub: show tips"
opt_sh_listen="RECON: listening connections"
opt_sh_svcs="RECON: active services"
opt_sh_process="RECON: running processes"
# applications
opt_update="APPS: Update system and applications"
opt_purge_tools="APPS: Purge hacker tools"
opt_purge_services="APPS: remove likely uneeded services"
opt_rm_snap="APPS: Remove snap package manager"
opt_launch_updates_config_gui="APPS: launch 'Software & Updates' GUI"
# configure settings
opt_set_ssh="CONFIG: Configure SSH"
opt_set_banners="CONFIG: set login banners"
opt_set_account_policies="CONFIG: set password and account policies"
opt_set_kernel="CONFIG: set kernel defaults"
opt_set_audit="CONFIG: set audit policies"
opt_set_shm="CONFIG: Disable /dev/shm"

# forensics
opt_find_media_files="FORENSICS: Find media files"
# tips
# unlock account when locked
# script operations
opt_quit="FightClub: Quit"
opt_show_functions="FightClub: Show available functions"
opt_clean_menu="FightClub: Redisplay  menu"

# 2
# order of array will set order of options
# Place them in reccomended order of execution
A_OPTIONS=("${opt_quit}"
"${opt_sh_tips}"
"${opt_sh_listen}" 
"${opt_sh_process}" 
"${opt_sh_svcs}"
"${opt_launch_updates_config_gui}"
"${opt_purge_tools}"
"${opt_purge_services}"
"${opt_update}"
"${opt_rm_snap}" 
"${opt_set_ssh}"
"${opt_set_banners}" 
"${opt_set_account_policies}"
"${opt_set_audit}"
"${opt_set_kernel}" 
"${opt_set_shm}"
"${opt_find_media_files}"
"${opt_clean_menu}"
"${opt_show_functions}" 
)

num_options="${#A_OPTIONS[@]}"
# array for tracking number of runs per option, initialised to 0 using shell paremeter expansion syntax
# https://www.gnu.org/software/bash/manual/bash.html#Shell-Parameter-Expansion
a_option_runs=("${A_OPTIONS[@]/*/0}")


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
    # Logo
    print_logo
    #  Show options like
    # 1) "Option"
    for i in "${!A_OPTIONS[@]}"; do
        col1="${i})"
        col2="${A_OPTIONS[${i}]}"
        col3="(Runs: ${a_option_runs[${i}]})"
        #printf "${i}) ${A_OPTIONS[${i}]}\t\t\t(Run count: ${a_option_runs[${i}]})\n"
        #paste <(printf %s "${col1}") <(printf %s "${col3}")
        printf "${col1} ${col2}  ${col3}\n"
        
    done
}

#######################################
# Displays a new menu on clean screen
# Globals:
#   A_OPTIONS
# Arguments:
#   $0 itself
# Outputs:
#   Nil
#######################################
function print_clean_menu(){
    #clear 
	print_menu
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
    read -p "Enter a action to take 0 to ${num_options}:"
    if (( "${REPLY}" >= 0 &&  "${REPLY}" <= num_options )); then
        execute_option "${A_OPTIONS["${REPLY}"]}" 
    fi
}

# 3
#######################################
# executes an option when called
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
        "${opt_sh_tips}")
            cat "$(dirname "${0}")/tips.md"
            ;;
        ### recon
        "${opt_sh_process}")
            write_log_entry "${logpath}" "Executed: ${opt_sh_process}" 
            recon_get_processes
            echo "Check here for output: ${reconpath}"
            # TODO analyse
            ;;
        "${opt_sh_listen}")
            write_log_entry "${logpath}" "Executed: ${opt_sh_listen}" 
            recon_get_listening
            echo "Check here for output: ${reconpath}"
            # TODO analyse
            ;;
        "${opt_sh_svcs}")
            write_log_entry "${logpath}" "Executed: ${opt_sh_svcs}" 
            recon_get_services
            echo "Check here for output: ${reconpath}"
            ;;
        #### applications
        "${opt_launch_updates_config_gui}")
            write_log_entry "${logpath}" "Executed: ${opt_launch_updates_config_gui}"
            printf "Launching gui now\n"
            printf "Enable security updates, and auto install"
            printf ""
            launch_updates_config_gui
            ;;
        "${opt_update}")
            write_log_entry "${logpath}" "Executed: ${opt_update}" 
            apt upgrade && apt update -y
            ;;
        "${opt_purge_tools}")
            write_log_entry "${logpath}" "Executed: ${opt_purge_tools}" 
            # TODO read to confirm
            apt_purge_tools
            apt_purge_games
            snap_remove
            printf "apt and snap tools uninstalled\n"
            ;;
        "${opt_purge_services}")
            write_log_entry "${logpath}" "Executed: ${opt_purge_services}"
            apt_purge_servcies
            printf "Services uninstalled\n"
            ;;
        "${opt_rm_snap}")
            write_log_entry "${logpath}" "Executed: ${opt_rm_snap}"
            #snap_remove_named_tools
            snap_remove_all_installed
            #remove_snapd
            #snap_prevent_reinstall
            ;;
        ### secure config
        "${opt_set_ssh}")
            write_log_entry "${logpath}" "Executed: ${opt_set_ssh}"
            config_ssh_banner "./rsc/banner.txt"
            config_ssh
            printf "SSH configured\n"
            ;;
        "${opt_set_banners}")
            write_log_entry "${logpath}" "Executed: ${opt_set_banners}"
            set_motd_terminal
            set_gnome_login_banner
            set_banner_permissions
            echo "Banners configured."
            ;;
        "${opt_set_account_policies}")
            write_log_entry "${logpath}" "Executed: ${opt_set_account_policies}"
            lock_root
            set_login_defaults
            set_lockout_policy
            disable_guest_account
            set_password_complexity
            echo "Account policies configured."
            ;;
        "${opt_set_audit}")
            write_log_entry "${logpath}" "Executed: ${opt_set_audit}"
            remove_bash_history_symlink
            echo "Audit policies configured."
            ;;
        "${opt_set_kernel}")
            write_log_entry "${logpath}" "Executed: ${opt_set_kernel}"
            set_kernel_networking_security
            set_kernel_sysctlconf
            set_kernel_memory_protections
            echo "Reccomended secure kernel defaults configured."
            ;;
        "${opt_set_shm}")
            write_log_entry "${logpath}" "Executed: ${opt_set_shm}" 
            disable_shm
            printf "\dev\shm is now read only.\n"
            ;;
        ### forensics
        "${opt_find_media_files}")
            write_log_entry "${logpath}" "Executed: ${opt_find_media_files}"
            read -p "Enter a path to search like '/home': "
            find_media_files_by_type "${REPLY}"
            ;;
        ## fightclub specific
        "${opt_clean_menu}")
            print_clean_menu
            ;;
        "${opt_show_functions}")
            printf "Caution, not all of these functions are tested.\n"
            a_functions=("$(declare -F | awk '{print $3}')")
            echo "${a_functions}"
            #read -p "Enter a function name to run: "
            ;;
        "${opt_quit}")
            write_log_entry "${logpath}" "___FINISHED SCBC FIGHTCLUB___" 
            # print check logfiles
            printf "Thank you for using SCBC FightClub!\n\n"
            exit 0
            ;;
        "*")
            printf "Enter a number from above range only\n"
            ;;
    esac
    increment_option_runcount
}

#######################################
# increment option runs
# Globals:
#   A_OPTIONS
# Arguments:
#   $0 itself
# Outputs:
#   Nil
#######################################
function increment_option_runcount(){
    (( a_option_runs["${REPLY}"]++ ))
}

