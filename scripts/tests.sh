#!/bin/bash -ex
source /etc/os-release
env
IMAGE=${IMAGE}
if [[ $ID == "ubuntu" || $ID == "debian" ]]; then
    docker_args=(-v /etc/apt:/etc/apt -v /usr/share/keyrings:/usr/share/keyrings)
    cmd_args=("/lib/systemd/systemd-udevd --daemon && udevadm control --reload-rules")
elif [[ $ID == "tencentos" || $ID == "rhel" || $ID == "amzn" ]]; then
    docker_args=(-v /etc/yum.repos.d:/tmp/yum.repos.d)
    cmd_args=("/bin/cp -rf /tmp/yum.repos.d/* /etc/yum.repos.d/.")
fi

if [[ $ID == "rhel" ]] && [[ $VERSION_ID == "8.6" ]]; then
    cat <<EOF > /etc/yum.repos.d/habalabs-testing.repo
[habanalabs-testing]
baseurl = https://artifactory-kfs.habana-labs.com/artifactory/hl-rhel-prerel/8/8.6/testing
enabled = 1
gpgcheck = 0
gpgkey = https://artifactory-kfs.habana-labs.com/artifactory/api/gpg/key/public
name = Habana Pre Release Repo Mirror
EOF
fi

docker_container=$(docker run -d --privileged ${docker_args[@]} -v /lib/firmware:/lib/firmware $IMAGE bash -c "${cmd_args};habanalabs-installer.sh install --type k8s --skip-habanalabs-repo -y -v")
docker wait $docker_container

if [[ $(docker inspect $docker_container --format='{{.State.ExitCode}}') -ne 0 ]]; then
    docker logs $docker_container
    exit 1
fi
