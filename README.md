# Provisioning

## provision-doylestone02

### Usage

1. Ensure public key is in `authorized_keys` on `doylestone02`

2. Activate virtualenv to gain access to Ansible

   ```bash
   ➜  cd provision-doylestone02/ansible
   ➜  poetry install
   ```

3. Sanity check Ansible connection with setup module

   ```bash
   ➜  ansible -i inventory doylestone02 -m setup
   192.168.0.203 | SUCCESS => {
    "ansible_facts": {
        "ansible_all_ipv4_addresses": [
            "192.168.0.97",
            "192.168.0.203"
        ],
        "ansible_all_ipv6_addresses": [
            "fe80::b3ca:7bdf:f2d8:b7aa",
            "fe80::3ef5:2964:8942:db19"
        ],
        "ansible_apparmor": {
            "status": "enabled"
        },
        "ansible_architecture": "x86_64",
        ...
    }
   ```

4. Run playbook

   ```bash
   ➜  pwd
   /home/jon/code/provisioning/provision-doylestone02/ansible
   ➜  ansible-playbook main.yml --vault-password-file=../../.vault-password
   ```
