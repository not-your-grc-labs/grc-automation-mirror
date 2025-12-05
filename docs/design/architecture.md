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

Notes:
- Consider explicit well-known role names and IAM policies for cross-account actions (e.g., TerraformDeployment, RemediationRunner).
- Use customer-managed KMS keys with carefully scoped key policies to allow cross-account access where needed.

## 2. Control enforcement architecture

Demonstrates end-to-end automated control enforcement through three layers:

2.1 Preventive Controls (Before Deployment)
Purpose: Stop insecure configurations before they are deployed.

- Evaluated locally or in CI before infrastructure reaches AWS.
- Tools: OPA / Conftest validating Terraform (S3 encryption, no public SGs, least privilege); CI checks; static scans.
- Use Organisation SCPs as guardrails


2.2 Detective Controls (After Deployment)
Purpose: Detect deviations in real resources and generate findings for remediation and reporting.

- Active monitoring of deployed resources.
- Services: AWS Config (rules), Security Hub (aggregated findings: CIS/AWS Foundational), GuardDuty, Inspector.

2.3 Corrective Controls (Remediation)
Purpose: Close the loop by restoring compliance automatically where safe; escalate to humans for judgement when necessary.

- Automated responses triggered by non-compliant Config or Security Hub findings.
- Mechanisms: SSM Automation documents, Lambda responders, Step Functions orchestrating remediations, and manual runbooks for high-risk decisions.
- Design constraints: remediations must be idempotent, safe by default (e.g., dry-run, approvals), and auditable.
  
Example control lifecycle:
CI OPA/Conftest → Terraform apply in Lab → AWS Config rule fails → Security Hub finding → Event triggers SSM/Lambda → automated remediation attempts → ticket/alert created if remediation fails.

## 3. Data flow & reporting

Logging and configuration data flow:
- Workload and security data generated in Lab Account are forwarded via AWS integrations to the Security Account.
- Central storage:
  - CloudTrail S3 bucket (organization trail, multi-region recommended)
  - Config aggregator (Security Account)
  - Security Hub master account and findings aggregation
- Management/Tooling Account queries data via:
  - S3 Select / Glue tables
  - Athena (query across logs and aggregated datasets)
- Output:
  - Dashboards showing compliance posture, trend analysis, outstanding remediations, and control effectiveness metrics.

Operational notes:
- Define retention and lifecycle policies for log buckets.
- Consider S3 replication and versioning for durability and forensic needs.
- Ensure bucket policies and KMS key policies allow secure cross-account reads for aggregation.

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

Security notes:
- Use short-lived credentials (SSO sessions).
- Limit role boundaries and scope permissions narrowly.
- Document role names, ARNs, and trust policies.

## 5. Purpose of this architecture

This structure supports the goals of the GRC Engineering Lab:
- Clear separation of duties across accounts
- Demonstration of modern automated controls
- End-to-end governance pipeline: prevent → detect → remediate → report
- Practical example of cloud-native GRC engineering principles
- Foundation for scaling controls or adding new domains (IAM, network, encryption, vulnerability, configuration)

## 6. Future enhancements (Phase 2)
Potential extensions:
- Cross-account evidence generation pipelines and immutable evidence stores
- Real-time dashboards (QuickSight / custom UI)
- Service Control Policy simulations and testing harness
- More complex OPA policy bundles and a policy registry
- Automated Terraform CI/CD controls and policy-as-code gates
- Additional workload types (EKS, Lambda, containers)
- Incident playbooks and automated ticket creation

## 7. Operational, compliance & risk items (recommended additions)
- Retention, lifecycle, and cost constraints for logs and metrics
- Test plans and CI harness for policy changes (SCPs / OPA)
- Runbook owners and SLAs for remediation and alert handling
- Threat model and risk register (brief)
- Audit logging and evidence retention requirements (for compliance)

## 8. Diagrams & references
(Embed or link to diagrams showing accounts and control flows)
- /docs/diagrams/01-aws-org-architecture.drawio
- /docs/diagrams/02-control-lifecycle.drawio

## Glossary & assumptions
- Regions: assume multi-region but specify which region(s) are in-scope
- KMS: customer-managed keys unless otherwise noted
- Terraform state: stored in S3 with DynamoDB locking

## Summary
This architecture is a concise, low-cost baseline for building and testing automated controls, IaC governance, and continuous compliance in a multi-account AWS environment. It should be augmented with specific implementation details (KMS keys, role ARNs, S3 lifecycle policies, diagrams, and runbooks) before being used as an operational runbook.
