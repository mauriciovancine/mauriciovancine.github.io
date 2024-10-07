# script commit gitlab
# mauricio vancine

# instalar o git
git --version
sudo apt install git-all

# configuracao inicial do git
git config --global user.name "mauriciovancine"
git config --global user.email "mauricio.vancine@gmail.com"

# conferindo
git config user.name
git config user.email
git config --list

# repositorios remotos
# gerar uma chave
ssh-keygen -t ed25519 -C "mauricio.vancine@gmail.com" # tres enters

# verificar
cd ~/.ssh
cat id_ed25519.pub

# ligar o repositorio do pc ao git
# sudo apt install xclip
xclip -sel clip < ~/.ssh/id_ed25519.pub
ssh -T git@gitlab.com:mauriciovancine

git remote add origin git@github.com:mauriciovancine/git-course.git
git remote
git remote -v

###---------------------------------------------

# iniciar o repositorio git
# definir diretorio
cd /media/mauricio/data/gitlab

# clonar um repositorio
git clone git@gitlab.com:mauriciovancine/r-enm.git

# iniciar o git
git init

# listar 
ls -la

# reportar o estados do repositorio
git status # untracked

# commit - criar um snapshot dos arquivos
git commit -m 

# verificar
git status # nada para ser feito

## 10 visualizando logs
# mostrar as infos dos commits

# mostrar commits
git log

# descricao dos commits
git log --decorate

# filtro autor dos commits
git log author="mau"

# mostra os autores que comitaram
git shortlog

# mostra numero de commits por pessoas
git shortlog -sn

# mostra de forma grafica os branchs
git log --graph

# mostra a hash
git show 588867d3f12f9a3f819dbf9657614c92a4d5237f

## 11 visualizando o diff
# mudancas antes do envio

# verificar
git status

# editar
subl readme.md

# visualizar as mudancas antes de commitar
git diff

# listar o nome dos arquivos modificados
git diff --name-only

# commitar
git commit -am "edit"

# ver commit
git log

# mostrar commit
git show a06fd917431bc1dffdc8565bff0fe7b13d8bfc3c

## 12 desfazendo coisas
# 1. voltar para antes da edicao
git log
git status
subl readme.md # edit
git diff
git status
git checkout readme.md
git diff

# 2. retirar do stage (git add) e voltar antes da edicao
subl readme.md # edit
git add readme.md
git diff
git status
git reset HEAD readme.md
git status
git checkout readme.md
git diff

# 3. voltar do commit
subl readme.md # edit
git status
git commit -am "soft"
git log

# 1. git reset --soft: volta o commit e mantem arquivo no staged
git reset --soft a06fd917431bc1dffdc8565bff0fe7b13d8bfc3c # hash anterior
git status
subl readme.md
git commit -am "mixed"

# 2. git reset --mixed: volta o commit e arquivo fica em modofied
git reset --mixed bb63de7478f5d789029a91401cb1095b2fb4ab2d 
git status
subl readme.md
git commit -am "hard"

# 3. git reset --hard: volta o commit e arquivo volta em unmodified
git reset --hard bb63de7478f5d789029a91401cb1095b2fb4ab2d
git log
git status

# o git reset --hard altera o historico dos commits

###---------------------------------------------###



# enviar os arquivos para o repositorio
git push -u origin master
git push

## 16 enviando mudancas para um repositorio remoto
subl readme.md
git status
git commit -am "commit to github"
git log
git push origin master

## 17 clonando repositorios remotos
# download de um repositorio do github para pc
cd ..
git clone git@github.com:mauriciovancine/git-course.git github-course-clone # com chave
git clone https://github.com/mauriciovancine/git-course # publico

## 18 fazendo fork de um projeto
# copiar um repositorio para o proprio github
# sempre de outro usuario

###---------------------------------------------###

## secao 5 ramificacao (branch)

