#!/bin/bash
#Script para criação de Virtual Host no Apache.
#Autor: Yago Ésquines
#Versão: 1.0
#Tabela de Atualzações:

##############FUNCOES############################
opcaohttps()
	{
    	read -p "Deseja opção HTTPS? S/N: " OPHTTPS;
    		if [ "$OPHTTPS" = 'S' -o "$OPHTTPS" = 's' ]; then {
        	VOPHTTPS1="NameVirtualHost *:443";
    		VOPHTTPS2="<VirtualHost  *:443>
			ServerAdmin ${ADMEMAIL}
			DocumentRoot ${PASTASITE}
			Servername ${DOMINIO}
			SSLEngine on
			SSLCertificateFile    /etc/letsencrypt/live/webmail.flaptrap.com.br/cert.pem
			SSLCertificateKeyFile /etc/letsencrypt/live/webmail.flaptrap.com.br/privkey.pem
			SSLCertificateChainFile /etc/letsencrypt/live/webmail.flaptrap.com.br/chain.pem

			<Directory ${PASTASITE}>
				Options -Indexes FollowSymLinks
				AllowOverride None
				Order allow,deny
				allow from all

			</Directory>

			ErrorLog /var/log/apache2/error.log

			# Possible values include: debug, info, notice, warn, error, crit,
			# alert, emerg.
			LogLevel warn
			CustomLog /var/log/apache2/access.log combined
			</VirtualHost>";
        	OPHTTPS="HABILITADO";
        	opcaoredict
    		}
    		else {
        		if [ "$OPHTTPS" = 'N' -o "$OPHTTPS" = 'n' ]; then {
        		VOPHTTPS1="";
            	VOPHTTPS2="";
                OPHTTPS="DESABILITADO";
                OPREDIRECT="DESABILITADO";
	        	}
    			else {
    				echo "[ERRO] OPÇAO INCORRETA";
            		opcaohttps
    				}
        		fi }
    		fi
	}

opcaosenha()
	{
    read -p "Deseja opção Senha no Site? S/N: " OPSENHA;
    		if [ "$OPSENHA" = 'S' -o "$OPSENHA" = 's' ]; then {
    		VOPSENHA='AuthType Basic
			AuthName "Acesso Restrito:"
			AuthUserFile "/www/.htpasswd"
			Require valid-user';
        	OPSENHA="HABILITADO";
    		}
    		else {
        		if [ "$OPSENHA" = 'N' -o "$OPSENHA" = 'n' ]; then {
        			VOPSENHA="";
                	OPSENHA="DESABILITADO";
        			}
    				else {
    					echo "[ERRO] OPÇAO INCORRETA";
            			opcaosenha
    					}
        		fi }
    		fi
	}

opcaoredict()
	{
    read -p "Deseja opção Redirecionamento (Forçar HTTPS)? S/N: " OPREDIRECT;
	    	if [ "$OPREDIRECT" = 'S' -o "$OPREDIRECT" = 's' ]; then {
    		VREDIRECT="Redirect permanent / https://${DOMINIO}";
        	OPREDIRECT="HABILITADO";
    		}
    		else {
        		if [ "$OPREDIRECT" = 'N' -o "$OPREDIRECT" = 'n' ]; then {
        		VREDIRECT="";
                OPREDIRECT="DESABILITADO";
        		}
    			else {
    			echo "[ERRO] OPÇAO INCORRETA";
            	opcaoredict
    			}
        		fi }
    		fi
	}
################################################

# Script para criação de Virtual Host do Apache.
echo "[INICIO] SCRIPT PARA CRIAÇÃO DE VIRTUAL HOST NO APACHE";
echo "";
read -p "Digite o nome do Site [Apenas Nome]: " NOMESITE;
read -p "Digite o Dominio: " DOMINIO;
read -p "Digite a Pasta Principal [$NOMESITE]: " PASTASITE;
#Em caso de pasta em branco utilizar o padrão.
	if [ "$PASTASITE" = '' ]; then {
		PASTASITE="/www/$NOMESITE/";
    	echo "[INFO] UTILIZADO PASTA PADRÃO - $PASTASITE";
        }
     fi
