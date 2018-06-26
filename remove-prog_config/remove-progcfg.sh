#!/bin/bash
#Autor: Yago Ésquines
#Email: yago.fut@gmail.com
#Ano: 2015
#Script para remover arquivos de configuração de programas já desinstalados - Sistemas LIKE DEBIAN

LISTA=`dpkg -l | egrep ^rc | cut -d\  -f3`;
VERIFICACAO=`dpkg -l | egrep ^rc | cut -d\  -f3 | wc -l`;
CONTROLE="0";

if [ $VERIFICACAO -eq 0 ]; then

	echo "$VERIFICACAO PROGRAMAS PARA REMOÇÃO DO ARQUIVO DE CONFIGURAÇÃO"

else

	echo "$VERIFICACAO Programas terão seus arquivos de configuração excluidos."
	for A in $LISTA; do 
		echo "Programa: $A"
		$(dpkg --purge $A > /dev/null 2> erro.txt)
		if [ $? -eq 0 ]; then
			echo -e "Arquivos de Configuração de $A removido com sucesso\n"
		else 	
			echo -e "Falha na remoção do programa $A\n"
			CONTROLE="1";
		fi
	done
fi

if [ $CONTROLE -eq "0" ]; then
	echo -e "\n###OPERAÇÃO CONCLUIDA###"
else
	echo -e "\nErro(s) encontrado(s):"
	echo "$(cat erro.txt)"
fi
