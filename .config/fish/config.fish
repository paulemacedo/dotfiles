set -g fish_greeting

if status is-interactive
    starship init fish | source
end

# List Directory
alias l='eza -lh  --icons=auto' # long list
alias ls='eza -1   --icons=auto' # short list
alias ll='eza -lha --icons=auto --sort=name --group-directories-first' # long list all
alias ld='eza -lhD --icons=auto' # long list dirs
alias lt='eza --icons=auto --tree' # list folder as tree

# Handy change dir shortcuts
abbr .. 'cd ..'
abbr ... 'cd ../..'
abbr .3 'cd ../../..'
abbr .4 'cd ../../../..'
abbr .5 'cd ../../../../..'

# Always mkdir a path (this doesn't inhibit functionality to make a single dir)
abbr mkdir 'mkdir -p'

#
function fish_greeting
     pokemon-colorscripts -r
end

function webstorm
    command webstorm $argv > /dev/null 2>&1 & disown
end

# Em config.fish
function pycharm-eap
    /opt/pycharm-eap/bin/pycharm.sh $argv > /dev/null 2>&1 & disown
end

function rustrover
    /opt/rustrover/bin/rustrover $argv > /dev/null 2>&1 & disown
end


fish_add_path /home/paule/.spicetify
