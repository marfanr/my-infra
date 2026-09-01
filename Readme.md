## ansible
create a role with ansible galaxy
```sh
ansible-galaxy init 'name'
```
playbook
```
ansible-playbook -
```

vault
```sh
ansible-vault encrypt_string --vault-password-file a_password_file 'foobar' --name 'the_secret'
```