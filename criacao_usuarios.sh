#!/bin/bash
#Autor: Yago Ésquines
#Email: yago.fut@gmail.com.br
#Trabalho FATEC São Caetano
#Desc: Script para criação, listagem, troca de senhas e exclusão de usuários

#Loop Infinito para manter o as opções ativas
while true
do
	##MENU DE OPÇÕES
	echo -n "

		$(figlet "FATEC USER")
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
				useradd -m $NOME 
	
				#Verificando se houve falha ao adicionar o usuário
				if [ $? -eq 0 ]; then
					echo "[OK] - Usuário Adicionado com sucesso"
					sleep 3
				else 
					echo "[ERRO] - Falha ao Adicionar o Usuário"
					echo "Tente novamente..."
					sleep 3
				fi	
			else
				echo "[ERRO] Usuário já existe"
				sleep 3
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

			sleep 5	
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
				sleep 3
			else
				echo "[ERRO] Usuário NÃO existe"
				sleep 3
			fi
		;;
		4)
			#Limpar a Tela
			clear
			CONFIRMAR=n	
			#Coletando Informação do usuário que irá ser excluido senha
			read -p "Digite o nome do Usuário que será excluido: " NOME
			read -p "Tem certeza que irá excluir o usuário $NOME?(s/N) " CONFIRMAR
			
			#Verificando se usuário deve ser excluido
			if [ $CONFIRMAR	== "S" -o $CONFIRMAR == "s" ]; then 
				#Excluido Usuário
				userdel -r $NOME
				if [ $? -eq 0 ]; then
					echo "Usuário excluido com sucesso"
					sleep 3
				else
					echo "Falha ao excluir usuário"
					sleep 3
				fi
			else
				echo "Operação Cancelada"
				sleep 3
			fi
		;;
		5)
			#Informações ao sair do programa.
			echo -e "\nSaindo do programa..."
			sleep 3
			exit 0	
		;;
		*)
			#Informações quando digitado opção inválida
			echo "Opção Inválida!"
			echo "Escolha novamente..."
			sleep 3
			clear
		;;
	esac
done
