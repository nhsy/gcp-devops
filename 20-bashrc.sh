if [ ! -f ~/.bashrc ]; then
cat << EOF > ~/.bashrc
export PS1='\u@\h:\W \$ '
alias l='ls -CF'
alias la='ls -A'
alias ll='ls -alF'
alias ls='ls --color=auto'
source /etc/profile.d/bash_completion.sh
export PS1="\[\e[31m\][\[\e[m\]\[\e[38;5;172m\]\u\[\e[m\]@\[\e[38;5;153m\]\h\[\e[m\] \[\e[38;5;214m\]\W\[\e[m\]\[\e[31m\]]\[\e[m\]\\$ "

alias tf='terraform \$*'
alias tfi='terraform init \$*'
alias tff='terraform fmt -recursive'
alias tfv='terraform validate'
alias tfp='terraform plan \$*'
alias tfa='terraform apply \$*'
alias tfd='terraform destroy \$*'
alias tfo='terraform output'

alias k='kubectl \$*'
alias ka='kubectl apply \$*'
alias kd='kubectl describe \$*'
alias kg='kubectl get \$*'
alias kl='kubectl logs \$*'
alias kr='kubectl run \$*'

EOF
fi
