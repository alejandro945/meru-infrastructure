#!/bin/bash
# Verifica si se han pasado argumentos

ports= (22 80)

# Limpiar reglas existentes
iptables -F
iptables -X

# Configurar políticas predeterminadas para denegar todo el tráfico
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

# Permitir tráfico en los puertos especificados
for PUERTO in "${ports[@]}"; do
    if [[ "$PUERTO" =~ ^[0-9]+$ ]]; then
        iptables -A INPUT -p tcp --dport "$PUERTO" -j ACCEPT
        echo "Regla añadida para permitir tráfico en el puerto $PUERTO."
    else
        echo "Advertencia: '$PUERTO' no es un número de puerto válido."
    fi
done

# Permitir tráfico de retorno
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# Permitir tráfico de loopback
iptables -A INPUT -i lo -j ACCEPT

# Guardar las reglas
iptables-save > /etc/iptables/rules.v4

echo "Reglas de firewall configuradas para permitir tráfico en los puertos especificados."

# Disable Authentication using password
sed -i 's/^PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
systemctl restart sshd

exit 0
