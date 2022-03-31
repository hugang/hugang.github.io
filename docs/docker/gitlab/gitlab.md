```yaml
version: '3.6'
services:
  web:
    image: 'gitlab/gitlab-ee:latest'
    restart: always
    hostname: 'gitlab.example.com'
    environment:
      GITLAB_OMNIBUS_CONFIG: |
        external_url 'https://gitlab.example.com:8880'
        nginx['listen_port'] = 8880
    ports:
      - '8880:80'
      - '443:443'
      - '22:22'
    volumes:
      - '$GITLAB_HOME/config:/etc/gitlab'
      - '$GITLAB_HOME/logs:/var/log/gitlab'
      - '$GITLAB_HOME/data:/var/opt/gitlab'
    shm_size: '256m'


```


## reset root password
Enter gitlab container
sudo gitlab-rake "gitlab:password:reset"

Nttdata03!


## Registe gitlab-runner
docker run -d --network local-server-network --name gitlab-runner --restart always \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v gitlab-runner-config:/etc/gitlab-runner \
    gitlab/gitlab-runner:latest


docker exec -it gitlab-runner gitlab-runner register

## setup ldap login
https://qiita.com/hiren/items/cba9fc6da7165c9416a0


## .gitlab-ci.yml

tags: specific runner