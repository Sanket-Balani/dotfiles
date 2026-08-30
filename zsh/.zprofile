if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Corporate TLS inspection CA bundle for AWS CLI, boto3/botocore, and requests.
export AWS_CA_BUNDLE="/opt/homebrew/etc/openssl@3/cert.pem"
export REQUESTS_CA_BUNDLE="/opt/homebrew/etc/openssl@3/cert.pem"
