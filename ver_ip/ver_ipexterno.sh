#!/bin/bash
#Autor: Yago Ésquines
#Email: yago.fut@gmail.com
#Ano: 2015
#Versão: 1.1
#Script para verificação e envio de IP Externo por email

DIA=`date +%F`;
HORA=`date +%T`;
EMAIL="yago.fut@gmail.com";
SWAPIP=`cat /home/yago/Documentos/Scripts/ver_ip/ver_ipexterno.txt`;

#Verificar Conexão com a Internet
#until [[ `ping -c 2 8.8.8.8 > /dev/null` ]]; do
echo "#############################";
echo "$DIA $HORA: PROCESSO COMEÇOU";
ping -c2 8.8.8.8 > /dev/null;
if [[ $? -eq 0 ]]; then

	echo "$DIA $HORA: Conexão Ativa";
	#Verificando IP Externo
	echo "$DIA $HORA: VERIFICANDO IP EXTERNO";
	IPEXTERNO=`curl ifconfig.me`;
	if [[ $? -eq 0 ]]; then
		echo $IPEXTERNO > /home/yago/Documentos/Scripts/ver_ip/ver_ipexterno.txt;
		#Verificando se IP Mudou
			if [[ "$SWAPIP" != "$IPEXTERNO" ]]; then
				echo "$DIA $HORA: Número do IP Externo: $IPEXTERNO";	
				#SWAPIP=$IPEXTERNO;
				#enviando IP por email
				echo "Segue IP Externo de $DIA $HORA: $IPEXTERNO" | mutt -s 'JOKER - IP EXTERNO' $EMAIL;	
				if [[ $? -eq 0 ]]; then
					echo "$DIA $HORA: EMAIL ENVIADO";
					echo "$DIA $HORA: PROCESSO TERMINADO";
					echo "#############################";
				else
					echo "" > /home/yago/Documentos/Scripts/ver_ip/ver_ipexterno.txt;
					echo "$DIA $HORA: Falha ao Enviar Email!";
					echo "$DIA $HORA: Nova Verificação em 30m";
					echo "#############################";
				fi
				
			else

				echo "$DIA $HORA: IP NÃO FOI ALTERADO";
				echo "$DIA $HORA: Nova Verificação em 30m";
				echo "#############################";

			fi 
	else
		echo "$DIA $HORA: FALHA NA VERIFICÃO DO IP EXTERNO";
		echo "$DIA $HORA: Nova Verificação em 30m.";
		echo "#############################";
	fi	
else
	echo "$DIA $HORA: Conexão Desativada";
	echo "$DIA $HORA: Favor Verificar Conectividade";
	echo "$DIA $HORA: Nova Verificação em 30m.";
	echo "#############################";
fi
#done
