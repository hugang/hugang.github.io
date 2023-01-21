
## 配置虚拟机
- 利用vagrant启动虚拟机，本次配置如下
```bash
192.168.0.115 node1
192.168.0.116 node3
192.168.0.117 node2

# 设置hostname命令
hostnamectl set-hostname master 
```
- 机器配置
```bash
# 禁止selinux
sudo setenforce 0
sudo sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config
# 禁止交换分区
sudo swapoff -a
# 禁止防火墙
sudo systemctl stop firewalld
sudo systemctl disable firewalld

# 使用防火墙的时候配置如下
firewall-cmd --add-port=6443/tcp --permanent
firewall-cmd --add-port=2379-2380/tcp --permanent
firewall-cmd --add-port=10250/tcp --permanent
firewall-cmd --add-port=10251/tcp --permanent
firewall-cmd --add-port=10252/tcp --permanent
firewall-cmd --reload
```

- 在master创建ssh密钥，方便接续使用
```bash
ssh-keygen -t rsa
```

## 安装docker
```bash
 sudo yum install -y yum-utils
 # 配置docker下载源
 sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo
# 安装docker以及其他依赖
sudo yum install -y docker-ce docker-ce-cli containerd.io
# 配置cgroupdriver
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
# 自动启动docker
systemctl enable docker --now
```

## 安装kubeadm
```bash
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

sudo yum install -y kubelet-1.22.17 kubeadm-1.22.17 kubectl-1.22.17 --disableexcludes=kubernetes

sudo systemctl enable --now kubelet
```
## 初始化kubernetes
- 遇到问题`container runtime is not running`
```bash
sudo rm /etc/containerd/config.toml
sudo systemctl restart containerd
```

- 初始化命令
```bash
kubeadm init --apiserver-advertise-address=192.168.0.115 --control-plane-endpoint=node1 --service-cidr=172.96.0.0/16 --pod-network-cidr=172.77.0.0/16
```
```
You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

You can now join any number of control-plane nodes by copying certificate authorities
and service account keys on each node and then running the following as root:

  kubeadm join node1:6443 --token usswql.k1hxj0ixobrntpzk \
	--discovery-token-ca-cert-hash sha256:b12de0acb4cbc851948c8e4445ca2fa81760a5bc8ef6052124b80280b78571af \
	--control-plane 

Then you can join any number of worker nodes by running the following on each as root:

kubeadm join node1:6443 --token usswql.k1hxj0ixobrntpzk --discovery-token-ca-cert-hash sha256:b12de0acb4cbc851948c8e4445ca2fa81760a5bc8ef6052124b80280b78571af
```

`export KUBECONFIG=/etc/kubernetes/admin.conf`在root下使用kubectl命令配置

- 网络配置
```bash
# 默认网络地址 pod-network-cidr 10.244.0.0/16
curl https://raw.githubusercontent.com/projectcalico/calico/v3.25.0/manifests/calico.yaml -O

vi calico.yaml
192.168.0.0/16 --> 172.77.0.0/16

kubectl apply -f calico.yaml
```
`kubeadm token create --print-join-command`重新生成加入口令

`journalctl -xu kubelet.service`查询状态

## k9s
curl -LO https://github.com/derailed/k9s/releases/download/v0.26.7/k9s_Linux_x86_64.tar.gz
```yaml
# 配置快捷键
# $XDG_CONFIG_HOME/k9s/hotkey.yml
hotKey:

  # Hitting Shift-0 navigates to your pod view
  shift-0:
    shortCut:    Shift-0
    description: Viewing pods
    command:     pods

  # Hitting Shift-1 navigates to your deployments
  shift-1:
    shortCut:    Shift-1
    description: View deployments
    command:     dp

  # Hitting Shift-2 navigates to your xray deployments
  shift-2:
    shortCut:    Shift-2
    description: XRay Deployments
    command:     xray deploy
```


## 使用kubernetes
- POD
```bash
# create a pod
kubectl run nginx --image=nginx
```

- ReplicaSet
```yaml
# create a pod ReplicaSet
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: nginx-replica-set
  labels:
    app: nginxReplicaSet
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginxPod
  template:
    metadata:
      labels:
        app: nginxPod
    spec:
      containers:
        - name: nginx
          image: nginx
```
```bash
kubectl scale --replicas=5 replicaset/nginx-replica-set
```
- Deployment
Deployment 负责创建ReplicaSet，并通过维护ReplicaSet来管理POD
```bash
kubectl create deployment mynginx --image nginx
kubectl scale --replicas=5 deployment/mynginx
kubectl delete deployment/mynginx
```
```yaml
apiVersion: apps/v1
kind: Deployment

metadata:
  labels:
    app: mynginx
  name: mynginx

spec:
  replicas: 2
  selector:
    matchLabels:
      app: mynginx
  template:
    metadata:
      labels:
        app: mynginx
    spec:
      containers:
      - image: nginx:latest
        name: mynginx
        ports:
        - containerPort: 80
```

- Service
```bash
kubectl expose deployment mynginx --port=80 --target-port=80
# 修改ClusterIP为NodePort，可以从外部访问
curl http://192.168.0.115:31115
```
```yaml
# "mynginx"という名前のtype: NodePortのServiceを作成
apiVersion: v1
kind: Service

metadata:
  labels:
    app: mynginx
  name: mynginx

spec:
  ports:
  - port: 80
    protocol: TCP
    targetPort: 80
  selector:
    app: mynginx
  type: NodePort
  ```

- Ingress

```yaml
# "mynginx" Serviceへトラフィックを振り分けるロードバランサを作成
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /$2
    nginx.ingress.kubernetes.io/configuration-snippet: |
      rewrite ^(/nginx)$ $1/ redirect;
    nginx.ingress.kubernetes.io/backend-protocol: "HTTPS"
    kubernetes.io/ingress.class: public
  name: mynginx
  #namespace: kube-system
spec:
  rules:
  - http:
      paths:
      - path: /dashboard(/|$)(.*)
        pathType: Prefix
        backend:
          service:
            name: mynginx
            port:
              number: 443
```