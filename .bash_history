apt-get update
apt-get install default-jdk -y
java --version 
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > \
    /etc/apt/sources.list.d/jenkins.list'
apt-get update
apt-get install jenkins -y
jenkins --version
jenkins -help
cat /var/lib/jenkins/secrets/initialAdminPassword
ls
cd snap/
ls
cd
ls -lr
ls -lrt
cd /var/lib
ls
cd jenkins/
ls
git status
cd
apt-get install gir
apt-get install git
git --help
apt install git
ls
ls -lrta
cd
cd..
exit
