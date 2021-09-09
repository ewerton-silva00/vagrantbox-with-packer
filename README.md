# Construir uma Vagrant Box utilizando Packer.

## Motivação

Há tempos utilizo o `Vagrant` + `VirtualBox` para validar alguns projetos localmente, no meu notebook. Na maior parte dos casos está relacionado ao uso do Ansible, para validar alguma ideia e afins. Por onde passei sempre precisei manter ambientes On-Premises e muito monolito.

Este projeto apenas recupera uma Box minha, chamada [`ewerton_silva00/centos-7-x86_64-minimal-2003`](https://app.vagrantup.com/ewerton_silva00/boxes/centos-7-x86_64-minimal-2003), atualiza para a versão mais recente do CentOS 7 e disponibiliza novamente no Vagrant Cloud.

Aqui, o processo é relativamente simples, mas ajuda a entender o básico do uso do `Packer` juntamente com o `Vagrant Cloud`.

## Pré-requisitos

**[`Packer`](https://www.packer.io/):** versão utilizada 1.7.4  
**[`Vagrant`](https://www.vagrantup.com/):** versão utilizada 2.2.18  
**[`VirtualBox`](https://www.virtualbox.org/):** versão utilizada 6.1.26  

**Importante**: Possuir cadastro no [`Vagrant Cloud`](https://app.vagrantup.com/), pois a Box gerada será armazenada por padrão neste serviço.

## Como utilizar este projeto

Gerar um `token` no `Vagrant Cloud` e exportar como variável de ambiente.
```bash
export VAGRANT_CLOUD_TOKEN="*******************************************"
```

Verificar a sintaxe do código.
```bash
packer validate -var-file vagrant.pkrvars.hcl vagrant.pkr.hcl
```

Criar a Box e fazer upload para o `Vagrant Cloud`.
```bash
packer build -timestamp-ui -force -var-file vagrant.pkrvars.hcl vagrant.pkr.hcl
```

## Validar Box

Este repositório conta com um `Vagrantfile` na qual informo o nome da BOX disponível no `Vagrant Cloud` e executo o comando `vagrant up` para inicializar a BOX localmente e fazer as validações necessárias.

No meu caso ficou da seguinte forma:
```ruby
cfg.vm.box = "ewerton_silva00/centos-7-x86_64-minimal-2009"
```

Além disso, gosto de fazer uso de dois plugins:
```bash
vagrant plugin install vagrant-vbguest
vagrant plugin install vagrant-hosts
```
