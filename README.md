# Some dotted files

Simply link the ones you want to use:

    rm -r /home/$USER/<target>
    ln -s <repo>/<target> /home/$USER/<target>

For some files, you just want to source or extend from the original dot file.

# Gitconfig

Add something like this:

    [includeIf "gitdir:~/proj/work/"]
        path = ~/.gitconfig_work

That includes something like this:

    [user]
        name = Some One
        email = some@email.com
    [gerrit]
        createChangeId = false
