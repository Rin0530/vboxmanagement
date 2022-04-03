function __fish_vboxmanage_subcommand --description 'Test if vboxmanage has yet to be given the subcommand'
    for i in (commandline -opc)
        if contains -- $i list startvm controlvm snapshot wait stats
            return 1
        end
    end
    return 0
end

function __fish_print_vboxmanage_vmnames -d 'Print a list of vm names' -a select
    switch $select
        case running
            vboxmanage list -s runningvms | awk '{print $1}' | tr -d '"'
        case all
            vboxmanage list -s vms | awk '{print $1}' | tr -d '"'
        case stopped
            set -l vms (vboxmanage list -s vms | awk '{print $1}' | tr -d '"')
            set -l running (vboxmanage list -s runningvms | awk '{print $1}' | tr -d '"')
            set -l both $vms $running
            echo $both\n | sort | uniq -u | string trim
        end

end

function __fish_is_arg_n --argument-names n
    test $n -eq (count (string match -v -- '-*' (commandline -poc)))
end

complete -c vboxmanage -f -n '__fish_vboxmanage_subcommand' -a list -d 'List vms'
complete -c vboxmanage -A -f -n '__fish_seen_subcommand_from list; and __fish_is_token_n 2' -l long -s l -d 'Show details of each VM'
complete -c vboxmanage -A -f -n '__fish_seen_subcommand_from list; and __fish_is_token_n 2' -l sorted -s s -d 'Show the name and UUID of each VM'
complete -c vboxmanage -A -n '__fish_seen_subcommand_from list' -xa 'vms runningvms ostypes hostdvds hostfloppies' 
complete -c vboxmanage -f -n '__fish_vboxmanage_subcommand' -a startvm -d 'Start VM'
complete -c vboxmanage -A -f -n '__fish_seen_subcommand_from startvm; and __fish_is_nth_token 2' -a '(__fish_print_vboxmanage_vmnames stopped)'
complete -c vboxmanage -A -x -n '__fish_seen_subcommand_from startvm; and __fish_is_nth_token 3' -a '--type=sdl' -d 'Start no button GUI'
complete -c vboxmanage -A -x -n '__fish_seen_subcommand_from startvm; and __fish_is_nth_token 3' -a '--type=headless' -d 'Start headless'
complete -c vboxmanage -A -x -n '__fish_seen_subcommand_from startvm; and __fish_is_nth_token 3' -a '--type=separate' -d 'Start headless changable'
complete -c vboxmanage -f -n '__fish_vboxmanage_subcommand' -a controlvm -d 'Control VM'
complete -c vboxmanage -A -f -n '__fish_seen_subcommand_from controlvm; and __fish_is_arg_n 2' -a '(__fish_print_vboxmanage_vmnames running)'
complete -c vboxmanage -A -f -n '__fish_seen_subcommand_from controlvm; and __fish_is_arg_n 3' -a 'poweroff' -d 'Shutdown vm'
complete -c vboxmanage -A -f -n '__fish_seen_subcommand_from controlvm; and __fish_is_arg_n 3' -a 'acpipowerbutton' -d 'ACPIshutdown vm'
complete -c vboxmanage -A -f -n '__fish_seen_subcommand_from controlvm; and __fish_is_arg_n 3' -a 'reset' -d 'Reset vm'
complete -c vboxmanage -f -n '__fish_vboxmanage_subcommand' -a snapshot -d 'Control snapshot'
complete -c vboxmanage -A -f -n '__fish_seen_subcommand_from snapshot; and __fish_is_arg_n 2' -a '(__fish_print_vboxmanage_vmnames all)'
complete -c vboxmanage -A -f -n '__fish_seen_subcommand_from snapshot; and __fish_is_arg_n 3' -a 'take' -d '[name] Create snapshot'
complete -c vboxmanage -A -f -n '__fish_seen_subcommand_from snapshot; and __fish_is_arg_n 3' -a 'delete' -d '[name] Delete snapshot'
complete -c vboxmanage -A -f -n '__fish_seen_subcommand_from snapshot; and __fish_is_arg_n 3' -a 'restorecurrent' -d 'Restore latest snapshot'
complete -c vboxmanage -A -f -n '__fish_seen_subcommand_from snapshot; and __fish_is_arg_n 3' -a 'restore' -d '[name] Restore select snapshot'
