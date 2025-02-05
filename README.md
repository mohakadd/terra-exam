# Déploiement de WordPress sur AWS avec Terraform

Ce projet permet de déployer un site WordPress sur AWS en utilisant Terraform. L'installation est basique, sans nom de domaine et avec un certificat HTTPS autosigné.

## Prérequis

Assurez-vous que les outils suivants sont installés et configurés sur votre machine :

- [Terraform](https://www.terraform.io/downloads)
- [AWS CLI](https://aws.amazon.com/cli/)
- Un compte AWS avec les permissions nécessaires

## Étapes de déploiement

### 1. Configuration des variables d'environnement

Exportez vos identifiants AWS et le mot de passe de la base de données RDS en variables d'environnement :

```sh
export AWS_ACCESS_KEY_ID=XXXXXXXXXXXXXX
export AWS_SECRET_ACCESS_KEY=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
export TF_VAR_db_password="MotDePasseAuMoins8Car"
```

### 2. Initialisation de Terraform

Exécutez la commande suivante pour initialiser Terraform, télécharger les providers et configurer le backend :

```sh
terraform init
```

### 3. Création de l'infrastructure

Lancez la commande suivante pour appliquer le plan et déployer l'infrastructure sur AWS :

```sh
terraform apply --auto-approve
```

### 5. Suppression de l'infrastructure

Si vous souhaitez supprimer l'infrastructure après vos tests, utilisez la commande suivante :

```sh
terraform destroy --auto-approve
```

---

## Structure du projet

```
│── modules/
│   ├── ebs/
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── ec2/
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── networking/
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   └── rds/
│       ├── main.tf
│       ├── outputs.tf
│       └── variables.tf
│── README.md
│── install_wordpress.sh
│── main.tf
│── variables.tf
```

## Notes

- L'instance EC2 est configurée avec un certificat HTTPS autosigné.
- Aucune gestion de domaine n'est prévue dans ce projet.
- Assurez-vous d'utiliser un mot de passe sécurisé pour votre base de données RDS.
- Ce projet est destiné aux tests et démonstrations et ne doit pas être utilisé en production sans modifications adaptées.

---