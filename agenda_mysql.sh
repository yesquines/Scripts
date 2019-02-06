#!/bin/bash
#Autor: Yago Ésquines
#Email: yago.fut@gmail.com
#Ano: 2018
#Agenda de Contatos no MySQL - Script criado para fins didaticos

#########Criação da Base de Dados no MySQL###################
: '
CREATE DATABASE agenda
USE agenda
CREATE TABLE contatos (
	    -> id INT NOT NULL AUTO_INCREMENT,
	    -> nome VARCHAR(50) NOT NULL,
	    -> telefone VARCHAR(15),
	    -> email VARCHAR(35),
	    -> aniversario DATE,
	    -> primary key(id));
'
#OBS: Para automatizar a senha de acesso do MySQL é necessário editar o arquivo .my.cnf
###############################################################

inserir () {
	mysql -u root -e "INSERT INTO contatos (nome,telefone,email,aniversario) VALUE ('$NOME','$CONTATO','$EMAIL','$ANIVERSARIO')" agenda 
	[ $? -eq 0 ] && echo "Contato Inserido" || echo "Erro: Contato Não Inserido" 
	read -p "Pressione Enter para continuar"
}

consultar() {

	ID=$(mysql -u root -e "SELECT * FROM contatos where nome='$NOME'" agenda  | grep ^[0-9] | tr "\t" ":" | cut -d: -f1)
	mysql -u root -e "SELECT * FROM contatos where $CAMPO='$INFO'" agenda
	[ $? -ne 0 ] || echo "Erro: Falha ao realizar a Query" 
	read -p "Pressione Enter para continuar"
}

deletar () {

	mysql -u root -e "DELETE FROM contatos WHERE id='$ID'" agenda
	[ $? -eq 0 ] && echo "Contato Deletado" || echo "Erro: Contato Não Deletado"	
	read -p "Pressione Enter para continuar"
}

atualizar() {
	
	mysql -u root -e "UPDATE contatos SET $CAMPO='$VALOR' WHERE nome='$NOME'" agenda
	[ $? -eq 0 ] && echo "Contato Atualizado!" || echo "Erro: Contato Não Atualizado"
	read -p "Pressione Enter para continuar"
}

while true
do

figlet "AGENDA MYSQL"
echo "	
	1 - Inserir um Contato
	2 - Apagar um Contato
	3 - Atualizar um Contato
	4 - Consultar um Contato
	5 - Sair
"
read -p "Escolha uma das opções: " OPT

case $OPT in 
	1)
		clear
		read -p "Nome do Contato: " NOME
		read -p "Telefone do Contato: " CONTATO
		read -p "E-mail do Contato: " EMAIL
		read -p "Aniversario do Contato: " ANIVERSARIO

		inserir		
	;;
	2)
		clear
		read -p "Nome do Contato: " INFO
		NOME=$INFO
		CAMPO=nome
		consultar
		read -p "Realmente Deseja apagar o usuário?(S/N) " DEL
		[ "$DEL" = "S" -o "s" ] && deletar || exit 1
	;;
	3)
		clear
		read -p "Qual Campo será atualizado?(nome|telefone|email|aniversario) " CAMPO
		read -p "Digite o Nome do Contato: " NOME
		read -p "Digite o Novo Valor: " VALOR
		atualizar
	;;
	4)
		clear
		read -p "Qual Campo Será Consultado?(nome|telefone|email|aniversario) " CAMPO
		read -p "Digite o que deseja pesquisar: " INFO
		consultar
	;;
	5)
		exit 0
	;;
	*)
		echo "Opção Invalida!"
		read -p "Pressione Enter para escolher uma opção válida"
		clear
		
	;;
esac
done
