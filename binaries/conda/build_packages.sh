#!/usr/bin/env bash

set -eou pipefail

PYTHON_VERSIONS="3.6 3.7 3.8"
PKGS="torchserve torch-model-archiver"
TORCHSERVE_VERSION=`cat ../../ts/version.txt`
TORCH_MODEL_ARCHIVER_VERSION=`cat ../../model-archiver/model_archiver/version.txt`

for pkg in ${PKGS}; do
    PKG_VERSION=$(echo $pkg | tr 'a-z' 'A-Z' | tr '-' '_')_VERSION
    cat $pkg/meta.yaml.tmpl | sed -e "s/{version}/$PKG_VERSION/" >> $pkg/meta.yaml
    for python_version in ${PYTHON_VERSIONS}; do
        (
            set -x
            conda build --output-folder output/ --python="${python_version}" "${pkg}"
            set +x
        )
    done
    rm $pkg/meta.yaml
done
