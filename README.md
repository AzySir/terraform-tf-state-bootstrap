# Terraform AWS Bootstrap

## Makefile

This Makefile simplifies the execution of Terraform commands for managing infrastructure for the application `${APP}` under the organization `${ORG}`. It provides a set of targets to format, init, plan, apply, destroy, and interact with Terraform configurations.

## Prerequisites

- **Terraform**: Ensure Terraform is installed (`terraform` command available in your PATH).
- **AWS CLI**: AWS credentials must be configured (either via environment variables or AWS CLI profiles).
- **Make**: This Makefile assumes you have `make` installed.
- Environment variables:
  - `AWS_ACCESS_KEY_ID`: AWS access key.
  - `AWS_SECRET_ACCESS_KEY`: AWS secret key.
  - `ENV`: Environment name (e.g., `dev`, `prod`).
  - `REGION`: AWS region (e.g., `eu-west-2`, `us-east-1`).

## Makefile Variables

- `APP`: Application name - Set your App name here
- `ORG`: Organization name - Set your Organisation name here

## Targets

The Makefile provides the following targets:

### `fmt`
Formats Terraform configuration files recursively.

```bash
make fmt
```

### `clean`
Removes Terraform cache and state files (e.g., `.terraform*` directories).

```bash
make clean
```

### `init`
Initializes the Terraform working directory, setting up the backend configuration for state storage in an S3 bucket.

- Requires: `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `ENV`, `REGION`.
- Backend: Configures state storage in `s3://<ORG>-<APP>-<REGION>-tf-state/<APP>/<ENV>/<REGION>/terraform.tfstate`.

```bash
make init ENV=dev REGION=eu-west-2
```

Optional: Pass additional arguments with `ARGS`.

```bash
make init ENV=dev REGION=eu-west-2 ARGS="-reconfigure"
```

### `plan`
Generates an execution plan for the Terraform configuration.

- Requires: `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `ENV`, `REGION`.
- Uses variable files: `<ENV>.tfvars` and `<ENV>_<REGION>.tfvars`.

```bash
make plan ENV=dev REGION=eu-west-2
```

Optional: Pass additional arguments with `ARGS`.

```bash
make plan ENV=dev REGION=eu-west-2 ARGS="-out=tfplan"
```

### `apply`
Applies the Terraform configuration to create or update resources.

- Requires: `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `ENV`, `REGION`.
- Uses variable files: `<ENV>.tfvars` and `<ENV>_<REGION>.tfvars`.

```bash
make apply ENV=dev REGION=eu-west-2
```

Optional: Pass additional arguments with `ARGS`.

```bash
make apply ENV=dev REGION=eu-west-2 ARGS="-auto-approve"
```

### `destroy`
Destroys all resources managed by the Terraform configuration.

- Requires: `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `ENV`, `REGION`.
- Uses variable files: `<ENV>.tfvars` and `<ENV>_<REGION>.tfvars`.

```bash
make destroy ENV=dev REGION=eu-west-2
```

Optional: Pass additional arguments with `ARGS`.

```bash
make destroy ENV=dev REGION=eu-west-2 ARGS="-auto-approve"
```

### `console`
Opens an interactive Terraform console for testing expressions and inspecting state.

- Requires: `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `ENV`.
- Uses variable files: `<ENV>.tfvars` and `<ENV>_<REGION>.tfvars`.

```bash
make console ENV=dev REGION=eu-west-2
```

Optional: Pass additional arguments with `ARGS`.

### Validation Targets

These are internal targets used to ensure required environment variables are set:

- `validate-aws`: Checks for `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`.
- `validate-env`: Checks for `ENV`.
- `validate-region`: Checks for `REGION`.

## Usage Example

To plan and apply changes for the `dev` environment in `eu-west-2`:

```bash
export AWS_ACCESS_KEY_ID="your-access-key"
export AWS_SECRET_ACCESS_KEY="your-secret-key"
make init ENV=dev REGION=eu-west-2
make plan ENV=dev REGION=eu-west-2
make apply ENV=dev REGION=eu-west-2
```

To destroy the same environment:

```bash
make destroy ENV=dev REGION=eu-west-2
```

## Notes

- Ensure `<ENV>.tfvars` and `<ENV>_<REGION>.tfvars` files exist in the working directory before running `plan`, `apply`, `destroy`, or `console`.
- The `ARGS` variable allows passing additional Terraform command-line arguments.
- State files are stored in an S3 bucket named `<ORG>-<APP>-<REGION>-tf-state`.
- Always specify `ENV` and `REGION` when running commands to avoid errors.

## Troubleshooting

- **Missing AWS credentials**: Ensure `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` are set.
- **Missing ENV or REGION**: Always provide `ENV` and `REGION` (e.g., `make plan ENV=dev REGION=eu-west-2`).
- **Variable file errors**: Verify that `<ENV>.tfvars` and `<ENV>_<REGION>.tfvars` exist and are correctly formatted.
