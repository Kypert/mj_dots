function info_trapper
    set --local options (fish_opt --short=h --long=help)
    set options $options (fish_opt --short=s --long='source' --required-val)
    set options $options (fish_opt --short=m --long='modifier' --required-val --multiple-vals)
    set options $options (fish_opt --short=c --long='command' --required-val)
    set options $options (fish_opt --short=d --long='display' --required-val)
    set options $options (fish_opt --short=i --long='interactive')

    # Open all files (arguments) in separate tabs
    set --local display_default "vim -c 'tab all' "

    # Grab the sources from stdin, if possible
    set --local sources
    if not isatty stdin
        set --local g
        while read g
            set --append sources $g
        end
        if test (count $sources) -gt 0
            set --prepend argv "-s stdin" # trick argparse
        end
    end

    argparse -i $options -- $argv
    if set --query _flag_help
        printf "Usage: %s [OPTIONS]\n\n" (status function)
        printf "Options:\n"
        printf "  -h/--help        Prints help and exits\n"
        printf "  -s/--source      Gather sources\n"
        printf "  -m/--modifier    Modify sources, e.g transform and/or filter, can be multiple\n"
        printf "  -c/--command     Perform a command using each source\n"
        printf "  -d/--display     Optionally adjust the display routine, defaults to: %s\n" $display_default
        printf "  -i/--interactive No collection, only fixing sources and displaying them\n"
        printf "\n"
        printf "Examples:\n"
        printf "  Display the log of each redis pod:\n"
        printf "  %s %s\n" (status function) '-s "kc get pods -n emrapet" -m "grep kvdb-rd-server" -m "awk \'{print \$1}\'" -c "kubectl logs -n emrapet {} eric-pc-kvdb-rd-server"'
        printf "\n"
        printf "  Display the log of each pfcp-endpoint pod, using kubefilter:\n"
        printf "  %s %s\n" (status function) '-s "kc get pods -n emrapet" -m "grep pfcp-endpoint" -m "awk \'{print \$1}\'" -c "kubectl logs -n emrapet {} | kubefilter_no_paging"'
        printf "\n"
        printf "  Display the log of each pfcp-endpoint pod, again, but piping in the source:\n"
        printf "  %s %s\n" (status function) '-s "kc get pods -n emrapet | grep pfcp-endpoint | awk \'{print \$1}\'" -c "kubectl logs -n emrapet {} | kubefilter_no_paging"'
        printf "\n"
        printf "  Display the log of each pfcp-endpoint pod, again, again, but reading sources from stdin:\n"
        printf "  %s %s %s\n" "kc get pods -n emrapet | grep pfcp-endpoint | awk '{print \$1}' |" (status function) '-c "kubectl logs -n emrapet {} | kubefilter_no_paging"'
        printf "\n"
        printf "  Get all redis pods and run 'redis-cli info' in each of them:\n"
        printf "  %s %s\n" (status function) '-s "kc get pods -n emrapet" -m "grep kvdb-rd-server" -m "awk \'{print \$1}\'" -c "ssh -t eccd@pccc-337-3 kubectl exec -it -n emrapet {} eric-pc-kvdb-rd-server -- redis-cli info"'
        printf "\n"
        printf "  Get all redis pods and run 'redis-cli' in each of them, but staying interactive:\n"
        printf "  %s %s\n" (status function) '-s "kc get pods -n emrapet" -m "grep kvdb-rd-server" -m "awk \'{print \$1}\'" -c "\-c \'edit term://ssh -t eccd@pccc-337-3 kubectl exec -it -n emrapet {} eric-pc-kvdb-rd-server -- redis-cli\'" --interactive'
        return 0
    end

    if not set --query _flag_source
        echo "Source is mandatory, see help."
        return 0
    end

    set --query _flag_display; or set --local _flag_display $display_default

    # echo "source: $_flag_source"
    # for i in (seq (count $_flag_modifier))
    #     echo "modifier: $_flag_modifier[$i]"
    # end
    # echo "command: $_flag_command"
    # echo "display: $_flag_display"

    if test (count $sources) -eq 0
        set sources (eval $_flag_source)
    end

    # Step 1: Run all modifiers
    for i in (seq (count $_flag_modifier))
        # echo "Evaluating modifier: $_flag_modifier[$i]"
        set --local work_area
        for k in (seq (count $sources))
            # Use string escape since the source can have embedded ()
            set --local cmd echo -e (string escape $sources[$k]) \| $_flag_modifier[$i]
            # echo "Evaluating: $cmd"
            set --append work_area (eval $cmd)
        end
        set sources $work_area
    end

    # Step 2: Collect the data
    set --local tmp_files
    set --local output
    if not set --query _flag_interactive
        for i in (seq (count $sources))
            set --local tmp (mktemp /tmp/$sources[$i].XXXXXX.log)

            # User can put the source in a special place or just append it in the back of the command
            if echo $_flag_command | grep -q "{}"
                eval (string replace "{}" $sources[$i] $_flag_command) >> $tmp
            else
                eval $_flag_command $sources[$i] >> $tmp
            end
            set --append tmp_files $tmp
            set --append output $tmp
        end
    else
        for i in (seq (count $sources))
            set --local tmp
            # User can put the source in a special place or just append it in the back of the command
            if echo $_flag_command | grep -q "{}"
                set tmp (string replace "{}" $sources[$i] $_flag_command)
            else
                set tmp (string join " " $_flag_command $sources[$i])
            end
            set --append output $tmp
        end

        # Make all buffers appear in separate tabs
        set --append output "\-c 'tab sball'"
    end

    # Step 3: Show the data
    eval (string join " " $_flag_display $output)

    # Step 4: Cleanup the tempfiles
    for i in (seq (count $tmp_files))
        rm $tmp_files[$i]
    end
end
