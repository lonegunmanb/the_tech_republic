#!/bin/bash

# 生成HTML电子书脚本
# 使用pandoc将markdown_zh目录中的所有文件合并生成HTML电子书

echo "开始生成HTML电子书..."

# 设置目录
MARKDOWN_DIR="OEBPS/markdown_zh"
OUTPUT_DIR="output"
OUTPUT_FILE="$OUTPUT_DIR/The_Tech_Republic_Chinese_Book.html"
IMAGES_DIR="OEBPS/images"

# 创建输出目录
mkdir -p "$OUTPUT_DIR"

# 临时文件用于存储合并的markdown
TEMP_FILE="/tmp/combined_book.md"

# 清空临时文件
> "$TEMP_FILE"

echo "正在合并markdown文件..."

# 按文件名排序合并所有markdown文件
for file in $(ls "$MARKDOWN_DIR"/*.md | sort); do
    filename=$(basename "$file")
    
    echo "添加文件: $filename"
    
    # 添加章节标题
    echo "---" >> "$TEMP_FILE"
    echo "" >> "$TEMP_FILE"
    
    # 添加文件内容到临时文件
    cat "$file" >> "$TEMP_FILE"
    
    # 在文件之间添加分隔
    echo -e "\n\n" >> "$TEMP_FILE"
done

echo "正在生成HTML电子书..."

# 使用pandoc生成HTML
pandoc \
    "$TEMP_FILE" \
    -o "$OUTPUT_FILE" \
    --resource-path=".:$IMAGES_DIR:OEBPS" \
    --toc \
    --toc-depth=2 \
    --number-sections \
    --standalone \
    --template=pandoc \
    --css=style.css \
    --metadata title="技术共和国" \
    --metadata author="Alex Karp" \
    --metadata lang=zh-CN \
    --metadata charset=utf-8

# 检查是否成功生成
if [ -f "$OUTPUT_FILE" ]; then
    echo "✅ HTML电子书生成成功: $OUTPUT_FILE"
    echo "文件大小: $(du -h "$OUTPUT_FILE" | cut -f1)"
else
    echo "❌ HTML电子书生成失败"
    exit 1
fi

# 清理临时文件
rm -f "$TEMP_FILE"

echo "完成！可以在浏览器中打开查看电子书。"
