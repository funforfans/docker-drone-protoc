#! /bin/bash

MYDIR=$(cd `dirname ${0}`; pwd)

PROTO_SRC_DIR="proto"
GIT_PROTO_SRC_DIR_REP="https://tygit.touch4.me/xuyiwen/proto"
PROTO_TAEGET_DIR="dist"
GIT_PUSH_REP="http://git.touch4.me/xuyiwen/generate_protocol.git"

if [[ ! -d ${PROTO_SRC_DIR} ]]; then
    echo "proto source clone into ${PROTO_SRC_DIR}..."
    git clone ${GIT_PROTO_SRC_DIR_REP} ${PROTO_SRC_DIR}
else
    cd ${PROTO_SRC_DIR}
    git pull
    cd ..
fi
if [[ ! -d ${PROTO_TAEGET_DIR} ]]; then
    echo "proto target clone into ${PROTO_TAEGET_DIR}..."
    git clone ${GIT_PUSH_REP} ${PROTO_TAEGET_DIR}
else
    cd ${PROTO_TAEGET_DIR}
    git pull
    cd ..
fi
sh docker_protoc_gen_recurse.sh ${PROTO_SRC_DIR} ${PROTO_TAEGET_DIR}
cd ${PROTO_TAEGET_DIR}
git add .
git commit -m "auto generate."
git push ${GIT_PUSH_REP} master
cd ..