#Verifica se pasta existe
	if [ -d "$PASTASITE" ]; then {
   	read -p "Digite o Email do Administrador: " ADMEMAIL;
#Em caso de email em branco utilizar o padrão.
		if [ "$ADMEMAIL" = '' ]; then {
			ADMEMAIL="flaptrap.developer@gmail.com";
			echo "[INFO] UTILIZADO EMAIL PADRÃO - $ADMEMAIL";
        	}
     	fi

#OPCOES DE HTTPS, SENHA NO SITE e Redirecionamento
opcaohttps
opcaosenha

echo " ";
echo "[PROCESSO] CRIANDO VIRTUAL HOSTA... ";
	if [ -f "/etc/apache2/sites-available/$NOMESITE" ]; then { #/etc/apache2/sites-available/$NOMESITE
		echo "[ERRO] VIRTUAL HOST JA EXISTE";
    }
    else
cat << EOF > /etc/apache2/sites-available/$NOMESITE
${VOPHTTPS1}
<VirtualHost *:80>
	ServerAdmin ${ADMEMAIL}
	DocumentRoot ${PASTASITE}
	Servername ${DOMINIO}
	${VREDIRECT}
	<Directory />
		Options -Indexes FollowSymLinks
		AllowOverride None
	</Directory>
	<Directory ${PASTASITE}>
		Options -Indexes FollowSymLinks
		AllowOverride None
		Order allow,deny
		allow from all

        ${VOPSENHA}
	</Directory>

    ErrorLog /var/log/apache2/error.log

	# Possible values include: debug, info, notice, warn, error, crit,
	# alert, emerg.
	LogLevel warn
	CustomLog /var/log/apache2/access.log combined
</VirtualHost>

<VirtualHost *:80>
	ServerAdmin ${ADMEMAIL}
	DocumentRoot ${PASTASITE}
	Servername www.${DOMINIO}
	${VREDIRECT}
	<Directory />
		Options -Indexes FollowSymLinks
		AllowOverride None
	</Directory>
	<Directory ${PASTASITE}>
		Options -Indexes FollowSymLinks
		AllowOverride None
		Order allow,deny
		allow from all

        ${VOPSENHA}
	</Directory>

    ErrorLog /var/log/apache2/error.log

	# Possible values include: debug, info, notice, warn, error, crit,
	# alert, emerg.
	LogLevel warn
	CustomLog /var/log/apache2/access.log combined
</VirtualHost>

${VOPHTTPS2}

EOF

echo "[OK] CRIADO VIRTUAL HOST COM SUCESSO!";
echo "[PROCESSO] HABILITANDO SITE...!";
echo "[PROCESSO] CONFIGURANDO PERMISSÕES";
a2ensite $NOMESITE && chmod 751 /etc/apache2/sites-available/$NOMESITE && chown apache:apache /etc/apache2/sites-available/$NOMESITE
		if [ $? -eq 0 ]; then {
        echo "[OK] PERMISSÕES CONFIGURADAS!";
    	echo "[OK] SITE HABILITADO!";
    	echo "[PROCESSO] REINICIANDO APACHE...!";
    	service apache2 restart
    		if [ $? -eq 0 ]; then {
    			echo "[OK] APACHE REINICIADO!";
            	echo "";
                #Colocar Informações sobre a Configuração
				echo "[INFO] Site: http://${DOMINIO}";
				echo "[INFO] Diretorio de Arquivos: ${PASTASITE}";
				echo "[INFO] Opção HTTPS: ${OPHTTPS}";
				echo "[INFO] Opção de Redirecionamento: ${OPREDIRECT}";
				echo "[INFO] Opção de Senha: ${OPSENHA}";
				echo "";
				echo "[FIM] PROCESSO FINALIZADO COM SUCESSO!";
			} else echo "[ERRO] FALHA AO REINICIAR APACHE!";
        	fi
    	} else echo "[ERRO] FALHA AO HABILITAR SITE!";
    	fi
    fi
} else
	echo "[ERRO] DIRETÓRIO DO SITE NÃO ENCONTRADO";
    echo "Necessário criar o diretório Padrão do site";
fi
