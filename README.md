## Secure Cloud File Vault | GDPR/HIPAA Compliant Storage

* Features
  
Server-side encryption with AWS KMS

MFA-protected access

Audit logging with CloudTrail

secure-file-vault/
├── infrastructure/       # Terraform/IaC for cloud resources
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
├── backend/              # Python/Node.js backend for API logic
│   ├── app.py
│   ├── requirements.txt
│   └── vault_logic.py
├── frontend/             # Simple React/Flask UI (optional)
│   ├── src/
│   └── package.json
├── scripts/              # Automation scripts
│   ├── deploy.sh
│   └── audit_logs.sh
├── README.md             # Project documentation
└── .gitignore
