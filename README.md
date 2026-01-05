# grc-automation-mirror
This project demonstrates a cloud-native GRC engineering model in AWS using compliant IaC, policy-as-code, continuous control monitoring (Config, Inspector, GuardDuty), and automated remediation. It shows how governance can be codified, enforced, monitored, and evidenced end-to-end.

# Objectives (Phase 1)

The objective of this lab is to showcase an end to end GRC architecture as follows:

* Deploy a simple 3 tier web application using IaC (terraform)
* Implement the following categories of controls to secure the environment:
    - **Step 1 - Cloud Development Layer (Complete)** via OPA (policy as code) - this layer will embed  controls which could impact an entire account or the administration of an account while leaving DevOps Engineers the flexibility to deploy infrastructure and applications as required in both development, test and production environments
    - **Step 2 - Cloud Infratructure Layer (In Progress)** 
        - Detecitve controls via AWS Config, Inspector, GuadDuty and CloudTrail - this layer will embed controls which are detective and alert security teams of controls which contravene policy or standards.
        - Preventive controls via Lambda and SSM Run sheets.
    - **Step 3 - Administrative Layer** 
        - Implement monitoring and alerting capabilities to inform operational security teams.
        - Generate compliance status, remediation and risk metrics to update GRC teams.

# Further details

For further details please refer to \docs\ planning where you will find:

* grc-aws-automation/docs/design/architecture.md
* grc-aws-automation/docs/design/GRC Automation Lab - AWS High Level Architecture.drawio
* grc-aws-automation/docs/design/GRC Automation Lab - Control Lifecycle.drawio
* grc-aws-automation/docs/design/terraform components.md
