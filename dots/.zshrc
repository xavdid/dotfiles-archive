# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

source ~/.env
source ~/.loc

# no wierd !45 expansion
# use single quotes on command line instead
# setopt no_bang_hist

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
ZSH_THEME="kolo"

##~ PATH STUFF ~##
[[ -s `brew --prefix`/etc/autojump.sh ]] && . `brew --prefix`/etc/autojump.sh
export HOMEBREW_CASK_OPTS="--appdir=/Applications"

##~ EDITORS ~##
alias zshconfig="subl ~/.zshrc"
alias gitconfig="subl ~/.gitconfig"
alias envedit="subl ~/.env"
# Screw Textmate
alias mate="subl"

##~ OSX ~##
alias zhide="defaults write com.apple.finder AppleShowAllFiles FALSE; killall Finder"
alias zshow="defaults write com.apple.finder AppleShowAllFiles TRUE; killall Finder"

##~ TERMINAL ~##
# alias hub as git
# this outputs "alias git=hub"
eval "$(hub alias -s)"

# alias caen="ssh brownman@login.engin.umich.edu"
alias sz="source ~/.zshrc"
alias http="python -m SimpleHTTPServer 1234"
alias watch="sass --watch ."
alias mip="ifconfig |grep inet"
alias ip="curl http://ipecho.net/plain ;echo"
alias ms="middleman server"
alias xtime="wget http://c.xkcd.com/redirect/comic/now; open ./now; read; rm ./now;"
alias cda="cd -"
function ee()
{
    export $(cat .env)
}
# pretty print json
# eg: echo '{"a": 1}' | ppj
alias ppj="python -m json.tool"
alias viet="sudo vi /etc/hosts"
alias pir="pip install -r requirements.txt"
function sha256()
{
    # should edit this to also only output the sha or just sha and filename
    shasum -a 256 $1
}

function port()
{
    lsof -i ":$1"
}

# takes tag of a docker container and runs bash in said container
function inv()
{
    docker run -it --rm $1 bash
}

function run()
{
    docker run --rm $1
}

##~ RUBY ~##
function gemdeploy()
{
    rm *.gem
    gem build $(echo *.gemspec)
    read "push?Do you want to push to RubyGems? "
    if [[ "$push" =~ ^[Yy]$ ]]
    then
        gem push $(echo *.gem)
    fi
}

##~ SINATRA ~##
alias cig='lsof -i :4567'

function sin()
{
    if [ -f ./Procfile.dev ]; then
        foreman start -f Procfile.dev
    else
        sinatra
    fi
}

function sinatra()
{
    if [ -f ./config.ru ]; then
        rerun "bundle exec rackup -p 4567" -p "**/*.{rb,js,coffee,css,scss,erb,html,haml,ru,yml,json}"
    else
        rerun "bundle exec ruby ${PWD##*/}.rb" -p "**/*.{rb,js,coffee,css,scss,erb,html,haml,ru,yml,json}"
    fi
}

##~ NODE ~##
function nod()
{
    if [ -f ./Procfile.dev ]; then
        foreman start -f Procfile.dev
    else
        nodemon
    fi
}

function renpm()
{
    rm -rf node_modules && npm i
}

##~ GIT ~##
alias g="git"
alias purr="git pull --rebase"
alias gs="git status"

alias gq="git commit -m"
function ggg() { git add --all .; git commit -m "$1" }
function ggu() { git add -u .; git commit -m "$1" }
alias ch="git checkout"
# nb instructions: `nb $BRANCH`
alias nb="git push -u origin"
# stolen from Nick Quinlan
alias pushit="open -g spotify:track:0GugYsbXWlfLOgsmtsdxzg; git push"

alias disc="git reset --hard"
alias b="./build.sh"
# alias t="ruby spec/test.rb"
function t() {
    if [ -f spec/test.rb ];then
        ruby spec/test.rb
    elif [ -f package.json ];then
        npm test
    else
        echo "Can't guess testing method, do it yourself"
    fi
}

# push and set upstream branch
# this doesn't work with my config?
function gpu() {
    REPO=$(git rev-parse --abbrev-ref HEAD)
    git push --set-upstream origin $REPO
}

# update remote to match new username
function rem() {
    [[ $(git remote get-url origin) =~ '\/(.*)\.git$' ]] &&
    git remote set-url origin "git@github.com:xavdid/$match[1].git"
}

# adapted from http://www.reddit.com/2e513y
function gi()
{
    VAL=$(curl https://www.gitignore.io/api/$@)
    if [ $1 = 'list' ];then
        echo $VAL
    else
        echo $VAL > .gitignore
    fi
}

##~ HEROKU ~##
alias gphm="git push heroku master"
alias hcp="heroku config:pull"
alias hmo="heroku maintenance:on"
alias hmof="heroku maintenance:off"
alias hl="heroku plugins:link ."

function mongolab()
{
    URI=$($DOTFILES/util/mongolab.rb $1)
    if ! [ -z $URI ]; then
        eval mongo $URI
    else
        echo No .env found
    fi
}

##~ RAILS ~##
alias rs="rails server"
alias rc="rails console"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/

plugins=(gitfast sublime brew docker gem sudo)

##~ RIQ ~##
function work()
{

}

##~ BLACK PEARL ~##
function home()
{
    export DROPBOX=/Users/david/Dropbox
    export DOTFILES=$DROPBOX/Saves/dotfiles
    export PROJECTS_ROOT=$HOME/projects

    export DOCKER_HOST=tcp://192.168.59.103:2376
    export DOCKER_CERT_PATH=/Users/david/.boot2docker/certs/boot2docker-vm
    export DOCKER_TLS_VERIFY=1

    alias db="cd $DROPBOX"

    ## CUSTOM GIT ##
    alias nr=". $DOTFILES/util/new_repo.sh"
    alias prune=". $DOTFILES/util/prune_branches.sh $1"
    function clo() { git clone git@github.com:xavdid/$1.git }
}

if [[ $LOC = RIQ ]]; then
    work
elif [[ $LOC = TBP ]]; then
    home
fi

source $ZSH/oh-my-zsh.sh

# Customize to your needs...
export PATH=$PATH:/usr/local/share/npm/lib/node_modules/coffee-script/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/git/bin

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

# Add RVM to PATH for scripting
export PATH="$PATH:$HOME/.rvm/bin"