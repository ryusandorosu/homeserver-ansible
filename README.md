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

# запуск плейбука
### playbook: vault
если есть vault, а он у нас есть, то запуск осуществляется добавлением следующего флага
```
ansible-playbook playbook.yml --ask-vault-pass
```
а проверки запускаем так
```
ansible-playbook playbook.yml --ask-vault-pass --syntax-check
ansible-playbook playbook.yml --ask-vault-pass --check
```
пароль от хранилища можно считывать из файла, указав к нему путь в `ansible.cfg`  
тогда флаг использовать не нужно
```
[defaults]
vault_password_file = path_to_password_file
```
### playbook: verbose
если пишет про ошибку без конкретики
```
PLAY [server] ********************************************************************************************************************************************************
[ERROR]: YAML parsing failed: This may be an issue with missing quotes around a template block.
```
то запускаем с добавлением verbose режима
```
ansible-playbook playbook.yml --ask-vault-pass --check -vvv
```
да, без них ансибл просто пишет о статусе выполненной роли
```
ansible-playbook playbook.yml -v
ansible-playbook playbook.yml -vv
ansible-playbook playbook.yml -vvv
ansible-playbook playbook.yml --diff
ansible-playbook playbook.yml -vv --diff
```
если не задали в `ansible.cfg` записывание в лог и запускали без этих флагов, то мы не увидим что было изменено!
### playbook: разница между флагами verbose и diff
`-v` показывает немного больше информации  
`-vv` показывает
- register variables
- return values structure
- больше деталей модуля

`-vvv` показывает
- ssh debug
- точные команды
- python interpreter
- internal execution
- по сути это дебаг-режим

`--diff` показывает  
старое содержимое → новое содержимое  
работает для
- template
- copy
- lineinfile
- blockinfile

