#!/usr/bin/env bash

function print_separator() {
    printf "%0.1s" "-"{1..80}
    printf "\n"
}

function display_help() {
    local SCRIPT_NAME=`basename "$0"`
    printf "Examples of valid usage.\n"
    print_separator
    printf "$ bash %s %s Europe/Zurich\n" "${SCRIPT_NAME}"
    print_separator
}

function validate() {

    if [ $# -ne 1 ]; then
        printf "Mandatory argument is missing!\n"
        display_help
        exit ${ERROR}
    fi
}

function test_docker_extra_bashrc() {

    local _TIMEZONE=${1}

    (docker run -it -d --rm --env TZ=${_TIMEZONE} --name bash --hostname bash.test.io debian:sid /bin/bash \
        && docker exec -it --user root --workdir /root bash \
                    /bin/bash -c "groupadd --gid=1000 jd && useradd -m -g jd --uid=1000 --shell /bin/bash jd" \
        && docker cp docker-extra-bashrc bash:/home/jd/docker-extra-bashrc \
        && docker exec -it --user root --workdir /root bash /bin/bash -c "\ls -lh /home/jd/docker-extra-bashrc" \
        && docker exec -it --user root --workdir /root bash /bin/bash -c "chown jd:jd /home/jd/docker-extra-bashrc" \
        && docker exec -it --user root --workdir /root bash /bin/bash -c "chmod 644 /home/jd/docker-extra-bashrc" \
        && docker exec -it --user root --workdir /root bash /bin/bash -c "\ls -lh /home/jd/docker-extra-bashrc" \
        && docker exec -it --user jd --workdir /home/jd bash /bin/bash -c "cp ~/.bashrc ~/.bashrc.bck" \
        && docker exec -it --user jd --workdir /home/jd bash /bin/bash -c "echo >> ~/.bashrc" \
        && docker exec -it --user jd --workdir /home/jd bash /bin/bash -c "echo '. ~/docker-extra-bashrc' >> ~/.bashrc" \
        && docker exec -it --user jd --workdir /home/jd bash /bin/bash -c "date" \
        && docker exec -it --user jd --workdir /home/jd bash /bin/bash -i -c "la .") \
            && docker stop bash

    if [ $? -eq 0 ]; then
        printf "\n\e[1m\e[32mtest_docker_extra_bashrc passed\n\n"
    else
        docker stop bash
        printf "\n\e[1m\e[31mtest_docker_extra_bashrc failed\n\n"
    fi
}

function main() {

    validate "$@"
    test_docker_extra_bashrc "$@"
}

main "$@"
