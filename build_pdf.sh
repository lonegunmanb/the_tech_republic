#!/bin/bash

# 生成PDF电子书脚本
# 使用pandoc将markdown_zh目录中的所有文件合并生成PDF

echo "开始生成PDF电子书..."

# 设置目录
MARKDOWN_DIR="OEBPS/markdown_zh"
OUTPUT_DIR="output"
OUTPUT_FILE="$OUTPUT_DIR/The_Tech_Republic_Chinese.pdf"
IMAGES_DIR="OEBPS/images"

# 创建输出目录
mkdir -p "$OUTPUT_DIR"

# 临时文件用于存储合并的markdown
TEMP_FILE="/tmp/combined_book.md"

# 清空临时文件
> "$TEMP_FILE"

echo "正在合并markdown文件..."

# 按文件名排序合并所有markdown文件
# 跳过封面文件，因为PDF中封面会单独处理
for file in $(ls "$MARKDOWN_DIR"/*.md | sort); do
    filename=$(basename "$file")
    
    # 跳过封面文件
    if [[ "$filename" == *"cvi"* ]]; then
        echo "跳过封面文件: $filename"
        continue
    fi
    
    echo "添加文件: $filename"
    
    # 添加文件内容到临时文件
    cat "$file" >> "$TEMP_FILE"
    
    # 在文件之间添加分页符
    echo -e "\n\\newpage\n" >> "$TEMP_FILE"
done

echo "正在生成PDF..."

# 使用pandoc生成PDF
# 使用xelatex支持中文，配置可用的中文字体
echo "正在使用 xelatex 生成PDF..."

# 检查可用的中文字体
echo "检查可用字体..."
fc-list :lang=zh-cn family | head -5

# 尝试多种字体配置
FONTS=("SimSun" "WenQuanYi Micro Hei" "AR PL UMing CN" "Noto Sans CJK SC" "DejaVu Sans")

for FONT in "${FONTS[@]}"; do
    echo "尝试使用字体: $FONT"
    
    if [[ "$FONT" == "SimSun" || "$FONT" == "AR PL UMing CN" || "$FONT" == "WenQuanYi Micro Hei" ]]; then
        # 对于中文字体，使用CJK配置
        pandoc \
            "$TEMP_FILE" \
            -o "$OUTPUT_FILE" \
            --pdf-engine=xelatex \
            --resource-path=".:$IMAGES_DIR:OEBPS" \
            --toc \
            --toc-depth=2 \
            --number-sections \
            --standalone \
            -V documentclass=book \
            -V geometry:margin=2cm \
            -V CJKmainfont="$FONT" \
            -V fontsize=11pt \
            -V linestretch=1.2 \
            --metadata title="技术共和国" \
            --metadata author="Alex Karp" \
            --metadata lang=zh-CN 2>/dev/null
    else
        # 对于其他字体，使用标准配置
        pandoc \
            "$TEMP_FILE" \
            -o "$OUTPUT_FILE" \
            --pdf-engine=xelatex \
            --resource-path=".:$IMAGES_DIR:OEBPS" \
            --toc \
            --toc-depth=2 \
            --number-sections \
            --standalone \
            -V documentclass=book \
            -V geometry:margin=2cm \
            -V mainfont="$FONT" \
            -V fontsize=11pt \
            -V linestretch=1.2 \
            --metadata title="技术共和国" \
            --metadata author="Alex Karp" \
            --metadata lang=zh-CN 2>/dev/null
    fi
    
    # 如果成功生成，退出循环
    if [ -f "$OUTPUT_FILE" ]; then
        echo "✅ 使用字体 $FONT 成功生成PDF"
        break
    fi
done

# 如果所有字体都失败，尝试最基本的配置
if [ ! -f "$OUTPUT_FILE" ]; then
    echo "尝试基本配置..."
    pandoc \
        "$TEMP_FILE" \
        -o "$OUTPUT_FILE" \
        --pdf-engine=xelatex \
        --resource-path=".:$IMAGES_DIR:OEBPS" \
        --toc \
        --toc-depth=2 \
        --number-sections \
        --standalone \
        -V documentclass=book \
        -V geometry:margin=2cm \
        -V fontsize=11pt \
        -V linestretch=1.2 \
        --metadata title="技术共和国" \
        --metadata author="Alex Karp" \
        --metadata lang=zh-CN
fi

# 检查是否成功生成
if [ -f "$OUTPUT_FILE" ]; then
    echo "✅ PDF生成成功: $OUTPUT_FILE"
    echo "文件大小: $(du -h "$OUTPUT_FILE" | cut -f1)"
else
    echo "❌ PDF生成失败"
    exit 1
fi

# 清理临时文件
rm -f "$TEMP_FILE"

echo "完成！"
