#! /bin/bash

MYDIR=$(cd `dirname ${0}`; pwd)
GIT_OUTPUT_DIR=$2
PYTHON_DIR=${GIT_OUTPUT_DIR}/"python"
GO_DIR=${GIT_OUTPUT_DIR}/"golang"
CSHARP_DIR=${GIT_OUTPUT_DIR}/"csharp"

if [[ ! -d ${PYTHON_DIR} ]]; then
    mkdir -p ${PYTHON_DIR}
fi
if [[ ! -d ${GO_DIR} ]]; then
    mkdir -p ${GO_DIR}
fi
if [[ ! -d ${CSHARP_DIR} ]]; then
    mkdir -p ${CSHARP_DIR}
fi

function read_dir(){
        for file in `ls $1`
        do
            if [[ -d $1"/"$file ]]  #注意此处之间一定要加上空格，否则会报错
            then
                read_dir $1/${file}
            else
                # 取文件后缀
                extension=${file##*.}
                if [[ ${extension} == "proto" ]]
                then
                    cur_path=`pwd`
                    now_path=${cur_path}/$1
                    echo ${now_path}/${file}
                    docker run --rm -v ${MYDIR}:${MYDIR} -w $(pwd) znly/protoc -I ${now_path} \
                    --python_out=${PYTHON_DIR} \
                    --csharp_out ${CSHARP_DIR} \
                    --go_out ${GO_DIR} \
                    ${now_path}/${file}
                fi
            fi
        done
    }

if [[ $# == 0 ]]; then
    echo $#
    echo "you must choose a dir for proto."
    exit
fi
if [[ $# > 2 ]]; then
    echo $#
    echo "args more than 2!"
    exit
fi
if [[ ! -d $1 ]]; then
    ls
    echo "$1 does not exists in this dir."
    exit
fi
read_dir $1
