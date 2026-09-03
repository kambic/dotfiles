# ~/.config/fish/conf.d/abbreviations.fish
# Abbreviations expand inline when you hit Space/Enter, so your history stays
# readable and you can edit the expanded command before running it.
# fish autoloads everything in conf.d/ — no sourcing needed.

status is-interactive; or exit

# ── Git ──────────────────────────────────────
abbr -a g      git
abbr -a ga     git add
abbr -a gaa    git add -A
abbr -a gc     git commit -m
abbr -a gca    git commit --amend --no-edit
abbr -a gcm    git checkout main
abbr -a gco    git checkout
abbr -a gcb    git checkout -b
abbr -a gd     git diff
abbr -a gds    git diff --staged
abbr -a gf     git fetch --all --prune
abbr -a gl     git log --oneline --graph --decorate -15
abbr -a gp     git push
abbr -a gpf    git push --force-with-lease
abbr -a gpl    git pull --rebase
abbr -a grh    git reset --hard
abbr -a gst    git status -sb
abbr -a gsw    git switch
abbr -a gsta   git stash
abbr -a gstp   git stash pop
abbr -a gwip   git commit -am "wip"

# ── Docker / Compose ─────────────────────────
abbr -a d      docker
abbr -a dps    docker ps
abbr -a dpsa   docker ps -a
abbr -a di     docker images
abbr -a dl     docker logs -f
abbr -a dex    docker exec -it
abbr -a drm    docker rm -f
abbr -a drmi   docker rmi
abbr -a dprune docker system prune -af --volumes
abbr -a dc     docker compose
abbr -a dcu    docker compose up -d
abbr -a dcd    docker compose down
abbr -a dcl    docker compose logs -f
abbr -a dcr    docker compose restart
abbr -a dcb    docker compose build --pull

# ── Kubernetes ───────────────────────────────
abbr -a k      kubectl
abbr -a kg     kubectl get
abbr -a kgp    kubectl get pods
abbr -a kgpa   kubectl get pods -A
abbr -a kgpw   kubectl get pods -w
abbr -a kgs    kubectl get svc
abbr -a kgn    kubectl get nodes -o wide
abbr -a kgd    kubectl get deploy
abbr -a kgi    kubectl get ingress
abbr -a kd     kubectl describe
abbr -a kdp    kubectl describe pod
abbr -a kaf    kubectl apply -f
abbr -a kdf    kubectl delete -f
abbr -a kdel   kubectl delete
abbr -a kl     kubectl logs -f
abbr -a klp    kubectl logs -f --previous
abbr -a kex    kubectl exec -it
abbr -a kpf    kubectl port-forward
abbr -a ke     kubectl edit
abbr -a ktop   kubectl top pods
abbr -a kev    kubectl get events --sort-by=.lastTimestamp
abbr -a kctx   kubectl config use-context
abbr -a kns    kubectl config set-context --current --namespace
abbr -a krr    kubectl rollout restart deploy
abbr -a krs    kubectl rollout status deploy
abbr -a krun   kubectl run tmp --rm -it --image=busybox -- sh

# ── Helm ─────────────────────────────────────
abbr -a h      helm
abbr -a hl     helm list -A
abbr -a hi     helm install
abbr -a hu     helm upgrade --install
abbr -a hun    helm uninstall
abbr -a hrepo  helm repo update

# ── Terraform / OpenTofu ─────────────────────
abbr -a tf     terraform
abbr -a tfi    terraform init
abbr -a tfp    terraform plan
abbr -a tfa    terraform apply
abbr -a tfaa   terraform apply -auto-approve
abbr -a tfd    terraform destroy
abbr -a tff    terraform fmt -recursive
abbr -a tfv    terraform validate
abbr -a tfo    terraform output
abbr -a tfs    terraform state list

# ── Ansible ──────────────────────────────────
abbr -a ap     ansible-playbook
abbr -a apc    ansible-playbook --check --diff
abbr -a av     ansible-vault

# ── systemd / journald ───────────────────────
abbr -a sc     systemctl
abbr -a scs    systemctl status
abbr -a scr    sudo systemctl restart
abbr -a sce    sudo systemctl enable --now
abbr -a scu    systemctl --user
abbr -a jf     journalctl -f
abbr -a ju     journalctl -u

# ── Misc ─────────────────────────────────────
abbr -a v      nvim
abbr -a c      clear
abbr -a ..     cd ..
abbr -a ...    cd ../..
abbr -a ....   cd ../../..
abbr -a please sudo
abbr -a dfh    df -h
abbr -a duh    du -sh *
abbr -a wgetc  wget -c
abbr -a histg  "history | grep"

# Pipe helpers — expand anywhere on the line, not just at the start.
# Type `kgp G nginx<space>` → `kubectl get pods | grep nginx`
abbr -a G  --position anywhere "| grep -i"
abbr -a L  --position anywhere "| less"
abbr -a W  --position anywhere "| wc -l"
abbr -a J  --position anywhere "| jq ."
abbr -a Y  --position anywhere "| yq ."
abbr -a NE --position anywhere "2>/dev/null"

# Smart abbr: `!!` expands to the previous command (like bash)
function _last_history_item
    echo $history[1]
end
abbr -a !! --position anywhere --function _last_history_item
