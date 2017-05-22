# myssh
Script para listar maquinas ssh via terminal

# Configurações:
## Clone do projeto
git clone https://github.com/augustomarinho/myssh

## Dar permissão de execução no script
chmod +x PATH_MYSSH_LOCAL/myssh.sh

## Criar o arquivo .ssh_machines
touch ~/.ssh_machines

## Criar alias para o Myshh
touch ~./bash_aliases
alias myssh="PATH_MYSSH_LOCAL/myssh.sh"

## Atualizar environment
source .bashrc

# Exemplo do arquivo .ssh_machines
acapulco;127.0.01;maquinalocal
riodejabeiro;192.168.0.1;maquina proxy

## Descricao das informaçes do arquivo .ssh_machines
NOME MAQUINA;IP;DESCRICAO LIVRE

## Executando o myssh
myssh <NOME_USUARIO>

O nome do usuário é opcional, caso não seja informado será capturado o usuário logado.
