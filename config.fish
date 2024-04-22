set --local vim_bin /home/$USER/proj/neovim/build/bin/nvim

set -x EDITOR $vim_bin
set -x GIT_EDITOR $vim_bin
set -x WORK_DIR $HOME/proj/work

set -g -x PATH $PATH $HOME/google-cloud-sdk/bin
set -g -x PATH $PATH $HOME/node_modules/.bin
set -g -x PATH $PATH $HOME/.cargo/bin

# set -g -x PATH $PATH /usr/local/go/bin
set -g -x PATH $PATH $HOME/go/bin
alias go 'go1.22.2'
# For some reason GOROOT is not set properly in gopls, it picks up the default go and GOROOT in /usr/local/go/src/slices
set -x GOROOT (go env GOROOT)
which go > /dev/null
if test ! $status -eq 0
    ln -sf $HOME/go/bin/go1.22.2 $HOME/.local/bin/go
end

if not status is-interactive
    return
end

set --universal fish_greeting "🐟🐟🐟"

# Override exit to let jobs roam free
function exit
    jobs -q; and disown (jobs -p)
    builtin exit
end

# Commands to run in interactive sessions can go here
fish_config theme choose kanagawa
alias nvim (echo $vim_bin)
alias vi (echo $vim_bin)
alias vim (echo $vim_bin)
alias vim_no_cfg (echo $vim_bin -u NONE)
alias ip 'ip --color=auto'

function gitme
    set --local me (finger $USER | grep -Eo "Name: (.*)" | cut -b (echo "Name: " | wc -c)-)
    git log --author="$me"
end
alias cdrr        'cd (git root)'
alias cdproj      'cd $HOME/proj'
alias cdwork      'cd $HOME/proj/work'
alias gitclean    'git clean -xdff'
alias gitsub      'git submodule update --init'
alias gitsubr     'git submodule update --init --recursive'
alias gitsubclean 'git submodule foreach --recursive git clean -ffdx'
alias gits        'git status'
alias gitb        'git branch -vv'
alias gitpg       'git push origin HEAD:refs/for/master'
alias gitp        'git push origin HEAD:(git branch --show-current)'
alias gitpf       'git push -f origin HEAD:(git branch --show-current)'
alias gitw        'git worktree list'

function gitlog_without_scm
    # Log of two commitish, excluding up/VERSION_PREFIX changes
    git log $argv[1] -- $argv[2] ':^up/VERSION_PREFIX'
end

function tigdiff
    # Diff two commitish, excluding up/VERSION_PREFIX changes
    tig $argv[1] -- $argv[2] ':^up/VERSION_PREFIX'
end

function gitw_add
    # Create a new worktree with given branch name
    # E.g: gitw_add fix-it-based-on-current-commit
    # E.g: gitw_add fix-it-tracking-master origin/master
    set --local branch $argv[1]
    set --local dir ../(basename (git root))
    echo $branch
    echo $dir
    git worktree add -b $branch $dir-$branch $argv[2..-1]
end

function fix_sp_trailing
    # Remove empty lines and then \r from given file, support_package files
    sed -i '/^$/d' $argv[1] && sed -i 's/\r$//' $argv[1]
end

alias tmuxfire  '~/.tmux/sessions/fireup.sh'
alias tmuxstart 'tmux $TMUX_ADDITIONAL_OPTS attach'
alias tmuxtoss  'tmux $TMUX_ADDITIONAL_OPTS kill-server'

alias sshh 'ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeychecking=no'
alias scpp 'scp -o UserKnownHostsFile=/dev/null -o StrictHostKeychecking=no'

alias dockerimg     'docker images | sed 1d | fzf-tmux | awk \'{print $3}\''
alias dockerinspect 'docker inspect (dockerps)'
alias dockerps      'docker ps | sed 1d | fzf-tmux | awk \'{print $1}\''
alias setkubecfg    'set --global --export KUBECONFIG'
alias kc            'kubectl --insecure-skip-tls-verify'

alias dockerkillall 'docker kill (docker ps | tail -n +2 | cut -d" " -f 1)'
alias dockerrmall   'docker rm (docker ps -a | tail -n +2 | cut -d" " -f 1)'
alias dockerrmallvolumes   'docker volume prune --filter all=1'

