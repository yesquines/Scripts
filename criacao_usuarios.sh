#!/bin/bash
#Desc: Script para criação, listagem, troca de senhas e exclusão de usuários
#V1.0.0

##MENU DE OPÇÕES
echo -n "

	$(figlet FATEC USER)
	        ***Bem Vindo***

	1. Criar um novo usuário.
	2. Lista os usuários válidos no sistema.
	3. Trocar/Adicionar senha de um usuário.
	4. Excluir um usuário.
	5. Sair do Programa.

"

#CAPTURANDO A OPÇÕES ESCOLHIDA PELO USUÁRIO PARA DENTRO DA VARIAVEL OPÇAO
read -p "Digite a opção desejada: " OPCAO

#ESTRUTURA PARA TRATAR A VARIAVEL OPCAO CONFORME A OPÇÃO ESCOLHIDA PELO USUÁRIO
case $OPCAO in
	1)
		#Limpar a Tela
		clear
		#Coletando Informação do Novo Usuário.
		read -p "Digite o nome do Novo Usuário: " NOME
		#Verificação de Usuário já existe
		if [ $(getent passwd $NOME | wc -l) -eq 0 ]; then
			#Adicionando o Usuário
			useradd $NOME 

			#Verificando se houve falha ao adicionar o usuário
			if [ $? -eq 0 ]; then
				echo "[OK] - Usuário Adicionado com sucesso"
			else 
				echo "[ERRO] - Falha ao Adicionar o Usuário"
			fi	
		else
			echo "[ERRO] Usuário já existe"
		fi
	;;
	2)
		#Limpar a Tela
		clear
		#Mostra quantidade de usuários comuns do sistema
		echo -e "Total de Usuários Comuns: $(awk -F: '($3 > 999) {print $1}'  /etc/passwd | wc -l) \n"

		#Mostra a lista de usuários comuns do sistema
		echo "Lista de Usuários Comuns:" 
		awk -F: '($3 > 999) {print $1}' /etc/passwd 
	;;
	3)	
		#Limpar a Tela
		clear

		#Coletando Informação do usuário que irá alterar a senha
		read -p "Digite o nome do Usuário para alterar a Senha: " NOME

		#Verificação de Usuário já existe
		if [ $(getent passwd $NOME | wc -l) -ne 0 ]; then
			#Alterando a Senha do Usuário
			passwd $NOME
		else
			echo "[ERRO] Usuário NÃO existe"
		fi
	;;
	4)
		#Limpar a Tela
		clear

		#Coletando Informação do usuário que irá ser excluido senha
		read -p "Digite o nome do Usuário que será excluido: " NOME
		read -p "Tem certeza que irá excluir o usuário $NOME?(s/N) " ${CONFIRMAR:=n}
		
		#Verificando se usuário deve ser excluido
		if [ $CONFIRMAR	== "S" -o $CONFIRMAR == "s" ]; then 
			#Excluido Usuário
			userdel -r $NOME
		else
			echo ""
		fi
	;;
	5)
		clear
		echo "Saindo do programa..."
		sleep 3
		exit 0	
	;;
	*)
		echo "Opção Inválida!"
		exit 1
	;;
esac
