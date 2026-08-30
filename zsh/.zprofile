if [ -x /home/linuxbrew/.linuxbrew/bin/brew ]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
elif [ -x "$HOME/.linuxbrew/bin/brew" ]; then
  eval "$("$HOME/.linuxbrew/bin/brew" shellenv)"
elif [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

if [ -r /opt/homebrew/etc/openssl@3/cert.pem ]; then
  export AWS_CA_BUNDLE="/opt/homebrew/etc/openssl@3/cert.pem"
  export REQUESTS_CA_BUNDLE="/opt/homebrew/etc/openssl@3/cert.pem"
elif [ -r /home/linuxbrew/.linuxbrew/etc/openssl@3/cert.pem ]; then
  export AWS_CA_BUNDLE="/home/linuxbrew/.linuxbrew/etc/openssl@3/cert.pem"
  export REQUESTS_CA_BUNDLE="/home/linuxbrew/.linuxbrew/etc/openssl@3/cert.pem"
fi