alias pick_compile_commands 'set --global --export COMPILE_COMMANDS_DIR (find . | grep compile_commands.json | fzf-tmux | xargs dirname)'

function dockerlocal
    set --local options 'h/help' 'i/image=' 'e/entrypoint=' 'r/root'
    argparse $options -- $argv
    if set --query _flag_help
        printf "Usage: %s [OPTIONS]\n\n" (status function)
        printf "Options:\n"
        printf "  -h/--help       Prints help and exits\n"
        return 0
    end

    set --query _flag_entrypoint; or set --local _flag_entrypoint 'bash'
    set --query _flag_image; or set --local _flag_image (dockerimg)

    set --local user --privileged
    if set --query _flag_root
    else
        set user --env USER=$USER --user (id -u)":"(id -g)
    end

    # Multiple --env seems to make --rm to not function
    docker run -it $user --rm -v $PWD:$PWD --workdir $PWD \
        --cap-add=SYS_PTRACE --security-opt seccomp=unconfined --entrypoint=$_flag_entrypoint $_flag_image
end

# For CRE, since they have crazy newlines: g/^"}/norm kJ
alias kubefilter_normal 'bat -l kubelog'
alias kubefilter        'jq -R -r --unbuffered \'. as $line | try (fromjson | .timestamp + " " + .service_id + " " + .severity + " " + .metadata.proc_id + " " + .message) catch $line \' | kubefilter_normal'
alias kubefilter_no_paging 'jq -R -r --unbuffered \'. as $line | try (fromjson | .timestamp + " " + .service_id + " " + .severity + " " + .metadata.proc_id + " " + .message) catch $line \' | bat -l log --paging=never'

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
    . $SSH_ENV
    ssh-add
    ssh-add ~/.ssh/google_compute_engine
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

if [ -f $SSH_ENV ]
    . $SSH_ENV
end
# If we have an alive socket, reuse it
if [ -S "$SSH_AUTH_SOCK" ]
    test_identities
else
    start_agent
end

set FZF_CTRL_T_OPTS "--preview 'bat -n --color=always {}' --header 'Preview layout: CTRL-/'
    --bind 'ctrl-/:change-preview-window(down|hidden|)'"

function set_bg_mode
    # Create a very special file to denote the wanted bg color
    echo $argv[1] > $BG_COLOR_FILE
    if test "$argv[1]" = "light"
        set --global --export BAT_THEME "Kanagawa Lotus Light"
        set --global --export FZF_DEFAULT_OPTS --color=light
        sed -i --follow-symlinks 's/dark = true/light = true/' ~/.gitconfig.user
        sed -i --follow-symlinks 's/syntax-theme = .*/syntax-theme = Kanagawa Lotus Light/' ~/.gitconfig.user
        sed -i --follow-symlinks "s/kanagawa.*.toml/kanagawa_lotus.toml/" ~/.alacritty.toml
    else
        set --global --export BAT_THEME "Kanagawa Wave"
        set --global --export FZF_DEFAULT_OPTS --color=dark
        sed -i --follow-symlinks 's/light = true/dark = true/' ~/.gitconfig.user
        sed -i --follow-symlinks 's/syntax-theme = .*/syntax-theme = Kanagawa Wave/' ~/.gitconfig.user
        sed -i --follow-symlinks "s/kanagawa.*.toml/kanagawa.toml/" ~/.alacritty.toml
    end
end
alias go_dark 'set_bg_mode dark'
alias go_light 'set_bg_mode light'

set --global BG_COLOR_FILE /tmp/term_bg_color
if not test -e $BG_COLOR_FILE
    go_dark
else
    set --local bg $(cat $BG_COLOR_FILE)
    if test "$bg" = "light"
        go_light
    else
        go_dark
    end
end

function run_many
    # Run X iterations, stop upon failure
    for x in (seq $argv[1])
        echo "=== $(date) ITERATION $x ==="
        eval "$argv[2..-1]"
        if test $status != 0
            break
        end
    end
end

function gitallinone
    git fetch --tags --force --prune
    git pull --rebase -q
end