### playbook: sudo
если просит пароль sudo
```
[ERROR]: Task failed: Premature end of stream waiting for become success.
>>> Standard Error
sudo: a password is required

fatal: [localhost]: FAILED! => {"changed": false, "msg": "Task failed: Premature end of stream waiting for become success.\n>>> Standard Error\nsudo: a password is required"}

PLAY RECAP ***********************************************************************************************************************************************************
localhost                  : ok=0    changed=0    unreachable=0    failed=1    skipped=0    rescued=0    ignored=0
```
то добавляем также запрос пароля от sudo
```
ansible-playbook playbook.yml --ask-vault-pass --ask-become-pass
```
или короче
```
ansible-playbook playbook.yml -K --ask-vault-pass
```
или добавляем в `inventory` для хоста и НЕ используем флаг, но перед запуском плейбука выполняем команду `sudo -v`
```
ansible_become=true ansible_become_method=sudo
```
или добавляем в `ansible.cfg` блок и НЕ используем флаг
```
[privilege_escalation]
become=True
become_method=sudo
become_ask_pass=True
```
### playbook: host
если в `inventory` в группе хостов указано несколько и плейбук запускается без этого параметра - он будет деплоиться на все!  
для запуска локально
```
ansible-playbook -l local playbook.yml -K --ask-vault-pass
```
для запуска удалённо
```
ansible-playbook -l remote playbook.yml -K --ask-vault-pass
```
### playbook: tags
запустить тег что задаётся каждой роли в `playbook.yml`
```
ansible-playbook playbook.yml -l local -K --tag cockpit
```
пропустить тег что задаётся каждой роли в `playbook.yml`
```
ansible-playbook playbook.yml -l local -K --skip-tags cockpit --check
```
нужно например при запуске с флагом `--check`, так как например роль [cockpit](#role-cockpit) на нём будет валиться несмотря на то что отрабатывает при обычном запуске без ошибок.  
в нём используются модули `community.crypto` которые плохо совместимы с check mode поскольку работают с реальными файлами и криптографией.  
также с флагом `--check` не работает template validate  
проверять [юнит-тестами](#юнит-тесты)
###
? убедиться что ssh открыт до применеия роли [firewall](#role-firewall), иначе можно заблокировать себя. запускать команду с открытой ssh-сессией
```
ansible-playbook playbook.yml --limit test-host
```
#
# создаём конфиги ансибла
### корневая папка репозитория
`ansible.cfg` - задаём глобальные параметры выполнения плейбука  
- `log_path` = куда записывать лог. если параметр не задан - вывод только в терминал
`inventory` - задаём перечень хостов/хоста на которых будет выполняться плейбук и параметры для них  
`playbook.yml` - задаём порядок выполнения ролей
## Vault
создаём хранилище секретов
```
ansible-vault create group_vars/all/vault.yml
```
заносим туда  
```
vault_telegram_bot_token: "СВОЙ_TOKEN"
vault_telegram_chat_id: "СВОЙ_CHAT_ID"
vault_msmtp_user: "ПОЧТОВЫЙ_ЯЩИК_GMAIL"
vault_msmtp_password: "ПАРОЛЬ_ПРИЛОЖЕНИЯ_GMAIL"
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
# создаём роли
## role: base
`roles/base/tasks/main.yml`
## role: sysctl
`roles/sysctl/tasks/main.yml`
## role: sshd
[templates](#templates-sshd)  
`roles/sshd/tasks/main.yml`
`roles/sshd/handlers/main.yml`
## role: ssh_client
[templates](#templates-ssh_client)  
`roles/ssh_client/tasks/main.yml`
## role: wireguard
[templates](#templates-wireguard)  
`roles/wireguard/tasks/main.yml`
`roles/wireguard/handlers/main.yml`
`roles/wireguard/meta/main.yml`
## role: firewall
[templates](#templates-firewall)  
`roles/firewall/tasks/main.yml`
`roles/firewall/handlers/main.yml`
## role: fail2ban
[templates](#templates-fail2ban)  
`roles/fail2ban/tasks/main.yml`
`roles/fail2ban/handlers/main.yml`
## role: samba
[templates](#templates-samba)  
`roles/samba/tasks/main.yml`
## role: mount_diskstation
`roles/mount_diskstation/tasks/main.yml`
`roles/mount_diskstation/defaults/main.yml`
`group_vars/all/fstab.yml`
## role: mount_android
`roles/mount_android/tasks/main.yml`  
watcher-скрипт копируется через notifications или отдельно
## role: mail_sender
[templates](#templates-msmtp)  
`roles/mail_sender/tasks/main.yml`
## role: notifications
[templates](#templates-уведомления)  
автообнаружение скриптов для отправки уведомлений в телеграм  
`roles/notifications/tasks/main.yml`
`roles/notifications/handlers/main.yml`
## role: cockpit
`roles/cockpit/tasks/main.yml`
`roles/cockpit/defaults/main.yml`
`roles/cockpit/handlers/main.yml`
## role: zsh
[templates](#создать-общие-переменные)  
`roles/zsh/tasks/main.yml`
`roles/zsh/defaults/main.yml`

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
`roles/sshd/templates/sshd_config.j2`
#### templates: ssh_client
[role](#role-ssh_client)  
выносим всё содержимое `roles/ssh_client/templates/config.j2` → `roles/ssh_client/defaults/main.yml`  
заменяем всё шаблонизированным циклом  
`roles/ssh_client/templates/config.j2`
#### templates: wireguard
[role](#role-wireguard)  
[сюда выносим ключ](#vault)  
сюда выносим все значения  
`roles/wireguard/templates/wg0.conf.j2` → `group_vars/all/network.yml`  
здесь тоже шаблонизированный цикл  
`roles/wireguard/templates/wg0.conf.j2`  
убираем отсюда nat, это будет в роли [firewall](#role-firewall)  
`roles/wireguard/templates/wg0.conf.j2` → `roles/firewall/templates/nftables.conf.j2`
#### templates: firewall
[role](#role-firewall)  
`roles/firewall/defaults/main.yml`
`roles/firewall/templates/nftables.conf.j2`
#### templates: fail2ban
[role](#role-fail2ban)  
выносим всё содержимое  
`roles/fail2ban/templates/jail.local.j2` → `roles/fail2ban/defaults/main.yml`  
заменяем все значения на шаблоны, а для джейлов цикл   
`roles/fail2ban/templates/jail.local.j2`  
сначала обнуляем чтобы не получить дубли при перезаписях  
`roles/fail2ban/templates/override.conf.j2`
#### templates: samba
[role](#role-samba)  
секцию `[global]` сюда  
`roles/samba/templates/smb.conf.j2` → `roles/samba/defaults/main.yml`  
переменные с шарами сюда  
`roles/samba/templates/smb.conf.j2` → `group_vars/all/samba.yml`  
в конце блок шар меняем на цикл  
`roles/samba/templates/smb.conf.j2`  
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
`roles/mail_sender/templates/msmtprc.j2`  
[сюда выносим почтовый ящик и пароль](#vault)
#### templates: уведомления
[role](#role-notifications)  
[сюда выносим токен и чат айди](#vault)  
`roles/notifications/templates/tgbot_notify.sh.j2`  
тут только ip на переменную  
`roles/notifications/templates/ssh_success_watcher.sh.j2`  
`roles/notifications/templates/android-connection-watcher.sh.j2`  
`roles/notifications/templates/vpn_success_watcher.sh.j2`
#### создать общие переменные
здесь определяем переменную для пользователя и вносим его в список разрешённых для sshd  
`group_vars/all/user.yml`  
сюда выносим свой статический ip и адреса локальной сети  
и данные для подключения к термуксу по ssh  
`group_vars/all/network.yml`  
здесь задаём точки монтирования  
`group_vars/all/mounts.yml`  

# тестирование всего плейбука
проверка синтаксиса
```
ansible-playbook playbook.yml --syntax-check
```
проверка на ошибки
```
ansible-playbook playbook.yml --check
```
[при необходимости добавляем к ним флаг запроса пароля](#запуск-плейбука)
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
