# Ansible Lab

Este repositório é um laboratório de Ansible com exemplos de playbooks, inventário e variáveis para automação local e PowerScale.

## Estrutura do projeto

- `ansible.cfg`
  - Configuração do Ansible para este projeto.
  - Define `inventory = ./inventory/hosts.yml` e caminhos para `roles` e `collections`.
- `inventory/`
  - `hosts.yml`: inventário principal com grupos `local` e `powerscale`.
- `group_vars/`
  - `all.yml`: variáveis globais.
  - `vault.yml`: variáveis secretas criptografadas com `ansible-vault`.
- `playbooks/`
  - Playbooks de exemplo e arquivos de variáveis usados por playbooks.
- `catalog/`
  - Dados declarativos como `buckets.yml` e `systems.yml`.
- `logs/`
  - Local de logs do Ansible, excluído do controle de versão.
- `roles/`
  - Diretório de roles. Atualmente contém apenas `.gitkeep`.
- `collections/`
  - Diretório reservado para coleções Ansible locais.

## Requisitos

- Ansible instalado (versão compatível com o formato usado nos playbooks).
- Python 3 disponível em `/usr/bin/python3`.
- Acesso de rede para executar playbooks que usam `uri` e chamadas HTTP.

## Inventário

O inventário padrão usado por `ansible.cfg` é:

```yaml
inventory/hosts.yml
```

### Grupos definidos

- `local`
  - `localhost` com `ansible_connection: local`
- `powerscale`
  - `powerscale-prod` com `ansible_host: 10.10.10.10`

## Variáveis

- `group_vars/all.yml`
  - Variáveis globais não sensíveis.
- `group_vars/vault.yml`
  - Variáveis secretas protegidas com `ansible-vault`.
  - Execute as operações com `ansible-playbook --ask-vault-pass` ou usando um arquivo de senha seguro.

## Playbooks principais

### `playbooks/hello.yml`
Teste de execução básica do Ansible.

Comando:

```bash
cd /home/daniel-bighelini/ansible-lab
ansible-playbook playbooks/hello.yml
```

### `playbooks/reconcile.yml`
Reconciliação de buckets usando arquivos de variáveis locais:

- `playbooks/buckets.yml`
- `playbooks/existing_buckets.yml`

```bash
ansible-playbook playbooks/reconcile.yml
```

### `playbooks/powerscale/provision_buckets.yml`
Playbook para provisionar buckets PowerScale usando:

- `catalog/buckets.yml`
- `group_vars/vault.yml`

```bash
ansible-playbook playbooks/powerscale/provision_buckets.yml --ask-vault-pass
```

### `playbooks/api_test.yml`
Teste de chamada HTTP a API pública do GitHub.

```bash
ansible-playbook playbooks/api_test.yml
```

## Observações importantes

- `playbooks/buckets.yml` e `playbooks/existing_buckets.yml` são atualmente arquivos de dados/variáveis, não playbooks.
  - Recomenda-se mover esses arquivos para um diretório como `vars/`, `data/` ou `catalog/` para deixar a finalidade mais clara.
- `roles/` existe, mas ainda não contém roles utilitárias reais.
  - Para uma estrutura mais madura, crie roles em `roles/<nome_da_role>/` e use `roles:` nos playbooks.
- `collections/` também está definido, mas sem conteúdo específico documentado.
  - Se usar coleções, adicione `requirements.yml` e documente a instalação.

## Dependências

As dependências de collections podem ser instaladas com:

```bash
ansible-galaxy collection install -r requirements.yml
```

Se você adicionar roles externas, use também:

```bash
ansible-galaxy install -r requirements.yml
```

## Boas práticas recomendadas

- Execute playbooks a partir da raiz do repositório para manter paths relativos corretos.
- Use `ansible-vault` para segredos e mantenha `group_vars/vault.yml` versionado apenas criptografado.
- Separe inventários por ambiente se precisar de `prod`, `hml`, `dev`.
  - Exemplo: `inventory/prod/hosts.yml`, `inventory/dev/hosts.yml`.
- Adicione `host_vars/` quando tiver variáveis que dependam de host específico.
- Use `requirements.yml` para coleções e dependências de roles.

## Próximos passos sugeridos

1. Adicionar um `README.md` mais detalhado para cada playbook importante.
2. Criar roles reutilizáveis em `roles/`.
3. Organizar arquivos de dados em um diretório dedicado.
4. Documentar a execução de `ansible-vault` e o processo de criação de secrets.
5. Incluir um `Makefile` ou scripts de execução para facilitar a vida do usuário.
