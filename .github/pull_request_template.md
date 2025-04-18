# [Feature/Fix/Refactor]: Short Description

## Description
Provide a clear summary of the changes in this PR.  
Include context such as:
- What problem does this Terraform module PR solve?
- Why is this change necessary?
- What is the intended outcome?

## Related Issues
Taiga #[Issue Number] (if applicable)  


---

## Changes Made
- [ ] **New Module:** Describe the new module or submodule added
- [ ] **New Resource:** Describe new AWS/Azure/GCP/etc. resources
- [ ] **Input/Output Variables:** List added/modified variables
- [ ] **Bug Fix:** Explain what was broken in the module and how it was fixed
- [ ] **Refactor:** Mention any code/structure improvements
- [ ] **Documentation:** Updates to `README.md`, examples, or comments

---

## Testing Steps
1. **Terraform Init/Plan/Apply:** Run `terraform init`, `plan`, and `apply` with relevant inputs.
2. **Validation:** Run `terraform validate` and/or `tflint`.
3. **Test Cases:** Use Terratest or other frameworks (if available).
4. **Expected Outcome:** Describe what should happen after applying the module.

---

## Terraform plan output
- [ ] I have attache `terraform plan` output as a file on this Pull Request

---
## Example Usage (if applicable)
Paste a code snippet showing how to use the module:

```hcl
module "example" {
  source = "./modules/example"
  name   = "demo"
  ...
}

## Reviewers
Request specific team members for review: `@WEBFORX/ADMIN`, `@WEBFORX/DEVOPSEASYLEARNING`