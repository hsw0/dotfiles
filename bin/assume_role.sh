#!/bin/bash

set -eu
umask 0022

if [[ $# -lt 1 ]]; then
    echo "Usage: $0 role_name [AWS ACCOUNT NUMBER]" >&2
    exit 1
fi

ROLE_NAME="$1"

caller_identity=($(aws sts get-caller-identity --output text))
CURRENT_AWS_ACCOUNT_NUMBER="${caller_identity[0]}"
AWS_IAM_USER_ARN="${caller_identity[1]}"
AWS_IAM_USERNAME="$(basename "$AWS_IAM_USER_ARN")"

if [[ $# -lt 2 ]]; then
    aws_account_number="$CURRENT_AWS_ACCOUNT_NUMBER"
else
    aws_account_number="$2"
fi

role_arn="arn:aws:iam::$aws_account_number:role/$ROLE_NAME"
role_session_name="$AWS_IAM_USERNAME"

echo "I AM: $AWS_IAM_USER_ARN"
echo "Assuming $role_arn ($role_session_name)"

credentials=($(aws sts assume-role --role-arn "$role_arn" --role-session-name "$role_session_name" --query 'Credentials.[AccessKeyId,SecretAccessKey,SessionToken]' --output text))
export AWS_ACCESS_KEY_ID="${credentials[0]}" AWS_SECRET_ACCESS_KEY="${credentials[1]}" AWS_SESSION_TOKEN="${credentials[2]}"

# https://github.com/boto/boto/issues/2988 Workaround
export AWS_SECURITY_TOKEN="$AWS_SESSION_TOKEN"

aws sts get-caller-identity

exec $SHELL
