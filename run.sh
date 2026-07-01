#!/bin/bash


# api key
export OPENAI_BASE_URL=""
export OPENAI_API_KEY=""


INPUT="./CL-bench-context-dedup.jsonl"

python selfplay_loop.py \
    --challenger-model gpt-5.2 \
    --reasoner-model gpt-5.2 \
    --judge-model gpt-5.1 \
    --proposer-model gpt-5.2 \
    --generator-model gpt-5.2 \
    --input "$INPUT" \
    --output outputs/loop_data/loop_gpt-5.2-judge5-1.jsonl \
    --num-iterations 5 \
    --num-tasks 5 \
    --skills-dir skills-from-5.2-judge5-1 \
    --workers 32


INPUT="./CL-bench-with-task-delimiter.jsonl"

python infer.py \
    --model gpt-5.2 \
    --input "$INPUT" \
    --workers 32 \
    --skills-dir skills-from-5.2-judge5-1/reasoner \
    --output outputs/gpt-5.2-skills-from-5.2-judge5-1.jsonl

python eval_ignore_none.py \
    --input outputs/gpt-5.2-skills-from-5.2-judge5-1.jsonl \
    --judge-model gpt-5.1 \
    --workers 32
