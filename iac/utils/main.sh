#!/bin/bash
# Verifica si se han pasado argumentos

ports= (22 80)

# Limpiar reglas existentes
sudo iptables -F
sudo iptables -X

# Configurar políticas predeterminadas para denegar todo el tráfico
sudo iptables -P INPUT DROP
sudo iptables -P FORWARD DROP
sudo iptables -P OUTPUT ACCEPT

# Permitir tráfico en los puertos especificados
for PUERTO in "${ports[@]}"; do
    if [[ "$PUERTO" =~ ^[0-9]+$ ]]; then
        sudo iptables -A INPUT -p tcp --dport "$PUERTO" -j ACCEPT
        echo "Regla añadida para permitir tráfico en el puerto $PUERTO."
    else
        echo "Advertencia: '$PUERTO' no es un número de puerto válido."
    fi
done

# Permitir tráfico de retorno
sudo iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# Permitir tráfico de loopback
sudo iptables -A INPUT -i lo -j ACCEPT

echo "Reglas de firewall configuradas para permitir tráfico en los puertos especificados."

# Disable Authentication using password
sudo sed -i 's/^PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
sudo sed -i 's/#PasswordAuthentication yes/#PasswordAuthentication no/' /etc/ssh/sshd_config
sudo systemctl restart sshd

exit 0
