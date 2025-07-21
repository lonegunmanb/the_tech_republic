#!/bin/bash

en_dir="OEBPS/markdown_en"
zh_dir="OEBPS/markdown_zh"

en_files=$(ls -1 "$en_dir")
zh_files=$(ls -1 "$zh_dir")

en_count=$(echo "$en_files" | wc -l)
zh_count=$(echo "$zh_files" | wc -l)

if [ "$en_count" -eq "$zh_count" ]; then
  echo "翻译完成了，两个目录下的文件数量相同：$en_count"
else
  echo "翻译没有完成，英文目录有 $en_count 个文件，中文目录有 $zh_count 个文件。"
  echo "缺失的文件如下:"
  diff <(echo "$en_files") <(echo "$zh_files") | grep "^<" | cut -c 3-
fi
