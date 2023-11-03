# Project Name (Sample)

## About

Sample AKS deployment and installation of [Actions Runner Controller](https://docs.github.com/en/actions/hosting-your-own-runners/managing-self-hosted-runners-with-actions-runner-controller/about-actions-runner-controller) using Bicep templates and `helmfile`. This demonstrates how to use automation to manage and deploy the environment from source code stored in a GitHub repository. Merges to `main` will automatically start the deployment process and update the resources.

This sample does not show how to integrate AKS with Key Vault or demonstrate how to use that to integrate a secret. The cluster will require a secret called `runner-secret` (or a modification to the helmfile.yaml to provide the secret).

## GitHub App

This sample assumes a [GitHub App has been created for ARC](https://docs.github.com/en/actions/hosting-your-own-runners/managing-self-hosted-runners-with-actions-runner-controller/authenticating-to-the-github-api#authenticating-arc-with-a-github-app) and will require the App details to be configured as a secret in GitHub.

## Azure Configuration

An application meeds to be created and registered in Azure Active Directory.

1. Open Microsoft Entra ID (formerly Azure Active Directory) and click the **App Registrations** blade.
2. Press **New registration**.
   - Specify any name. This name will also be the "user" that you will assign roles.
   - Select **Accounts in this organizational directory only (Single tenant)**
   - Redirect URI should be left blank
3. In the Application blade, choose **Certificates & Secrets**
4. Select **Federated Credentials** and choose **Add Credential**
   - For **Federated credential scenario**, choose **GitHub Actions deploying Azure resources** 
   - Enter the **Organization** and **Repository** associated with the credential.
   - Specify an **Entity Type** based on the job deploying the resource. If it's a 
     tag-triggered Action, select Tag. If it's branch triggered, select Branch. 
     For pull requests, select Pull Request. If the credential is being used by a
     job deploying to an Environment, you should use Environment. For this sample,
     you'll choose `Environment` and specify the value as `prod` to match the
     GitHub workflow.
   - Provide a name for this scenario and optionally provide a description.
   - Click **Add**
5. In the Overview blade, capture the **Application (Client) ID** and the **Directory (Tenant) ID**
6. From the appropriate Azure Resource Group (or the subscription), capture the **Subscription ID**.
7. In Azure, configure resources with appropriate RBAC permissions using the name of the application as the identity. For this sample, assign `Contributor` rights to the subscription. 
8. In GitHub, open your personal Settings, then open **Developer Settings** and select [**Personal access tokens**(https://github.com/settings/tokens). Create a token with the `repo` and `read:org`
9. In the GitHub repository, configure the following secrets with the values collected in steps 5,6 and 8:

   | Secret                | Value                                                |
   | --------------------- | ---------------------------------------------------- |
   | AZURE_CLIENT_ID       | Application (Client) Id.                             |
   | AZURE_TENANT_ID       | Azure AD directory (tenant) identifier.              |
   | AZURE_SUBSCRIPTION_ID | The Azure subscription containing the resources.     |
10. In the GitHub repository, configure the following variables:
  
   | Variable                | Value                                                |
   | ----------------------- | ---------------------------------------------------- |
   | RESOURCE_GROUP          | Name for the AKS resource group                      |
   | RESOURCE_GROUP_LOCATION | Region location for the group, such as `eastus`      |


## Dev Containers
This repository supports [GitHub Codespaces](https://github.com/features/codespaces) and VS Code development containers. This creates a standalone environment for viewing and editing the files.

To connect to Azure locally (or in Codespaces) for testing the scripts, you'll need to run these commands and follow the prompts. You will need to provide an appropriate value for `<subscriptionID>`:

```bash
az login --use-device-code
az account set --subscription <subscriptionID>
```

## License 

This project is licensed under the terms of the MIT open source license. Please refer to [MIT](./LICENSE) for the full terms.

## Maintainers 

See [CODEOWNERS](CODEOWNERS).

## Support

This project is a sample and is not actively supported or maintained (see [SUPPORT](SUPPORT.md)). It is not supported or officially endorsed by GitHub.

