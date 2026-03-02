установка
```
sudo apt update
sudo apt install ansible
```
проверка
```
ansible --version
```

для удобства редактирования шаблонов установить расширение на vscode
```
IkBenGeenRobot.ansible-variable-lookup
```
# содержание
[1. создание конфигов ансибла](#создаём-конфиги-ансибла)  
[2. создаём хранилище секретов](#vault)  
[3. устанавливаем коллекции ансибла для openssl](#openssl)  
[4. создаём роли](#роли)  
[5. размещаем конфиги сервера в репозитории](#размещаем-конфиги-сервера-в-репозитории)  
[6. редактируем конфиги которые закинули в репозиторий](#редактируем-конфиги-которые-закинули-в-templates)  
[7. тестирование всего плейбука](#тестирование-всего-плейбука)  
[8. создаём юнит-тесты](#юнит-тесты)  
[9. запуск плейбука](#запуск-плейбука)  

# создаём конфиги ансибла
### корневая папка репозитория
#### `ansible.cfg`
```
[defaults]
inventory = inventory
roles_path = roles
host_key_checking = False
retry_files_enabled = False
```
#### `inventory`  
деплой на тот же сервер:
```
[server]
localhost ansible_connection=local
```
по ssh
```
[server]
nuc ansible_host=192.168.0.107 ansible_user=ryusandorosu
```
#### `playbook.yml`
```
- hosts: server
  become: yes

  pre_tasks:
    - name: Check OS family
      assert:
        that: ansible_os_family == "Debian"
        fail_msg: "This playbook supports only Debian-based systems"

  vars_files:
    - group_vars/all/vault.yml

  roles:
    - { role: base, tags: base }
    - { role: sysctl, tags: sysctl }
    - { role: sshd, tags: sshd }
    - { role: ssh_client, tags: ssh_client }
    - { role: wireguard, tags: wireguard }
    - { role: firewall, tags: firewall }
    - { role: fail2ban, tags: fail2ban }
    - { role: samba, tags: samba }
    - { role: mount_diskstation, tags: diskstation }
    - { role: mount_android, tags: android }
    - { role: mail_sender, tags: mail }
    - { role: notifications, tags: notifications }
    - { role: cockpit, tags: cockpit }
    - { role: zsh, tags: zsh }
```
## Vault
создаём хранилище секретов
```
ansible-vault create group_vars/all/vault.yml
```
заносим туда  
(переименовать остальное тоже с приставкой `vault_`)
```
telegram_bot_token: "СВОЙ_TOKEN"
telegram_chat_id: "СВОЙ_CHAT_ID"
msmtp_user: "ПОЧТОВЫЙ_ЯЩИК_GMAIL"
msmtp_password: "ПАРОЛЬ_ПРИЛОЖЕНИЯ_GMAIL"
vault_wireguard_private_key: "ПРИВАТНЫЙ_КЛЮЧ_СЕРВЕРА"
```
если надо редактируем так
```
ansible-vault edit group_vars/all/vault.yml
```
## OpenSSL
нужно для генерации сертификата в роли [cockpit](#role-cockpit)  
установить если отсутствует
```
ansible-galaxy collection install community.crypto
```
либо создаём конфиг с требованиями  
`collections/requirements.yml`
```
collections:
  - name: community.crypto
```
тогда команда установки будет выглядеть так
```
ansible-galaxy collection install -r collections/requirements.yml
```
## РОЛИ
### role: base
`roles/base/tasks/main.yml`
```
- name: Install base packages
  apt:
    name:
      - git
      - curl
      - jq
      - tcpdump
      - rsync
      - ca-certificates
      - unattended-upgrades
    state: present
    update_cache: yes
```
## role: sysctl
`roles/sysctl/tasks/main.yml`
```
- name: Enable IP forwarding
  sysctl:
    name: net.ipv4.ip_forward
    value: '1'
    state: present
    reload: yes
```
## role: sshd
[templates](#templates-sshd)  
`roles/sshd/tasks/main.yml`
```
- name: Deploy sshd config
  template:
    src: sshd_config.j2
    dest: /etc/ssh/sshd_config
    owner: root
    group: root
    mode: '0644'
  notify:
    - validate ssh
    - restart ssh
```
`roles/sshd/handlers/main.yml`
```
- name: validate ssh
  command: sshd -t
  changed_when: false

- name: restart ssh
  service:
    name: ssh
    state: restarted
```
## role: ssh_client
[templates](#templates-ssh_client)  
`roles/ssh_client/tasks/main.yml`
```
- name: Ensure .ssh dir
  file:
    path: /home/{{ user }}/.ssh
    state: directory
    mode: '0700'
    owner: "{{ user }}"
    group: "{{ user }}"

- name: Deploy SSH config
  template:
    src: config.j2
    dest: /home/{{ user }}/.ssh/config
    mode: '0600'
    owner: "{{ user }}"
    group: "{{ user }}"
```
## role: wireguard
[templates](#templates-wireguard)  
`roles/wireguard/tasks/main.yml`
```
- name: Install WireGuard
  apt:
    name: wireguard
    state: present

- name: Deploy config
  template:
    src: "{{ wireguard_interface }}.conf.j2"
    dest: "/etc/wireguard/{{ wireguard_interface }}.conf"
    mode: '0600'
  notify: restart wg

- name: Enable service
  systemd:
    name: "wg-quick@{{ wireguard_interface }}"
    enabled: yes
    state: started
```
`roles/wireguard/tasks/handlers.yml`
```
- name: restart wg
  systemd:
    name: wg-quick@{{ wireguard_interface }}
    state: restarted
    enabled: yes
```
`roles/wireguard/meta/main.yml`
```
dependencies:
  - role: sysctl
```
## role: firewall
[templates](#templates-firewall)  
`roles/firewall/tasks/main.yml`
```
- name: Ensure required network vars defined
  assert:
    that:
      - wireguard_interface is defined
      - wireguard_network is defined
      - wireguard_port is defined
    fail_msg: "Required WireGuard variables are not defined"

- name: Ensure ssh port allowed in firewall
  assert:
    that: sshd_port in firewall_tcp_ports
  fail_msg: "SSH port is not listed in firewall settings"

- name: Install nftables
  apt:
    name: nftables
    state: present

- name: Create systemd override directory
  file:
    path: /etc/systemd/system/nftables.service.d
    state: directory
    mode: '0755'

- name: Check if wireguard service is enabled
  systemd:
    name: wg-quick@{{ wireguard_interface }}
  register: wg_service
  failed_when: false
  changed_when: false

- name: Fail if wireguard service is not enabled
  fail:
    msg: "WireGuard service wg-quick@{{ wireguard_interface }} is not enabled"
  when: not wg_service.status.enabled

- name: Ensure wireguard starts before nftables
  copy:
    dest: /etc/systemd/system/nftables.service.d/override.conf
    content: |
      [Unit]
      After=wg-quick@{{ wireguard_interface }}.service
      Requires=wg-quick@{{ wireguard_interface }}.service
  notify:
    - daemon reload

- name: Deploy nftables config
  template:
    src: nftables.conf.j2
    dest: /etc/nftables.conf
  notify: reload nftables

- name: Enable and start nftables
  systemd:
    name: nftables
    enabled: yes
    state: started
```
`roles/firewall/tasks/handlers.yml`
```
- name: reload nftables
  systemd:
    name: nftables
    state: reloaded
```
## role: fail2ban
[templates](#templates-fail2ban)  
`roles/fail2ban/tasks/main.yml`
```
- name: Install fail2ban
  apt:
    name: fail2ban
    state: present

- name: Deploy jail.local
  template:
    src: jail.local.j2
    dest: /etc/fail2ban/jail.local
    owner: root
    group: root
    mode: '0644'
  notify: restart fail2ban

- name: Deploy custom fail2ban actions
  copy:
    src: "action.d/{{ item }}"
    dest: "/etc/fail2ban/action.d/{{ item }}"
    owner: root
    group: root
    mode: '0644'
  loop:
    - telegram.conf
    - sendmail-common.conf
  notify: restart fail2ban

- name: Create override dir
  file:
    path: /etc/systemd/system/fail2ban.service.d
    state: directory
    mode: '0755'

- name: Deploy override
  template:
    src: override.conf.j2
    dest: /etc/systemd/system/fail2ban.service.d/override.conf
  notify:
    - daemon reload
    - restart fail2ban

- name: Enable and start fail2ban
  systemd:
    name: fail2ban
    enabled: yes
    state: started
```
`roles/fail2ban/tasks/handlers.yml`
```
- name: daemon reload
  systemd:
    daemon_reload: yes

- name: restart fail2ban
  systemd:
    name: fail2ban
    state: restarted
```
## role: samba
[templates](#templates-samba)  
`roles/samba/tasks/main.yml`
```
- name: Install Samba
  apt:
    name: samba
    state: present

- name: Deploy smb.conf
  template:
    src: smb.conf.j2
    dest: /etc/samba/smb.conf
  notify: restart samba
```
## role: mount_diskstation
`roles/mount_diskstation/tasks/main.yml`
```
- name: Ensure mount directories exist
  file:
    path: "{{ item.path }}"
    state: directory
    owner: "{{ user }}"
    group: "{{ user }}"
    mode: '0755'
  loop: "{{ nfs_mounts }}"

- name: Mount NFS shares
  mount:
    path: "{{ item.path }}"
    src: "{{ item.src }}"
    fstype: nfs
    opts: vers=3
    state: mounted
  loop: "{{ nfs_mounts }}"
```
`roles/mount_diskstation/defaults/main.yml`
```
nfs_mounts: []
```
`group_vars/all/fstab.yml`
```
nfs_mounts:
  - path: "{{ diskstation_mount_point }}/pub"
    src: "{{ diskstation_lan_ip }}:/volume1/PUB"
  - path: "{{ diskstation_mount_point }}/web"
    src: "{{ diskstation_lan_ip }}:/volume1/web"
```
## role: mount_android
`roles/mount_android/tasks/main.yml`
```
- name: Install sshfs
  apt:
    name: sshfs
    state: present

- name: Enable user_allow_other
  lineinfile:
    path: /etc/fuse.conf
    regexp: '^#?user_allow_other'
    line: 'user_allow_other'

- name: Ensure android mount dir exists
  file:
    path: "{{ android_mount_point }}"
    state: directory
    owner: "{{ user }}"
    group: "{{ user }}"
    mode: '0755'
```
watcher-скрипт копируется через notifications или отдельно
## role: mail_sender
[templates](#templates-msmtp)  
`roles/mail_sender/tasks/main.yml`
```
- name: Install msmtp
  apt:
    name: msmtp
    state: present

- name: Deploy msmtp config
  template:
    src: msmtprc.j2
    dest: /etc/msmtprc
    owner: root
    group: msmtp
    mode: '0640'
```
## role: notifications
[templates](#templates-уведомления)  
автообнаружение скриптов для отправки уведомлений в телеграм  
структура:
```
roles/notifications/
├── files/scripts/
├── templates/tgbot_notify.sh.j2
```
`roles/notifications/tasks/main.yml`
```
- name: Copy scripts directory
  copy:
    src: scripts/
    dest: /usr/local/bin/
    mode: '0755'

- name: Deploy watcher scripts
  template:
    src: "{{ item }}"
    dest: "/usr/local/bin/{{ item | regex_replace('.j2','') }}"
    mode: '0755'
  loop:
    - android-connection-watcher.sh.j2
    - ssh_success_watcher.sh.j2
    - tgbot_notify.sh.j2
    - vpn_success_watcher.sh.j2

- name: Deploy systemd services
  copy:
    src: "systemd/{{ item }}"
    dest: "/etc/systemd/system/{{ item }}"
  loop:
    - android-watcher.service
    - ssh-success-watcher.service
    - vpn-success-watcher.service
  notify: daemon reload

- name: Enable services
  systemd:
    name: "{{ item }}"
    enabled: yes
    state: started
  loop:
    - android-watcher
    - ssh-success-watcher
    - vpn-success-watcher
```
`roles/notifications/tasks/handlers.yml`
```
- name: daemon reload
  systemd:
    daemon_reload: yes
```
## role: cockpit
`roles/cockpit/tasks/main.yml`
```
- name: Install Cockpit
  apt:
    name: cockpit
    state: present
    update_cache: yes

- name: Ensure cert directory exists
  file:
    path: "{{ cockpit_cert_dir }}"
    state: directory
    mode: '0755'

- name: Generate private CA key
  community.crypto.openssl_privatekey:
    path: "{{ cockpit_cert_dir }}/{{ cockpit_cert_name }}.key"
    size: 4096
    type: RSA
    mode: '0600'

- name: Generate self-signed certificate
  community.crypto.x509_certificate:
    path: "{{ cockpit_cert_dir }}/{{ cockpit_cert_name }}.cert"
    privatekey_path: "{{ cockpit_cert_dir }}/{{ cockpit_cert_name }}.key"
    provider: selfsigned
    subject:
      countryName: "{{ cockpit_country }}"
      stateOrProvinceName: "{{ cockpit_state }}"
      localityName: "{{ cockpit_locality }}"
      organizationName: "{{ cockpit_org }}"
      commonName: "{{ cockpit_cn }}"
    subject_alt_name: "{{ cockpit_san }}"
    not_after: "+365d"
  notify: restart cockpit

- name: Enable cockpit
  systemd:
    name: cockpit
    enabled: yes
    state: started
```
`roles/cockpit/defaults/main.yml`
```
cockpit_cert_dir: /etc/cockpit/ws-certs.d
cockpit_cert_name: 10-nuc

cockpit_country: RU
cockpit_state: Tatarstan
cockpit_locality: Kazan
cockpit_org: Home
cockpit_cn: nuc-server

cockpit_san:
  - "DNS:nuc-server"
  - "IP:{{ server_lan_ip }}"
  - "IP:127.0.0.1"
```
`roles/cockpit/handlers/main.yml`
```
- name: restart cockpit
  systemd:
    name: cockpit
    state: restarted
```
## role: zsh
[templates](#создать-общие-переменные)  
`roles/zsh/tasks/main.yml`
```
- name: Install zsh
  apt:
    name: zsh
    state: present

- name: Clone oh-my-zsh
  become: yes
  become_user: "{{ user }}"
  git:
    repo: https://github.com/ohmyzsh/ohmyzsh.git
    dest: /home/{{ user }}/.oh-my-zsh
    version: master
    update: no

- name: Clone syntax highlighting
  become: yes
  become_user: "{{ user }}"
  git:
    repo: https://github.com/zsh-users/zsh-syntax-highlighting.git
    dest: /home/{{ user }}/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting  

- name: Clone autosuggestions
  become: yes
  become_user: "{{ user }}"
  git:
    repo: https://github.com/zsh-users/zsh-autosuggestions
    dest: /home/{{ user }}/.oh-my-zsh/custom/plugins/zsh-autosuggestions

- name: Clone personal config
  become: yes
  become_user: "{{ user }}"
  git:
    repo: "{{ zsh_repo_url }}"
    dest: "/home/{{ user }}/{{ zsh_repo_dir }}"

- name: Symlink .zshrc
  become: yes
  become_user: "{{ user }}"
  file:
    src: "/home/{{ user }}/{{ zsh_repo_dir }}/.zshrc"
    dest: "/home/{{ user }}/.zshrc"
    state: link
```
`roles/zsh/defaults/main.yml`
```
zsh_repo_url: git@github.com:ryusandorosu/zsh_settings.git
zsh_repo_dir: zsh_settings
```

# размещаем конфиги сервера в репозитории
#### конфиг ssh клиента
`~/.ssh/config` → `roles/ssh_client/templates/config.j2`
#### конфиг sshd
`/etc/ssh/sshd_config` → `roles/sshd/templates/sshd_config.j2`
#### профиль wireguard
`/etc/wireguard/wg0.conf` → `roles/wireguard/templates/wg0.conf.j2`
#### конфиги fail2ban
`/etc/fail2ban/jail.local` → `roles/fail2ban/templates/jail.local.j2`  
`/etc/fail2ban/action.d/` → `roles/fail2ban/files/action.d/`  
- `telegram.conf`
- `sendmail-common.conf`
#### конфиг samba
`/etc/samba/smb.conf` → `roles/samba/templates/smb.conf.j2`
#### конфиг fstab
`/etc/fstab` не копируем, всё в роли [mount_diskstation](#role-mount_diskstation)
#### конфиг msmtp
`/etc/msmtprc` → `roles/msmtp/templates/msmtprc.j2`
#### скрипты для отправки уведомлений в телеграм
`/usr/local/bin/ssh_success_watcher.sh` → `roles/notifications/templates/ssh_success_watcher.sh.j2`  
`/usr/local/bin/tgbot_notify.sh` → `roles/notifications/templates/tgbot_notify.sh.j2`  
`/usr/local/bin/android-connection-watcher.sh` → `roles/notifications/templates/android-connection-watcher.sh.j2`  
`/usr/local/bin/vpn_success_watcher.sh` → `roles/notifications/templates/vpn_success_watcher.sh.j2`  
#### сервисы для запуска скриптов уведомлений
`/etc/systemd/*.service` → `roles/notifications/files/systemd/*.service`

# редактируем конфиги которые закинули в *\*/templates/\**
#### templates: sshd
[role](#role-sshd)  
выносим значения в переменные  
`roles/sshd/defaults/main.yml`
```
sshd_port: 22
sshd_permit_root_login: "no"
sshd_password_authentication: "no"
sshd_pubkey_authentication: "yes"
sshd_allow_users: []
```
`roles/sshd/templates/sshd_config.j2`
```
Port {{ sshd_port }}

Protocol 2

PermitRootLogin {{ sshd_permit_root_login }}
PasswordAuthentication {{ sshd_password_authentication }}
PubkeyAuthentication {{ sshd_pubkey_authentication }}

ChallengeResponseAuthentication no
UsePAM yes

X11Forwarding no
PrintMotd no

{% if sshd_allow_users | length > 0 %}
AllowUsers {% for user in sshd_allow_users %}{{ user }} {% endfor %}
{% endif %}

Subsystem sftp /usr/lib/openssh/sftp-server
```
#### templates: ssh_client
[role](#role-ssh_client)  
выносим всё содержимое `roles/ssh_client/templates/config.j2` в переменные  
`roles/ssh_client/defaults/main.yml`
```
ssh_hosts:
  - name: github
    hostname: github.com
    user: git
    identity: github

  - name: redmi
    hostname: "{{ phone_ip }}"
    port: "{{ termux_port }}"
    user: "{{ termux_user }}"
    identity: "{{ termux_key }}"
```
заменяем содержимое шаблонизированным циклом  
`roles/ssh_client/templates/config.j2`
```
{% for host in ssh_hosts %}
Host {{ host.name }}
    HostName {{ host.hostname }}
    User {{ host.user }}
    IdentityFile ~/.ssh/{{ host.identity }}
{% if host.port is defined %}
    Port {{ host.port }}
{% endif %}

{% endfor %}
```
#### templates: wireguard
[role](#role-wireguard)  
[сюда выносим ключ](#vault)  
`roles/wireguard/templates/wg0.conf.j2` → `group_vars/all/network.yml`
```
# WireGuard core
wireguard_interface: wg0
wireguard_port: 51820
wireguard_server_ip: 10.10.0.1
```
`roles/wireguard/templates/wg0.conf.j2` → `group_vars/all/network.yml`  
удаляем блоки с клиентами
```
#PC: ASUS K95VB
[Peer]
PublicKey = AAA...
AllowedIPs = 10.10.0.2/32

#PHONE: REDMI 14C
[Peer]
PublicKey = BBB...
AllowedIPs = 10.10.0.3/32

#PAD: SAMSUNG GALAXY TAB A6
[Peer]
PublicKey = CCC...
AllowedIPs = 10.10.0.4/32
```
в переменных это будет выглядеть так
```
# Devices
laptop_ip: 10.10.0.2
phone_ip: 10.10.0.3
pad_ip: 10.10.0.4

wireguard_peers:
  - name: laptop
    public_key: "AAA..."
    ip: "{{ laptop_ip }}"
  - name: phone
    public_key: "BBB..."
    ip: "{{ phone_ip }}"
  - name: pad
    public_key: "CCC..."
    ip: "{{ pad_ip }}"
```
`roles/wireguard/templates/wg0.conf.j2`  
убираем отсюда nat, это будет в роли [firewall](#role-firewall)
```
[Interface]
PrivateKey = {{ wireguard_private_key }}
Address = {{ wireguard_server_ip }}/24
ListenPort = {{ wireguard_port }}

{% for peer in wireguard_peers %}
# {{ peer.name }}
[Peer]
PublicKey = {{ peer.public_key }}
AllowedIPs = {{ peer.ip }}/32

{% endfor %}
```
вместо
```
#NAT: to access DS209 via VPN
PostUp = nft add table ip wg-nat
PostUp = nft 'add chain ip wg-nat postrouting { type nat hook postrouting priority 100 ; }'
PostUp = nft add rule ip wg-nat postrouting oifname "wlp2s0" ip saddr 10.10.0.0/24 masquerade
PostDown = nft delete table ip wg-nat
```
добавляем сюда  
`roles/firewall/templates/nftables.conf.j2`
```
table ip nat {
    chain postrouting {
        type nat hook postrouting priority 100;
        oifname "{{ firewall_wan_interface }}" ip saddr {{ wireguard_network }} masquerade
    }
}
```
#### templates: firewall
[role](#role-firewall)  
`roles/firewall/defaults/main.yml`
```
firewall_tcp_ports:
  - 22
  - 80
  - 443

firewall_udp_ports:
  - "{{ wireguard_port }}"

firewall_wan_interface: wlp2s0
```
а это шаблонизируется в `group_vars/all/network.yml`
```
wireguard_network: 10.10.0.0/24
```
`roles/firewall/templates/nftables.conf.j2`
```
flush ruleset

table inet filter {
    chain input {
        type filter hook input priority 0; 
        policy drop;

        ct state established,related accept
        iif lo accept

{% for port in firewall_tcp_ports %}
{% if port == 22 %}
    tcp dport 22 ct state new limit rate 10/minute burst 20 packets accept
{% else %}
    tcp dport {{ port }} accept
{% endif %}
{% endfor %}

{% for port in firewall_udp_ports %}
        udp dport {{ port }} accept
{% endfor %}

        iif "{{ wireguard_interface }}" accept

        limit rate 5/minute log prefix "nft-input-drop: " flags all counter drop
    }

    chain forward {
        type filter hook forward priority 0;
        policy drop;

        ct state established,related accept
        iif "{{ wireguard_interface }}" oif "{{ firewall_wan_interface }}" accept
        iif "{{ wireguard_interface }}" oif "{{ wireguard_interface }}" accept
    }

    chain output {
        type filter hook output priority 0;
        policy accept;
    }
}
```
#### templates: fail2ban
[role](#role-fail2ban)  
выносим всё содержимое `roles/fail2ban/templates/jail.local.j2` в переменные  
`roles/fail2ban/defaults/main.yml`
```
fail2ban_ignoreip:
  - "{{ home_ip }}"
  - "{{ server_lan_ip }}"

fail2ban_bantime: 1h
fail2ban_bantime_increment: true
fail2ban_bantime_factor: 2
fail2ban_bantime_max: 1week
fail2ban_findtime: 10m
fail2ban_maxretry: 3
fail2ban_backend: systemd
fail2ban_action: telegram

fail2ban_jails:
  - name: sshd
    enabled: true
    port: 22

  - name: recidive
    enabled: true
    logpath: /var/log/fail2ban.log
    backend: auto
    bantime: 1month
    findtime: 1d
    maxretry: 2
```
заменяем все значения на шаблоны  
`roles/fail2ban/templates/jail.local.j2`  
```
[DEFAULT]
ignoreip = {{ fail2ban_ignoreip | join(' ') }}
bantime = {{ fail2ban_bantime }}
bantime.increment = {{ fail2ban_bantime_increment | lower }}
bantime.factor = {{ fail2ban_bantime_factor }}
bantime.max = {{ fail2ban_bantime_max }}
findtime = {{ fail2ban_findtime }}
maxretry = {{ fail2ban_maxretry }}
backend = {{ fail2ban_backend }}
action = {{ fail2ban_action }}

{% for jail in fail2ban_jails %}
[{{ jail.name }}]
enabled = {{ jail.enabled | lower }}

{% for key, value in jail.items() if key not in ['name', 'enabled'] %}
{{ key }} = {{ value }}
{% endfor %}

{% endfor %}
```
`roles/fail2ban/templates/override.conf.j2`
```
[Service]
ExecStartPost=
ExecStartPost=/bin/bash -c '/usr/local/bin/tgbot_notify.sh "🟢 fail2ban service started"'

ExecStopPost=
ExecStopPost=/bin/bash -c '/usr/local/bin/tgbot_notify.sh "🔴 fail2ban service stopped"'
```
сначала обнуляем чтобы не получить дубли при перезаписях
#### templates: samba
[role](#role-samba)  
`roles/samba/templates/smb.conf.j2` → `roles/samba/defaults/main.yml`
```
samba_workgroup: WORKGROUP
samba_server_string: NUC Server
samba_netbios_name: NUC

samba_shares: []
```
`roles/samba/templates/smb.conf.j2` → `group_vars/all/samba.yml`
```
samba_shares:
  - name: NUC
    path: "{{ shared_dir }}"
  - name: REDMI
    path: "{{ android_mount_point }}"
```
`roles/samba/templates/smb.conf.j2`  
в разделе `[global]` подставляем шаблоны
```
   server string = {{ samba_server_string }}
   netbios name = {{ samba_netbios_name }}
   workgroup = {{ samba_workgroup }}
```
а в конце заменяем блок
```
[NUC]
   path = /srv/share
   browseable = yes
   writable = yes
   guest ok = no
   read only = no

[REDMI]
   path = /srv/android
   browseable = yes
   writable = yes
   guest ok = no
   read only = no
```
на
```
{% for share in samba_shares %}
[{{ share.name }}]
   path = {{ share.path }}
   browsable = yes
   writable = yes
   guest ok = no
   read only = no
{% endfor %}
```
#### templates: msmtp
[role](#role-mail_sender)  
`roles/mail_sender/defaults/main.yml`
```
msmtp_account: gmail
msmtp_host: smtp.gmail.com
msmtp_port: 587
```
`roles/mail_sender/templates/msmtprc.j2`
```
defaults
auth           on
tls            on
tls_starttls   on
tls_trust_file /etc/ssl/certs/ca-certificates.crt
syslog         on

account {{ msmtp_account }}
host {{ msmtp_host }}
port {{ msmtp_port }}
from {{ msmtp_user }}
user {{ msmtp_user }}
password {{ msmtp_password }}

account default : {{ msmtp_account }}
```
[сюда выносим почтовый ящик и пароль](#vault)
#### templates: уведомления
[role](#role-notifications)  
`roles/notifications/templates/tgbot_notify.sh.j2`  
[сюда выносим токен и чат айди](#vault)
```
TOKEN="{{ telegram_bot_token }}"
CHAT_ID="{{ telegram_chat_id }}"
```
`roles/notifications/templates/ssh_success_watcher.sh.j2`
```
if [[ "$ip" != "{{ home_ip }}" ]]; then
```
`roles/notifications/templates/android-connection-watcher.sh.j2`
```
#!/bin/bash

get_id() {
    echo $(id "$1") | grep -oP "[[:alnum:]]+=[^]+\([^\)]+" | grep "$2" | grep -oP "[[:digit:]]+" ;
}
SSH_KEY=/home/{{ user }}/.ssh/{{ termux_key }}
SSH_COMMAND="ssh -i $SSH_KEY -p {{ termux_port }}"
SSH_HOST={{ termux_user }}@{{ phone_ip }}
SSH_PATH=/data/data/com.termux/files/home/storage/shared/
SSH_TARGET=$SSH_HOST:$SSH_PATH

while true; do
    if ping -c1 -W1 {{ phone_ip }} >/dev/null 2>&1; then
        if ! mountpoint -q "${{ android_mount_point }}"; then
            echo "Phone detected. Mounting..."
            /usr/bin/sshfs \
              -o ssh_command="$SSH_COMMAND" \
              -o allow_other \
              -o reconnect \
              -o uid=$(get_id ${{ user }} uid) \
              -o gid=$(get_id ${{ user }} gid) \
              -o umask=0022 \
              $SSH_TARGET \
              ${{ android_mount_point }}
        fi
    else
        if mountpoint -q "${{ android_mount_point }}"; then
            echo "Phone lost. Unmounting..."
            fusermount -u "${{ android_mount_point }}"
        fi
    fi
    sleep 3
done
```
`roles/notifications/templates/vpn_success_watcher.sh.j2`
```
#!/bin/bash

declare -A WAS_ZERO

while true; do
    while read -r PUBKEY EPOCH; do

        # если peer ещё никогда не подключался
        if [[ "$EPOCH" == "0" ]]; then
            WAS_ZERO[$PUBKEY]=1
            continue
        fi

        # если раньше было 0 и теперь стало > 0
        if [[ "${WAS_ZERO[$PUBKEY]}" == "1" ]]; then

            ENDPOINT=$(wg show {{ wireguard_interface }} endpoints | grep "$PUBKEY" | awk '{print $2}')
            ALLOWED=$(wg show {{ wireguard_interface }} allowed-ips | grep "$PUBKEY" | awk '{print $2}')
            IP=$(echo "$ENDPOINT" | cut -d: -f1)
            AS_IP=$(echo "$ALLOWED" | cut -d: -f1)

MESSAGE="🔐 VPN connection success
From: $IP
<pre>$(curl -s http://ip-api.com/json/${IP} | jq)</pre>
As: $AS_IP"
/usr/local/bin/tgbot_notify.sh "$MESSAGE"

            WAS_ZERO[$PUBKEY]=0
        fi

    done < <(wg show {{ wireguard_interface }} latest-handshakes)

    sleep 10
done
```
#### создать общие переменные
`group_vars/all/user.yml`
```
user: ryusandorosu

sshd_allow_users:
  - "{{ user }}"
```
`group_vars/all/network.yml`
```
# Termux
termux_port: 8022
termux_user: u0_a497
termux_key: android_termux

# Home Network
home_ip: 87.117.169.26
server_lan_ip: 192.168.0.107
diskstation_lan_ip: 192.168.0.111
```
`group_vars/all/mounts.yml`
```
shared_dir: /srv/share
diskstation_mount_point: /mnt/ds209
android_mount_point: /srv/android
```
# тестирование всего плейбука
прежде чем запускать в любом режиме - надо передать ансиблу пароль
```
ansible-playbook playbook.yml --ask-vault-pass
```
проверка синтаксиса
```
ansible-playbook playbook.yml --syntax-check
```
проверка на ошибки
```
ansible-playbook playbook.yml --check
```
если в ямлах есть ошибки - пароль не будет принят  
тогда для дебага можно запускать проверки сразу с запросом пароля
```
ansible-playbook playbook.yml --ask-vault-pass --syntax-check
ansible-playbook playbook.yml --ask-vault-pass --check
```
если пишет про ошибку без конкретики
```
PLAY [server] ********************************************************************************************************************************************************
[ERROR]: YAML parsing failed: This may be an issue with missing quotes around a template block.
```
то запускаем с добавлением verbose режима
```
ansible-playbook playbook.yml --ask-vault-pass --syntax-check -vvv
ansible-playbook playbook.yml --ask-vault-pass --check -vvv
```
убедиться что ssh открыт до применеия роли [firewall](#role-firewall), иначе можно заблокировать себя. запускать команду с открытой ssh-сессией
```
ansible-playbook playbook.yml --limit test-host
```
### ansible-lint
установка
```
sudo apt install python-pip3 pipx
pipx install ansible-lint
```
запуск
```
ansible-lint
```
# юнит-тесты
#### 1. установка `molecule`
```
sudo apt install docker
sudo apt install python-pip3
pip install molecule molecule-plugins[docker] ansible-lint
```
использование  
перейти в роль, к примеру
```
cd roles/sshd
molecule init scenario -d docker default
```
это создаст
```
roles/sshd/molecule/default/
  ├── converge.yml
  ├── molecule.yml
  └── verify.yml
```
#### 2. настройка `molecule`
`molecule.yml`
```
driver:
  name: docker

platforms:
  - name: debian
    image: debian:12
    privileged: true
    command: /lib/systemd/systemd

provisioner:
  name: ansible

verifier:
  name: ansible
```
`privileged: true` нужен для systemd  

`converge.yml`  
это playbook который применяет роль
```
- name: Converge
  hosts: all
  become: yes
  roles:
    - role: sshd
```
если роль требует переменных
```
  vars:
    user: testuser
    sshd_allow_users:
      - testuser
```
`verify.yml`
```
- name: Verify
  hosts: all
  tasks:
    - name: Check sshd config exists
      stat:
        path: /etc/ssh/sshd_config
      register: sshd_conf

    - name: Assert sshd config created
      assert:
        that:
          - sshd_conf.stat.exists

    - name: Check ssh service enabled
      command: systemctl is-enabled ssh
      register: ssh_status
      changed_when: false

    - name: Assert ssh enabled
      assert:
        that:
          - ssh_status.stdout == "enabled"
```
#### 3. запуск теста `molecule`
там же в папке роли
```
molecule test
```
проверка идемпотентности
```
molecule idempotence
```
# запуск плейбука
