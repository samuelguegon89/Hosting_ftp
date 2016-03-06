echo "Introduce el nombre del departamento: "
read departamento

#Creamos el directorio del VirtualHost:
mkdir /srv/www/$departamento

#Creamos el VirtualHost:
echo "<h1>Departamento de $departamento</h1>" > /srv/www/$departamento/index.html

sed "/<\/VirtualHost>/i\	Alias /$departamento /srv/www/$departamento \n	<Directory /srv/www/$departamento> \n 			Options +Indexes +FollowSymLinks \n 	</Directory> " /etc/apache2/sites-available/iesgn.conf > /tmp/iesgn.conf

mv /tmp/iesgn.conf /etc/apache2/sites-available/iesgn.conf

#Creamos el usuario:
adduser $departamento
chown -R $departamento:$departamento /srv/www/$departamento

#Añadimos el DefaultRoot en proftpd:
sed "/DefaultRoot/a\DefaultRoot                    /srv/www/$departamento    $departamento" /etc/proftpd/proftpd.conf > /tmp/proftpd.conf
mv /tmp/proftpd.conf /etc/proftpd/proftpd.conf

#Reiniciamos los servicios:
systemctl restart apache2.service
systemctl restart proftpd.service
