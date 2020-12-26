#/bin/bash

KNXD_VERSION=$(cat build.json | grep KNXD | sed -r "s/.*VERSION\".*:.*\"(.*)\"/\1/")
REPO=$(cat config.json | grep image |sed -r "s/.*image\"\s*:\s*\"(.*)-\{arch\}\".*/\1/")



function get_arch_by_repo {
    echo $(echo $DOCKER_REPO |sed -r 's/.*knxd-(.*)/\1/')
}

function image_tag {
    echo "${REPO}-${1}:${DOCKER_TAG}"
}

function get_arch {
    #cat build.json| jq -r ".build_from | keys[]" 
    cat build.json  | grep homeas | sed -r "s/\s*\"(.*)\".*:.*home.*/\1/"
}

function get_base_image {
    #cat build.json| jq -r ".build_from.$1"
    cat build.json  | grep $1 | sed -r "s/.*:\s*\"(.*)\".*/\1/"
}