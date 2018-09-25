#!/bin/bash

set -eu
umask 0022

if [[ $# -ge 1 ]]; then
    AWS_PROFILE="$1"
else
    read -p 'Enter AWS_PROFILE: ' AWS_PROFILE
fi

caller_identity=($(aws --profile "$AWS_PROFILE" sts get-caller-identity --output text))

AWS_ACCOUNT_NUMBER="${caller_identity[0]}"
AWS_IAM_USER_ARN="${caller_identity[1]}"
AWS_IAM_USERNAME="$(basename "$AWS_IAM_USER_ARN")"
MFA_SERIAL="arn:aws:iam::$AWS_ACCOUNT_NUMBER:mfa/$AWS_IAM_USERNAME"

echo "AWS Account number: $AWS_ACCOUNT_NUMBER"
echo "IAM Username: $AWS_IAM_USERNAME"
echo "MFA Serial: $MFA_SERIAL"

tmpdir=$(mktemp -d)
trap "rm -rf '$tmpdir'" EXIT

if ykman oath info > "$tmpdir/yk-oath-info" 2>&1 ; then
    echo "Trying to read MFA code from Yubikey."
    cat "$tmpdir/yk-oath-info"
    rm -f "$tmpdir/yk-oath-info"

    ykman oath code "$AWS_PROFILE" 2>&1 | tee "$tmpdir/yk-mfa-code"
    otp_token=$(grep -F "$AWS_PROFILE" "$tmpdir/yk-mfa-code" | awk '{print $NF}')
    rm -f "$tmpdir/yk-mfa-code"
    [[ -z "$otp_token" ]] && exit 1
else
    read -p 'Enter MFA code: ' otp_token
fi

rm -rf "$tmpdir"

session_token=($(aws --profile "$AWS_PROFILE" sts get-session-token --serial-number $MFA_SERIAL --token-code $otp_token --query 'Credentials.[AccessKeyId,SecretAccessKey,SessionToken]' --output text))
export AWS_ACCESS_KEY_ID="${session_token[0]}" AWS_SECRET_ACCESS_KEY="${session_token[1]}" AWS_SESSION_TOKEN="${session_token[2]}"

# https://github.com/boto/boto/issues/2988 Workaround
export AWS_SECURITY_TOKEN="$AWS_SESSION_TOKEN"

aws sts get-caller-identity

exec $SHELL
