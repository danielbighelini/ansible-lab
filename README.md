# Ansible Lab

Este repositório é um laboratório de Ansible com exemplos de playbooks, inventários, variáveis, roles e coleções para automação local e PowerScale. O projeto está estruturado para simular um ambiente enterprise, com suporte a múltiplos ambientes (dev, hml, prod) e integração com sistemas PowerScale.

## Pré-requisitos

- Ansible instalado (versão 2.10 ou superior recomendada)
- Python 3 disponível em `/usr/bin/python3`
- Acesso de rede para executar playbooks que fazem chamadas HTTP
- Para desenvolvimento: WSL2 com Ubuntu/Debian

## Instalação e Configuração

1. Clone o repositório:
   ```bash
   git clone <url-do-repositorio>
   cd ansible-lab
   ```

2. Instale as dependências (coleções Ansible):
   ```bash
   make install
   ```
   Ou manualmente:
   ```bash
   ansible-galaxy collection install -r collections/requirements.yml
   ```

3. Verifique a configuração:
   ```bash
   make check
   ```

## Estrutura do Projeto

- `ansible.cfg`: Configuração do Ansible (inventário padrão: `./inventories/dev/hosts.yml`, caminhos para roles e collections)
- `Makefile`: Comandos para instalação, linting e verificação
- `requirements.yml`: Dependências de coleções Ansible
- `docs/`: Documentação adicional, incluindo estrutura recomendada e setup WSL2
- `files/`: Arquivos estáticos para uso em playbooks
- `templates/`: Templates Jinja2
- `vars/`: Arquivos de variáveis declarativas
- `catalog/`: Dados declarativos (buckets, systems)
- `inventories/`: Inventários para diferentes ambientes
  - `dev/`: Ambiente de desenvolvimento
  - `hml/`: Ambiente de homologação
  - `prod/`: Ambiente de produção
- `group_vars/`: Variáveis globais por grupo
- `host_vars/`: Variáveis específicas por host
- `playbooks/`: Playbooks de exemplo e automação
- `roles/`: Roles Ansible customizadas
  - `powerscale_bucket/`: Role para gerenciamento de buckets PowerScale
- `collections/`: Coleções Ansible instaladas localmente
  - `ansible.posix`: Coleção para módulos POSIX
  - `community.general`: Coleção geral da comunidade
- `logs/`: Diretório para logs (excluído do Git)

## Inventários

O projeto suporta múltiplos inventários para diferentes ambientes. O inventário padrão é `inventories/dev/hosts.yml`.

### Grupos Comuns

- `local`: Hosts locais (ex: localhost)
- `powerscale`: Hosts PowerScale (ex: powerscale-prod)

Para usar um inventário específico:
```bash
ansible-playbook -i inventories/prod/hosts.yml playbooks/hello.yml
```

## Variáveis

- `group_vars/all.yml`: Variáveis globais não sensíveis
- `group_vars/vault.yml`: Variáveis secretas criptografadas com `ansible-vault`
- `vars/buckets.yml` e `vars/existing_buckets.yml`: Dados declarativos para buckets

Para playbooks com vault:
```bash
ansible-playbook --ask-vault-pass playbooks/seu-playbook.yml
```

## Playbooks

### Playbooks Principais

- `hello.yml`: Teste básico de execução do Ansible
- `reconcile.yml`: Reconciliação de buckets usando variáveis locais
- `api_test.yml`: Teste de chamada HTTP para API do GitHub
- `api_field.yml`: Exemplo de uso de campos de API
- `condition.yml`: Exemplos de condições no Ansible
- `directory.yml`: Gerenciamento de diretórios
- `dynamic_directory.yml`: Criação dinâmica de diretórios
- `dynamic_reconcile.yml`: Reconciliação dinâmica
- `multiple_directories.yml`: Gerenciamento de múltiplos diretórios
- `provision_fake_buckets.yml`: Provisionamento de buckets fictícios
- `variables.yml`: Exemplos de uso de variáveis

### Playbooks PowerScale

- `powerscale/provision_buckets.yml`: Provisionamento de buckets em sistemas PowerScale

### Utilitários

- `powerscale/utilities/`: Playbooks utilitários para PowerScale

## Roles

- `powerscale_bucket/`: Role para provisionamento e gerenciamento de buckets PowerScale
  - `tasks/main.yml`: Tarefas principais
  - `defaults/main.yml`: Valores padrão
  - `vars/main.yml`: Variáveis da role
  - `templates/`: Templates para configuração
  - `handlers/main.yml`: Handlers para serviços
  - `files/`: Arquivos estáticos

## Uso

### Executar um Playbook

```bash
ansible-playbook playbooks/hello.yml
```

### Com Inventário Específico

```bash
ansible-playbook -i inventories/prod/hosts.yml playbooks/powerscale/provision_buckets.yml
```

### Com Vault

```bash
ansible-playbook --ask-vault-pass playbooks/reconcile.yml
```

### Verificação de Sintaxe

```bash
make syntax
```

### Linting

```bash
make lint
```

### Validação YAML

```bash
make yaml
```

## Makefile

Comandos disponíveis:
- `make install`: Instala coleções
- `make lint`: Executa ansible-lint
- `make yaml`: Executa yamllint
- `make syntax`: Verifica sintaxe dos playbooks
- `make check`: Executa todas as verificações

## Observações

- Os arquivos em `vars/` são dados declarativos, não playbooks
- Roles estão organizadas seguindo as melhores práticas do Ansible
- Coleções são instaladas localmente para isolamento
- O projeto está preparado para escalar para ambientes enterprise
- Consulte `docs/estrutura_ansible_enterprise_lab.md` para detalhes sobre a estrutura recomendada

## Contribuição

1. Faça fork do projeto
2. Crie uma branch para sua feature
3. Execute `make check` antes de commitar
4. Abra um Pull Request

## Licença

Este projeto é distribuído sob a licença MIT.

## Dependências

As dependências de collections podem ser instaladas com:

```bash
ansible-galaxy collection install -r collections/requirements.yml
```

Se você adicionar roles externas, crie um arquivo `roles/requirements.yml` e use também:

```bash
ansible-galaxy install -r roles/requirements.yml
```

## Boas práticas recomendadas

- Execute playbooks a partir da raiz do repositório para manter paths relativos corretos.
- Use `ansible-vault` para segredos e mantenha `group_vars/vault.yml` versionado apenas criptografado.
- Separe inventários por ambiente se precisar de `prod`, `hml`, `dev`.
  - Exemplo: `inventory/prod/hosts.yml`, `inventory/dev/hosts.yml`.
- Adicione `host_vars/` quando tiver variáveis que dependam de host específico.
- Use `collections/requirements.yml` para coleções e `roles/requirements.yml` para dependências de roles.

## Próximos passos sugeridos

1. Adicionar um `README.md` mais detalhado para cada playbook importante.
2. Criar roles reutilizáveis em `roles/`.
3. Organizar arquivos de dados em um diretório dedicado.
4. Documentar a execução de `ansible-vault` e o processo de criação de secrets.
