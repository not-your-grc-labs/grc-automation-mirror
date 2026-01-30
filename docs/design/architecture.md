# GRC Engineering Lab – Architecture Overview

This document provides a high-level architectural description of the AWS environment used in the GRC Engineering Lab. Its purpose is to explain where services live, how accounts interact, and how the automated control pipeline operates across the organisation.

## 1. AWS organisation structure

The lab uses a four-account AWS Organisation aligned to common enterprise security patterns:

- Management Account
  - Root payer account
  - Home of IAM Identity Center (SSO)

- Security Account
  - Delegated administrator for security services
  - CloudTrail (organization-wide logging) target
  - AWS Config aggregator and rules
  - Security Hub (centralised findings)
  - GuardDuty (threat detection)
  - Inspector (vulnerability metadata)
  - Stores central logs in encrypted S3 buckets (KMS-managed keys)

- Tooling / Automation Account
  - Hosts Lambda functions, SSM Automation documents, or Step Functions for automated remediation
  - Hosts terraform remote state backend and locking (S3 backend + DynamoDB locking recommended)
  - Runs CI/CD agents and bootstrapping automation
  - Athena or Glue can query logs/aggregates for operational tooling
  - Stores Terraform configuration and plans (S3 backend planned)

- Lab (Workload) Account
  - Dedicated environment for deploying and testing workloads
  - Workloads (e.g., EC2 / Elastic Beanstalk / EKS / containers)
  - Infrastructure-as-Code (Terraform)
  - Security controls under evaluation and testing

## 2. Control enforcement architecture

Demonstrates end-to-end automated control enforcement through three layers:

2.1 Preventive Controls (Before Deployment)
Purpose: Stop insecure configurations before they are deployed.

- Evaluated locally or in CI before infrastructure reaches AWS.
- Tools: OPA / Conftest validating Terraform
- Use Organisation SCPs as guardrails


2.2 Detective Controls (After Deployment)
Purpose: Detect deviations in real resources and generate findings for remediation and reporting.

- Active monitoring of deployed resources.
- Services: AWS Config (rules), Security Hub (aggregated findings: CIS/AWS Foundational), GuardDuty, Inspector.

2.3 Corrective Controls (Remediation)
Purpose: Close the loop by restoring compliance automatically where safe; escalate when necessary.

- Automated responses triggered by non-compliant Config or Security Hub findings.
- Mechanisms: SSM Automation documents, Lambda responders, Step Functions orchestrating remediations, and manual runbooks for high-risk decisions.
- Design constraints: remediations must be idempotent, safe by default (e.g., dry-run, approvals), and auditable.
  
## 3. Data flow & reporting

Logging and configuration data flow:
- Workload and security data generated in Lab Account forwarded via AWS integrations to the Security Account.
- Central storage:
  - CloudTrail S3 bucket (organization trail, multi-region recommended)
  - Config aggregator (Security Account)
  - Security Hub master account and findings aggregation
- Management/Tooling Account queries data via:
  - S3 Select / Glue tables
  - Athena (query across logs and aggregated datasets)
- Output:
  - Dashboards showing compliance posture, trend analysis, outstanding remediations, and control effectiveness metrics.

## 4. Identity & access pattern

- IAM Identity Center (SSO) in the Management Account controls interactive access.
- Users (operators, infra engineers) get permission sets granting roles in target accounts.
- Terraform user obtains SSO permission set and assumes a TerraformDeployment role in the Lab Account for deployments.
- Cross-account trust: the Lab Account trusts the specific SSO role (principle of least privilege).
- Separation of duties:
  - Identity governance (Management)
  - Security monitoring and logging (Security)
  - Workload deployment and experimentation (Lab)
  - Tooling/automation and state backends (Tooling/Automation)

## 5. Purpose of this architecture

This structure supports the goals of the GRC Engineering Lab:
- Clear separation of duties across accounts
- Demonstration of modern automated controls
- End-to-end governance pipeline: prevent → detect → remediate → report
- Practical example of cloud-native GRC engineering principles
- Foundation for scaling controls or adding new domains (IAM, network, encryption, vulnerability, configuration)

## 6. Diagrams & references
(Embed or link to diagrams showing accounts and control flows)
- /docs/design/GRC Automation Lab - AWS High Level Architecture.drawio
- /docs/design/GRC Automation Lab - Control Lifecycle.drawio
