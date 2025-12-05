# GRC Engineering Lab – Architecture Overview
This document provides a high-level architectural description of the AWS environment used in the GRC Engineering Lab.
Its purpose is to explain where services live, how accounts interact, and how the automated control pipeline operates across the organisation.

## 1. AWS Organisation Structure
The lab uses a four-account AWS Organisation aligned to common enterprise security patterns:

Management Account
    - Root payer account
    - Home of IAM Identity Center (SSO)
    - Stores Terraform configuration (S3 backend planned)
    - Runs Athena for cross-account reporting and analytics

Security Account
    - Delegated administrator for security services:
    - CloudTrail (organization-wide logging)
    - AWS Config Aggregator
    - Security Hub (centralised findings)
    - GuardDuty (threat detection)
    - Inspector (vulnerability metadata)
    - Stores central logs in encrypted S3 buckets

Management Account
    - Hosts Lambda functions or SSM Automation runbooks for automated remediation
    - Hosts terraform state file
    - Athena used to generate metrics and reports from data in Security Account

Lab (Workload) Account
Dedicated environment for deploying and testing:
    - Workloads (e.g., EC2 / Beanstalk application)
    - Infrastructure-as-Code (Terraform)
    - Security controls under evaluation

## 2. Control Enforcement Architecture

This lab demonstrates end-to-end automated control enforcement through three layers:

2.1 Preventive Controls (Before Deployment)

Evaluated locally or in CI before infrastructure reaches AWS.

Tools:
OPA / Conftest – validates Terraform for compliance (e.g., S3 encryption, no public SGs)
SCPs – organisation-wide guardrails preventing prohibited actions (e.g., deny creating IAM users)

Purpose:
Stop insecure configurations before they are deployed.

2.2 Detective Controls (After Deployment)

Active monitoring of deployed resources.

Services:
AWS Config – evaluates configuration rules (encryption, IAM key rotation, network restrictions)
Security Hub – aggregates findings from CIS/AWS Foundational Best Practices
GuardDuty – behaviour and threat detection
Inspector – vulnerability and patching metadata for EC2 / Lambda / ECR

Purpose:
Detect deviations in real resources and generate compliance findings.

2.3 Corrective Controls (Remediation)

Automated responses triggered by non-compliant Config or Security Hub findings.

Potential mechanisms:
SSM Automation documents (e.g., remediate public SGs)
Lambda responders (e.g., enable encryption)
Manual runbooks for findings that require human judgement

Purpose:
Close the loop by restoring compliance without manual intervention where possible.

## 3. Data Flow & Reporting

Logging and Configuration Data Flow

Workload and security data generated in Lab Account is forwarded via AWS native integrations to Security Account

Stored in:
CloudTrail S3 bucket
Config aggregator
Security Hub master account


Management Account queries them via:
S3 select / Glue tables
Athena

Management will develop combined dashboard/report provides:
Compliance posture
Trend analysis
Outstanding remediations
Control effectiveness metrics

## 4. Identity & Access Pattern

IAM Identity Center in the Management Account
Controls all interactive access
Terraform user logs in via an SSO permission set
CLI session assumes TerraformDeployment role in the Lab Account
Trust Relationship
Lab Account trusts the specific SSO role in the Management Account
Ensures least-privilege delegation for Terraform deployments
Enforces separation of duties between:
Identity governance (mgmt)
Security monitoring (security)
Workload deployment (lab)

## 5. Purpose of This Architecture

This structure supports the goals of the GRC Engineering Lab:

Clear separation of duties across accounts
Demonstration of modern automated controls
End-to-end governance pipeline: prevent → detect → remediate → report
Practical example of cloud-native GRC engineering principles
Foundation for scaling controls or adding new domains (IAM, network, encryption, vulnerability, configuration)

## 6. Future Enhancements (Phase 2)
The architecture is intentionally minimal and low-cost but can be extended to include:
Cross-account evidence generation pipelines
Real-time dashboards (QuickSight / custom UI)
Service Control Policy simulations
More complex OPA policy bundles
Automated Terraform CI/CD controls
Additional workload types (EKS, Lambda, containers)

## 7. Diagram References
(You can embed your Draw.io diagrams here)
Example:
/docs/diagrams/01-aws-org-architecture.drawio
/docs/diagrams/02-control-lifecycle.drawio

## Summary
This architecture establishes a clean, well-structured, enterprise-aligned environment for building, testing, and demonstrating:
Automated controls
IaC governance
Policy-as-Code
Continuous compliance
Multi-account AWS security design
It forms the foundation for all subsequent phases of the lab.