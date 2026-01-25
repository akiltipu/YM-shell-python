import boto3
import argparse
import base64

def copy_secrets(region, source_stack, target_stack, dry_run=False):
    client = boto3.client("secretsmanager", region_name=region)
    paginator = client.get_paginator("list_secrets")

    print("=" * 80)
    print(f"Region       : {region}")
    print(f"Source stack : {source_stack}")
    print(f"Target stack : {target_stack}")
    print(f"Mode         : {'DRY-RUN' if dry_run else 'COPY'}")
    print("Filtering    : Only /akiltipu paths")
    print("=" * 80)

    for page in paginator.paginate():
        for secret in page.get("SecretList", []):
            secret_name = secret["Name"]

            # Exclude non-akiltipu secrets
            if not secret_name.startswith("akiltipu/"):
                continue

            # Must contain source stack as path segment
            stack_token = f"/{source_stack}/"
            if stack_token not in secret_name:
                continue

            target_secret_name = secret_name.replace(
                stack_token,
                f"/{target_stack}/"
            )

            print("\n------------------------------------------------------------")
            print(f"SOURCE SECRET : {secret_name}")
            print(f"TARGET SECRET : {target_secret_name}")

            try:
                source_value = client.get_secret_value(
                    SecretId=secret_name
                )

                if "SecretString" in source_value:
                    secret_payload = source_value["SecretString"]
                    print("SECRET TYPE   : String")
                    print("SECRET VALUE  :")
                    print(secret_payload)
                else:
                    secret_payload = source_value["SecretBinary"]
                    print("SECRET TYPE   : Binary (base64)")
                    print("SECRET VALUE :")
                    print(base64.b64encode(secret_payload).decode())

                if dry_run:
                    print("ACTION        : DRY-RUN (no update performed)")
                    continue

                if "SecretString" in source_value:
                    client.put_secret_value(
                        SecretId=target_secret_name,
                        SecretString=secret_payload
                    )
                else:
                    client.put_secret_value(
                        SecretId=target_secret_name,
                        SecretBinary=secret_payload
                    )

                print("ACTION        : COPIED SUCCESSFULLY")

            except client.exceptions.ResourceNotFoundException:
                print("STATUS        : ❌ TARGET SECRET NOT FOUND")

            except Exception as e:
                print(f"STATUS        : ❌ ERROR - {e}")

    print("\nCompleted secret processing.")
    print("=" * 80)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="Copy AWS Secrets between stacks with full verbosity"
    )
    parser.add_argument("--region", required=True)
    parser.add_argument("--source-stack", required=True)
    parser.add_argument("--target-stack", required=True)
    parser.add_argument("--dry-run", action="store_true")

    args = parser.parse_args()

    copy_secrets(
        region=args.region,
        source_stack=args.source_stack,
        target_stack=args.target_stack,
        dry_run=args.dry_run
    )

# Example usage:
# python copy_secret.py --region us-east-1 --source-stack dev --target-stack prod --dry-run