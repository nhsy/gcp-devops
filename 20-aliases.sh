if [ ! -f ~/.bash_aliases ]; then
cat << EOF > ~/.bash_aliases
alias tf='terraform \$*'
alias tfi='terraform init \$*'
alias tff='terraform fmt -recursive'
alias tfv='terraform validate'
alias tfp='terraform plan \$*'
alias tfa='terraform apply \$*'
alias tfd='terraform destroy \$*'
EOF
fi
