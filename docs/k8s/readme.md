

=======================================================

master
35.187.206.54
192.168.0.107

node1
34.85.117.67
192.168.0.13

node2
34.84.160.90
192.168.0.14


ssh-keygen -t rsa
add public key to instances

sudo hostnamectl set-hostname master
sudo hostnamectl set-hostname node1
sudo hostnamectl set-hostname node2


10.146.0.107 master
10.146.0.109 node1
10.146.0.14 node2


sudo setenforce 0
sudo swapoff -a
sudo systemctl stop firewalld



=======================================================
安装docker

 sudo yum install -y yum-utils
 sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo

sudo yum install docker-ce docker-ce-cli containerd.io

sudo mkdir /etc/docker
cat <<EOF | sudo tee /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF
systemctl enable docker --now

=======================================================
安装kubeadm
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sudo sysctl --system


cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-\$basearch
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kubelet kubeadm kubectl
EOF

# Set SELinux in permissive mode (effectively disabling it)
sudo setenforce 0
sudo sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

sudo yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes

sudo systemctl enable --now kubelet

=======================================================
初始化kubernetes
kubeadm init --apiserver-advertise-address=192.168.0.107 --control-plane-endpoint=master --service-cidr=172.96.0.0/16 --pod-network-cidr=172.77.0.0/16

To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

Alternatively, if you are the root user, you can run:

  export KUBECONFIG=/etc/kubernetes/admin.conf

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

You can now join any number of control-plane nodes by copying certificate authorities
and service account keys on each node and then running the following as root:

  kubeadm join master:6443 --token 8axzyu.lcfqsq6h7by3w2ur \
	--discovery-token-ca-cert-hash sha256:271ab8acc91b35bcf2c3f28b9dbdace56b4b3d02370889589440c2141c3b26f3 \
	--control-plane 

Then you can join any number of worker nodes by running the following on each as root:

kubeadm join master:6443 --token 8axzyu.lcfqsq6h7by3w2ur  --discovery-token-ca-cert-hash sha256:271ab8acc91b35bcf2c3f28b9dbdace56b4b3d02370889589440c2141c3b26f3

curl https://docs.projectcalico.org/manifests/calico.yaml -O

dashboard
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.2.0/aio/deploy/recommended.yaml


apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin-user
  namespace: kubernetes-dashboard
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: admin-user
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: admin-user
  namespace: kubernetes-dashboard


kubectl -n kubernetes-dashboard get secret $(kubectl -n kubernetes-dashboard get sa/admin-user -o jsonpath="{.secrets[0].name}") -o go-template="{{.data.token | base64decode}}"

eyJhbGciOiJSUzI1NiIsImtpZCI6Ind4SV9SaDBYamdQNkFvcERDcWFURkhHLXdFU01SWElKQlltcjMxb0RReHcifQ.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJrdWJlcm5ldGVzLWRhc2hib2FyZCIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VjcmV0Lm5hbWUiOiJhZG1pbi11c2VyLXRva2VuLWZxYnI1Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZXJ2aWNlLWFjY291bnQubmFtZSI6ImFkbWluLXVzZXIiLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlcnZpY2UtYWNjb3VudC51aWQiOiIwM2M2NTI5Yi1kZmFlLTRmZDctOTUxNC1lMmU0NWU1ZDA4ZTAiLCJzdWIiOiJzeXN0ZW06c2VydmljZWFjY291bnQ6a3ViZXJuZXRlcy1kYXNoYm9hcmQ6YWRtaW4tdXNlciJ9.6JRXCi6kiH-5RX956PUkWtyPPbEmpAoJs18Lt157Q4lc5SYOgzWD8hcafMM0yYyOkmf1fA9K1aFGtgSfmO-cTNyFLqn7VxYDyMmSDsiO12tpglqkz2E9PtfwWX_A5l0yTHnUnXV3t0IkTftQZ731S2HpXCNfC9Hi0jHyxkrtNJtgozCP1ZZfhl3k-waCnawrU3ED4nKJ95jShThkvGh5Qi-TBQBRqEbFpvJhNggWxprHrtoGfHO3pCfCOzsw2hXXldQiSsbIyqJn-2fpxWXh0oKQGjS3kZNW9-gApN6RNhsU8mAuwYcDENJnkJRpZTDbYU-nSoz0ymGk1z_KgvOepA

kubectl edit service/kubernetes-dashboard -n kubernetes-dashboard ClusterIP->NodePort