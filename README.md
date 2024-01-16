# aws-terraform-ec2

## Objetivo
Este projeto apresenta uma arquitetura AWS para uma aplicação Web, hospedada em uma instância EC2 e com acesso à um cluster multi-az MySQL do Amazon Aurora (alta disponibilidade):

![AWS Architecure - v1](./images/aws-terraform-ec2.png)

## Detalhamento
A arquitetura proposta é formada por:
- Uma VPC com duas zonas de disponibilidade
- Duas subnets públicas, uma em cada zona de disponibilidade
- Duas subnets privadas para recursos de banco de dados, uma em cada zona de disponibilidade
- Um Internet Gateway para acesso à Internet
- Uma instância EC2 em uma subnet pública executando um web server Apache
- Um cluster multi-az MySQL do Amazon Aurora com um réplicas de escrita e leitura, cada uma em uma zona de disponibilidade
- Um secret do Secrets Manager para acesso da instância EC2 ao cluster do Amazon Aurora
- Uma role do IAM associada à instância EC2 para acesso ao cluster do Amazon Aurora

## Módulos Terraform
Para esta arquitetura foi utilizado o Terraform como ferramenta de IaC. Este projeto utiliza três módulos que criam os recursos relacionados entre si:

#Network

| Nome | Descrição | Tipo | Default | Requerido |
| -------------- | -------------- | ------------- | ------------- | ------------- |
| vpc_cidr | CIDR da VPC a ser criada | String | "10.0.0.0/16" |
| az_count | Quantidade de AZs | Number | 2 |

