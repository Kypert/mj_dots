set --local vim_bin /home/$USER/neovim/build/bin/nvim
set --local rg_bin /home/$USER/proj/ripgrep/target/release/rg
set --local alacritty_bin /home/$USER/proj/alacritty/target/release/alacritty

set -x EDITOR $vim_bin
set -x BAT_THEME Dracula
set -x GIT_EDITOR $vim_bin

set -g -x PATH $PATH /usr/local/go/bin
set -g -x PATH $PATH $HOME/go/bin

if not status is-interactive
    return
end

# Commands to run in interactive sessions can go here
fish_config theme choose kanagawa
alias rg (echo $rg_bin)
alias nvim (echo $vim_bin)
alias vi (echo $vim_bin)
alias vim (echo $vim_bin)
alias vim_no_cfg (echo $vim_bin -u NONE)
alias alacritty (echo $alacritty_bin)

function gitme
    set --local me (finger $USER | grep -Eo "Name: (.*)" | cut -b (echo "Name: " | wc -c)-)
    git log --author="$me"
end
alias cdrr        'cd (git root)'
alias cdproj      'cd $HOME/proj'
alias gitclean    'git clean -xdff'
alias gitsub      'git submodule update --init'
alias gitsubr     'git submodule update --init --recursive'
alias gitsubclean 'git submodule foreach --recursive git clean -ffdx'
alias gits        'git status'
alias gitb        'git branch -vv'
alias gitp        'git push origin HEAD:refs/for/master'

function gitlog_without_scm
    # Log of two commitish, excluding up/VERSION_PREFIX changes
    git log $argv[1] -- $argv[2] ':^up/VERSION_PREFIX'
end

function tigdiff
    # Diff two commitish, excluding up/VERSION_PREFIX changes
    tig $argv[1] -- $argv[2] ':^up/VERSION_PREFIX'
end

function fix_sp_trailing
    # Remove empty lines and then \r from given file, support_package files
    sed -i '/^$/d' $argv[1] && sed -i 's/\r$//' $argv[1]
end

alias tmuxfire  '~/.tmux/sessions/fireup.sh'
alias tmuxstart 'tmux $TMUX_ADDITIONAL_OPTS attach -t main'
alias tmuxtoss  'tmux $TMUX_ADDITIONAL_OPTS kill-server'

alias sshh 'ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeychecking=no'
alias scpp 'scp -o UserKnownHostsFile=/dev/null -o StrictHostKeychecking=no'

alias dockerimg     'docker images | sed 1d | fzf-tmux | awk \'{print $3}\''
alias dockerinspect 'docker inspect (dockerps)'
alias dockerps      'docker ps | sed 1d | fzf-tmux | awk \'{print $1}\''
alias setkubecfg    'set --global --export KUBECONFIG'
alias kc            'kubectl --insecure-skip-tls-verify'

alias pick_compile_commands 'set --global --export COMPILE_COMMANDS_DIR (find . | grep compile_commands.json | fzf-tmux | xargs dirname)'

function dockerlocal
    set --local options 'h/help' 'i/image=' 'e/entrypoint='
    argparse $options -- $argv
    if set --query _flag_help
        printf "Usage: %s [OPTIONS]\n\n" (status function)
        printf "Options:\n"
        printf "  -h/--help       Prints help and exits\n"
        return 0
    end

    set --query _flag_entrypoint; or set --local _flag_entrypoint 'bash'
    set --query _flag_image; or set --local _flag_image (dockerimg)

    docker run -it --env USER=$USER --env WS_ROOT=$WS_ROOT --rm --user (id -u):(id -g) -v $PWD:$PWD --workdir $PWD \
        --cap-add=SYS_PTRACE --security-opt seccomp=unconfined --entrypoint=$_flag_entrypoint $_flag_image
end

# For CRE, since they have crazy newlines: g/^"}/norm kJ
alias kubefilter_normal 'bat -l kubelog'
alias kubefilter        'jq -R -r --unbuffered \'. as $line | try (fromjson | .timestamp + " " + .service_id + " " + .severity + " " + .metadata.proc_id + " " + .message) catch $line \' | kubefilter_normal'
alias kubefilter_no_paging 'jq -R -r --unbuffered \'. as $line | try (fromjson | .timestamp + " " + .service_id + " " + .severity + " " + .metadata.proc_id + " " + .message) catch $line \' | bat -l log --paging=never'

# Enable fzf in fish
fzf_key_bindings

function helpc
    # Help with color
    $argv | bat --plain --language=help --pager=never
end

set -x MANPAGER "sh -c 'col -bx | bat -l man -p'"

set --global --export SSH_ENV $HOME/.ssh/environment

function start_agent
    echo "Initializing new SSH agent..."
    ssh-agent -c | sed 's/^echo/#echo/' > $SSH_ENV
    echo "succeeded"
    chmod 600 $SSH_ENV
    . $SSH_ENV > /dev/null
    ssh-add
end

function test_identities
    ssh-add -l | grep "The agent has no identities" > /dev/null
    if [ $status -eq 0 ]
        ssh-add
        ssh-add ~/.ssh/google_compute_engine
        if [ $status -eq 2 ]
            start_agent
        end
    end
end

if [ -n "$SSH_AGENT_PID" ]
    ps -ef | grep $SSH_AGENT_PID | grep ssh-agent > /dev/null
    if [ $status -eq 0 ]
        test_identities
    end
else
    if [ -f $SSH_ENV ]
        . $SSH_ENV > /dev/null
    end
    ps -ef | grep $SSH_AGENT_PID | grep -v grep | grep ssh-agent > /dev/null
    if [ $status -eq 0 ]
        test_identities
    else
        start_agent
    end
end
