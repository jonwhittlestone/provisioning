# Provisioning

## provision-doylestone02

### Usage

1. Ensure public key is in `authorized_keys` on `doylestone02`

2. Activate virtualenv to gain access to Ansible

   ```bash
   ➜  cd provision-doylestone02
   ➜  poetry install
   ```

3. Sanity check Ansible connection

   ```bash
   ➜  provision-doylestone02 ansible -i ansible/inventory doylestone02 -a "free -h" -u fam
   192.168.0.97 | CHANGED | rc=0 >>
               total        used        free      shared  buff/cache   available
   Mem:            29Gi       688Mi        27Gi       2.0Mi       1.2Gi        28Gi
   Swap:             0B          0B          0B
   ```
