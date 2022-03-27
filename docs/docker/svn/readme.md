
docker-compose up -d # Setup docker.
docker-compose exec svn svnadmin create --fs-type fsfs pipeline # Create SVN repository.
docker-compose exec svn htpasswd -b /etc/subversion/passwd svn-admin svn-admin # Create Admin user.

#enter docker container
docker exec -it svn-server sh

cd /etc/apache2/conf.d
cat dav_svn.conf

LoadModule dav_svn_module /usr/lib/apache2/mod_dav_svn.so
LoadModule authz_svn_module /usr/lib/apache2/mod_authz_svn.so

<Location /svn>
     DAV svn
     SVNParentPath /home/svn
     SVNListParentPath On
     AuthType Basic
     AuthName "Subversion Repository"
     AuthUserFile /etc/subversion/passwd
     AuthzSVNAccessFile /etc/subversion/subversion-access-control
     Require valid-user
</Location>