## 19 o que e um branch e por que usar?
# branch: ponteiro movel que leva a um commit
# cada commit gera uma hash (código) e para cada hash gera um snapshot
# novo branch aponta para o mesmo commit ou para outro commit
# utilidade:
# 1. modificar os arquivos sem modificar o local principal (master)
# 2. facilmente desligavel
# 3. multiplas pessoas trabalhando
# 4. evita conflitos
# mescla-se o branch final ao branch paralelo

## 20 criando um branch
# criando um branch
git checkout -b testing

# verificando branch
git branch

## 21 movendo e deletando branches
# verificando branch
git branch

# movendo para master
git checkout master

# verificando branch
git branch

# movendo para testing
git checkout testing
git checkout master

# apagar branch
git branch -D testing

# verificando branch
git branch 

# 22 entendendo o merge
# unir branchs - branch separado paralelo a mais para unir

# 23 entendendo o rebase
# unir branchs - branch separado linera logo a frente

# 24 merge e rebase na pratica
mkdir rebase-merge
cd rebase-merge
git init
subl foo
git status
git add foo
git commit -m "add foo"

git checkout -b test
subl bar 
git add bar
git commit -m "add bar"

git log

git checkout master
git log

subl fizz
git add fizz
git commit -m "add fizz"
git log

# merge
git merge test
git log
git log --graph

# rebase
subl buzz
git add buzz
git commit -m "add buzz"
git log

git checkout -b rebase
subl bla
git add bla
git commit -m "add bla"
git log --graph

git checkout master
git log

subl seila
git add seila
git commit -m "add seila"

git log

git rebase rebase

git log
git log --graph

###---------------------------------------------###

### secao 6 extras

## 25 criando o .gitignore
# ignora trackeamento de arquivos
# arquivo no repositorio para 

subl data.txt
git status

subl .gitignore # *.txt
git status

subl .gitignore # data
git status

# https://git-scm.com/docs/gitignore
# https://github.com/github/gitignore

## 26 git stash e lindo
# responsavel por guardar modificacoes nao commitadas
cd..
cd git-course
subl readme.md

git status
git stash
git status

git checkout -b bla
git log

git stash apply

git stash list
git stash clear


## 27 alias para que te quero
# atalhos
git status
git config --global alias.s status

git s

## 28 versionando com tags
# sobe tags especificas
git tag -a 1.0.0 -m "readme finalizado"

git push origin master --tags
git tag

## 29 salvando sua sexta com git revert
# nao perde o commit, apenas retorna ao estado anterior

subl readme.md
git commit -am "add"
git log
git show # hash

git log
git revert # hash

git show # hash

## 30 apagando tags e branches remotos
git tag -d 1.0.0
git push origin master

git push origin :1.0.0


###-----------------------------------------------###

# These are common Git commands used in various situations:

# start a working area (see also: git help tutorial)
#    clone      Clone a repository into a new directory
#    init       Create an empty Git repository or reinitialize an existing one

# work on the current change (see also: git help everyday)
#    add        Add file contents to the index
#    mv         Move or rename a file, a directory, or a symlink
#    reset      Reset current HEAD to the specified state
#    rm         Remove files from the working tree and from the index

# examine the history and state (see also: git help revisions)
#    bisect     Use binary search to find the commit that introduced a bug
#    grep       Print lines matching a pattern
#    log        Show commit logs
#    show       Show various types of objects
#    status     Show the working tree status

# grow, mark and tweak your common history
#    branch     List, create, or delete branches
#    checkout   Switch branches or restore working tree files
#    commit     Record changes to the repository
#    diff       Show changes between commits, commit and working tree, etc
#    merge      Join two or more development histories together
#    rebase     Reapply commits on top of another base tip
#    tag        Create, list, delete or verify a tag object signed with GPG

# collaborate (see also: git help workflows)
#    fetch      Download objects and refs from another repository
#    pull       Fetch from and integrate with another repository or a local branch
#    push       Update remote refs along with associated objects