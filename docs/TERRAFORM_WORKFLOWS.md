**Terraform workflows — Fixing "Insufficient rights to generate a plan"**

Problem
- Workflows use a Terraform Cloud backend (organization `azureai_infra`, workspace `vllm-serving-aks`).
- `terraform plan` fails with: "Insufficient rights to generate a plan" — this means the Terraform Cloud API token in `TERRAFORM_TOKEN` does not have plan permissions on that workspace.

Quick fix (recommended)
1. In Terraform Cloud, create or use a user who has access to `azureai_infra` and the `vllm-serving-aks` workspace.
2. Create a user API token: Terraform Cloud → User settings (top-right avatar) → Tokens → Create an API token.
3. In GitHub repo Settings → Secrets → Actions, add a secret named `TERRAFORM_TOKEN` with that token value.
4. Re-run the `Terraform Plan` workflow (Actions → Terraform Plan → Run workflow).

How to verify the token (locally or from CI)
- Quick curl test — replace $TOKEN with the token value (do NOT paste tokens in public logs):

```bash
TOKEN="<your-token-here>"
curl -i -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/vnd.api+json" \
  https://app.terraform.io/api/v2/organizations/azureai_infra/workspaces/vllm-serving-aks
```

- Expected: HTTP/1.1 200 OK. If `403` or another status is returned, the token's user lacks access or the workspace name/org is incorrect.

Granting workspace permissions
- If the token belongs to a user that doesn't have enough privileges, give that user at least the "Plan" permission for the workspace:
  - In Terraform Cloud: Organization → Settings → Users & Teams (or the workspace Settings → Access), add the user and give them a role that includes plan rights (e.g., "Contributor" or specific workspace permissions depending on your org policy).

Alternative: workspace-specific token
- You can create a workspace API token under the workspace: Settings → API & Tokens → Create workspace token. This token is scoped to that workspace and can be used as `TERRAFORM_TOKEN`.

Notes about CI
- The GitHub Actions workflows already include a pre-check that calls the Terraform Cloud API and prints the API response if the token cannot access the workspace — use that output to confirm whether the problem is permission-related or a typo in `TF_ORG` / `TF_WORKSPACE`.
- After updating the secret, re-run the workflow manually (`Run workflow`).

If you want, I can add steps to automatically create a workspace token via the API (requires an org admin token) or add a short guide to use workspace-specific tokens.
