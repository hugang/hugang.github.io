# 安装k8s

## 准备节点
```bash
# 利用vagrant创建虚拟机master
# Vagrantfile
Vagrant.configure("2") do |config|
    config.vm.box = "almalinux/8"
    config.vm.network "public_network", ip: "192.168.0.11"
    
    config.vm.provider "virtualbox" do |vb|
        vb.cpus = 2
        vb.memory = "4096"
    end
end

# 利用vagrant创建虚拟机node1~node3 192.168.0.21~192.168.0.23
# Vagrantfile
Vagrant.configure("2") do |config|
    config.vm.box = "almalinux/8"
    config.vm.network "public_network", ip: "192.168.0.21"
    
    config.vm.provider "virtualbox" do |vb|
        vb.cpus = 2
        vb.memory = "8192"
    end
end
```

## 环境配置

### 配置主机hosts
```bash
vi /etc/hosts

# 追加以下配置
192.168.0.11 master
192.168.0.21 node1
192.168.0.22 node2
192.168.0.23 node3
```

### 配置主机名
```bash
# 设置主机名192.168.0.11
hostnamectl set-hostname master
# 设置主机名192.168.0.21
hostnamectl set-hostname node1
# 设置主机名192.168.0.22
hostnamectl set-hostname node2
# 设置主机名192.168.0.23
hostnamectl set-hostname node3
```

### 禁止selinux
```bash
sudo setenforce 0
sudo sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config
```

### 关闭防火墙
```bash
sudo systemctl stop firewalld
sudo systemctl disable firewalld
# 启用防火墙时需要开放端口
```

## 安装docker

### yum工具
```bash
sudo yum install -y yum-utils
```

### 添加docker源
```bash
 sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo
```

### 安装docker包
```bash
# 选择稳定版本
sudo yum install -y docker-ce-20.10.23 docker-ce-cli-20.10.23 containerd.io-20.10.23
```
### 配置chromedriver
```bash
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
```
### 自动启动docker
```bash
systemctl enable docker --now
```

## 安装k8s

### k8s配置
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
```

### 安装k8s包
```bash
sudo yum install -y kubelet-1.22.17 kubeadm-1.22.17 kubectl-1.22.17 --disableexcludes=kubernetes
```

### 自动启动k8s
```bash
systemctl enable kubelet --now
```

### 追加设定
```bash
# 遇到问题`container runtime is not running`
sudo rm /etc/containerd/config.toml
sudo systemctl restart containerd
```

## 初始化k8s

### 初始化master
```bash
kubeadm init --apiserver-advertise-address=192.168.0.11 --control-plane-endpoint=master --service-cidr=10.96.0.0/16 --pod-network-cidr=10.244.0.0/16
```

### 配置kubectl
```bash
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

### 配置calico网络
```bash
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.25.0/manifests/calico.yaml
# 如果需要修改配置，可以下载到本地修改后再执行
# 192.168.0.0/16 --> 172.77.0.0/16
```

### 加入节点
```bash
# 例
kubeadm join master:6443 --token usswql.k1hxj0ixobrntpzk --discovery-token-ca-cert-hash sha256:b12de0acb4cbc851948c8e4445ca2fa81760a5bc8ef6052124b80280b78571af
```

### 重新生成加入口令
```bash
kubeadm token create --print-join-command
```

### 出现问题时查看节点kubelet状态
```bash
journalctl -xu kubelet.service
```

## k9s

```bash
# 下载
curl -LO https://github.com/derailed/k9s/releases/download/v0.27.3/k9s_Linux_amd64.tar.gz
```

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

