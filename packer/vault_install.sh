# Installs vault as a service for systemd on linux
NAME=vault

sudo cat << EOF > /etc/systemd/system/${NAME}.service
[Unit]
Description=HashiCorp ${NAME}

[Service]
ExecStart=/usr/local/bin/${NAME} server -config /opt/vault/${NAME}.hcl
User=vault
Group=vault
LimitMEMLOCK=infinity
Capabilities=CAP_IPC_LOCK+ep
CapabilityBoundingSet=CAP_SYSLOG CAP_IPC_LOCK

[Install]
WantedBy=multi-user.target
EOF

# Add the vault system user and group to ensure we have a no-login
# user capable of owning and running vault
sudo adduser --system --group vault || true
sudo chown vault:vault /opt/vault/${NAME}.hcl
sudo chown vault:vault /usr/local/bin/vault

sudo chmod 664 /etc/systemd/system/${NAME}.service
sudo systemctl daemon-reload
sudo systemctl enable ${NAME}
sudo systemctl start ${NAME}