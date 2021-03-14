#!/bin/bash

set -e

build_task() {
    cd "$PART_PATH"

    if [ ! -e "$TASK_PATH/zadanie.md" ]; then
        >&2 echo zadanie.md does not exist!
        exit 1
    fi

    make "single-$TASK.pdf"
    cp "single-$TASK.pdf" "$OUT_PATH/combined.pdf"
}

build_part() {
    cd "$PART_PATH"
    make pdf
    cp zadania/zadania.pdf vzoraky/vzoraky.pdf "$OUT_PATH"
}

BRANCH=${GITHUB_HEAD_REF:-${GITHUB_REF}}
BRANCH=${BRANCH#refs/heads/}

ref_regex="r([0-9][0-9])/([lz])([12])/(p([1-8])|kolo)"
if [[ ${BRANCH} =~ $ref_regex ]]; then
    case "${BASH_REMATCH[2]}" in
        z) season=zima ;;
        l) season=leto ;;
    esac
    PART_PATH="$(realpath "${BASH_REMATCH[1]}rocnik/${season}${BASH_REMATCH[3]}")"
    TASK_PATH="$(realpath "${PART_PATH}/prikl${BASH_REMATCH[5]}")"
    TASK="prikl${BASH_REMATCH[5]}"
    OUT_PATH="$(pwd)/ci_out"
    mkdir -p "$OUT_PATH"
    export PART_PATH TASK_PATH OUT_PATH TASK
    case "${GITHUB_EVENT_NAME}" in
        pull_request)
            build_task ;;
        push)
            build_part ;;
        workflow_dispatch)
            >&2 echo "workflow_dispatch not yet supported"
            exit 1 ;;
        *) 
            >&2 echo "Unsupported EVENT_NAME"
            exit 1 ;;
    esac
else
    >&2 echo "Bad branch name"
    exit 1
fi
