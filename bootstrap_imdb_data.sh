#!/bin/bash

set -euo pipefail

BASEDIR=$(dirname "$0")
UNCOMMITTED_DIR=${BASEDIR}/uncommitted

mkdir -p ${UNCOMMITTED_DIR}

for dataset in name.basics.tsv title.akas.tsv
do
    
    if [ ! -f ${UNCOMMITTED_DIR}/${dataset}.gz ]
    then
        curl https://datasets.imdbws.com/${dataset}.gz --output ${UNCOMMITTED_DIR}/${dataset}.gz
    fi

    if [ ! -f ${UNCOMMITTED_DIR}/${dataset} ]
    then
        gunzip -c ${UNCOMMITTED_DIR}/${dataset}.gz > ${UNCOMMITTED_DIR}/${dataset}
    fi
done

