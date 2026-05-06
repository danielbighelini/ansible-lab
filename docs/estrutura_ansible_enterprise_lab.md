# Estrutura Recomendada para Ambiente Ansible (WSL2 + Ubuntu)

## Objetivo

Construir um ambiente:
- organizado;
- escalável;
- seguro;
- próximo de ambientes enterprise reais;
- preparado para evoluir para automação PowerScale/OneFS.

---

# 1. Estrutura Base Recomendada

```text
~/ansible-lab/
│
├── ansible.cfg
│
├── inventory/
│   ├── hosts.yml
│   ├── prod/
│   ├── hml/
│   └── dev/
│
├── group_vars/
│   ├── all.yml
│   └── vault.yml
│
├── host_vars/
│
├── playbooks/
│   ├── hello.yml
│   ├── reconcile.yml
│   ├── powerscale/
│   └── utilities/
│
├── roles/
│   ├── powerscale_bucket/
│   │   ├── tasks/
│   │   ├── defaults/
│   │   ├── vars/
│   │   ├── templates/
│   │   ├── handlers/
│   │   └── files/
│   │
│   └── common/
│
├── catalog/
│   ├── buckets.yml
│   └── systems.yml
│
├── templates/
│
├── files/
│
├── logs/
│
└── collections/
```

---

# 2. O Papel de Cada Diretório

| Diretório | Função |
|---|---|
| inventory | hosts/ambientes |
| group_vars | variáveis globais |
| host_vars | variáveis específicas |
| playbooks | automações executáveis |
| roles | módulos reutilizáveis |
| catalog | desired state declarativo |
| templates | Jinja2 templates |
| files | arquivos estáticos |
| logs | logs de execução |
| collections | módulos externos |

---

# 3. Configurar ansible.cfg

Crie:

```text
~/ansible-lab/ansible.cfg
```

Conteúdo:

```ini
[defaults]
inventory = ./inventory/hosts.yml
host_key_checking = False
retry_files_enabled = False
stdout_callback = yaml
interpreter_python = /usr/bin/python3
roles_path = ./roles
collections_path = ./collections
log_path = ./logs/ansible.log

[privilege_escalation]
become = False
```

---

# 4. Estruturar Inventory

## inventory/hosts.yml

```yaml
all:

  vars:
    ansible_python_interpreter: /usr/bin/python3

  children:

    local:

      hosts:

        localhost:
          ansible_connection: local

    powerscale:

      hosts:

        powerscale-prod:
          ansible_host: 10.10.10.10
```

---

# 5. Estruturar group_vars

## group_vars/all.yml

Variáveis globais NÃO sensíveis.

```yaml
powerscale_api_port: 8080
powerscale_validate_certs: false

organization: empresa-x
```

---

# 6. Estruturar Vault

## group_vars/vault.yml

Criar:

```bash
ansible-vault create group_vars/vault.yml
```

Conteúdo:

```yaml
powerscale_user: svc_ansible
powerscale_password: senha_super_secreta
```

---

# 7. Configurar .gitignore

Crie:

```text
~/ansible-lab/.gitignore
```

Conteúdo:

```text
*.retry
__pycache__/
logs/
.env
```

IMPORTANTE:

NÃO ignore:

```text
vault.yml
```

O vault deve permanecer versionado.

---

# 8. Inicializar Git

```bash
git init
```

Configurar:

```bash
git config --global user.name "Daniel"
git config --global user.email "seu-email"
```

---

# 9. Instalar Dependências Essenciais

```bash
sudo apt update

sudo apt install -y \
  git \
  jq \
  curl \
  tree \
  python3-pip
```

---

# 10. Estruturar Catálogo Declarativo

## catalog/buckets.yml

```yaml
buckets:

  - name: sap-batch-prod
    owner: team-finance
    retention: 7y
    environment: prod

  - name: edi-online-prod
    owner: integration-team
    retention: 1y
    environment: prod
```

---

# 11. Estruturar Primeiro Playbook Real

## playbooks/powerscale/provision_buckets.yml

```yaml
- name: Provisionar buckets PowerScale
  hosts: localhost
  connection: local

  vars_files:
    - ../../catalog/buckets.yml
    - ../../group_vars/vault.yml

  tasks:

    - name: Mostrar buckets
      debug:
        var: buckets
```

---

# 12. Executar Playbooks

A partir da raiz:

```bash
cd ~/ansible-lab
```

Executar:

```bash
ansible-playbook playbooks/hello.yml
```

Com vault:

```bash
ansible-playbook playbooks/powerscale/provision_buckets.yml --ask-vault-pass
```

---

# 13. Estrutura Correta para Crescimento

## NÃO faça:

```text
50 playbooks gigantes
```

## Faça:

```text
playbooks pequenos
+
roles reutilizáveis
+
catálogo declarativo
```

---

# 14. Quando Criar Roles

Crie roles quando:
- lógica começar a repetir;
- houver múltiplos playbooks;
- precisar modularizar.

Exemplo:

```text
roles/powerscale_bucket/
```

---

# 15. Estrutura Madura de Evolução

## Fase 1

- localhost
- YAML
- REST
- catalog
- vault

## Fase 2

- PowerScale API real
- inventory real
- roles
- tagging
- reconciliation

## Fase 3

- PostgreSQL
- self-service
- CI/CD
- GitOps
- drift detection

---

# 16. Ferramentas que Valem a Pena Depois

| Ferramenta | Momento |
|---|---|
| Molecule | testes |
| ansible-lint | qualidade |
| pre-commit | padronização |
| AWX | orquestração |
| Hashicorp Vault | secrets enterprise |

---

# 17. O Que NÃO Fazer Agora

Evite inicialmente:

- Kubernetes;
- Docker complexo;
- AWX;
- Terraform;
- múltiplas VMs;
- laboratório exageradamente sofisticado.

Seu gargalo agora NÃO é infraestrutura.

É:
- modelagem;
- automação;
- governança;
- IaC mental model.

---

# 18. Objetivo Arquitetural Final

A evolução natural do teu cenário deveria convergir para:

```text
Git
  ↓
Catálogo Declarativo
  ↓
Ansible
  ↓
PowerScale REST API
  ↓
Buckets / Policies / Governance
```

Esse modelo:
- escala;
- é auditável;
- reduz drift;
- melhora governança;
- reduz operação manual.

