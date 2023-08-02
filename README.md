# Provisioning

A collection of personal Ansible/nixOS scripts.

```
host            description                                 NixOS     Ansible
doylestone01    Dual-boot Ryzen desktop: Win11
doylestone02    Dual-boot Ryzen desktop: Ubuntu 22.04                   ✅
doylestone03    Dual-boot Ryzen desktop: VM                             ✅
doylestone04    Dual-boot L380: Win11
doylestone05    rPi 400: monitoring, pi-hole etc
doylestone06    Dual-boot L380: NixOS                         ✅
madebyjon       T480s NixOS                                   ✅
```

## nixos-config

Basic scripts for provisioning my dev laptop

```bash
cd nixos-config; make deploy
```

> Coming to a fresh, new, machine?
> Read how to set up a git managed Flake on NixOS from scratch
> [fresh-nixos-guide.md](./fresh-nixos-guide.md)

### Todo.

```bash
- [x] Modularise
- [x] How to use this on a vanilla install NixOS

```

## provision-doylestone02

### Usage - Ansible

1. Keys:

   - Ensure public key for controller is in `authorized_keys` on `doylestone02`
   - For GitHub ssh clone, copy private key to target

     `scp ~/.ssh/id_rsa fam@doylestone02:/home/fam/.ssh/`

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

### Features

- code-server
  - http://192.168.0.203:8443/?folder=/home/fam/code/provisioning
- Jenkins
  - http://192.168.0.203:8080

## provision-doylestone03

### Usage

Run the `Vagrantfile` with `vagrant up --provision` to start the VM. [Jenkins](http://192.168.0.203:8080) will be available on port 8080

```bash
➜  pwd
/home/jon/code/provisioning/provision-doylestone03/

➜ vagrant up --provision
```
