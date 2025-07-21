#!/bin/bash

# 电子书编译脚本
# 将 markdown_zh 目录中的中文翻译文件合并并编译成电子书

# 设置变量
zh_dir="OEBPS/markdown_zh"
output_dir="output"
output_name="The_Tech_Republic_Chinese"
temp_file="temp_merged.md"

# 创建输出目录
mkdir -p "$output_dir"

echo "开始编译电子书..."

# 定义文件顺序（按照电子书的逻辑顺序）
files_order=(
    "Karp_9780593798706_epub3_cvi_r1.md"      # 封面
    "Karp_9780593798706_epub3_p001_r1.md"     # 页面1
    "Karp_9780593798706_epub3_p002_r1.md"     # 页面2
    "Karp_9780593798706_epub3_cop_r1.md"      # 版权页
    "Karp_9780593798706_epub3_ded_r1.md"      # 献词
    "Karp_9780593798706_epub3_toc_r1.md"      # 目录
    "Karp_9780593798706_epub3_prf_r1.md"      # 前言
    "Karp_9780593798706_epub3_c001_r1.md"     # 第1章
    "Karp_9780593798706_epub3_c002_r1.md"     # 第2章
    "Karp_9780593798706_epub3_c003_r1.md"     # 第3章
    "Karp_9780593798706_epub3_c004_r1.md"     # 第4章
    "Karp_9780593798706_epub3_c005_r1.md"     # 第5章
    "Karp_9780593798706_epub3_c006_r1.md"     # 第6章
    "Karp_9780593798706_epub3_c007_r1.md"     # 第7章
    "Karp_9780593798706_epub3_c008_r1.md"     # 第8章
    "Karp_9780593798706_epub3_c009_r1.md"     # 第9章
    "Karp_9780593798706_epub3_c010_r1.md"     # 第10章
    "Karp_9780593798706_epub3_c011_r1.md"     # 第11章
    "Karp_9780593798706_epub3_c012_r1.md"     # 第12章
    "Karp_9780593798706_epub3_c013_r1.md"     # 第13章
    "Karp_9780593798706_epub3_c014_r1.md"     # 第14章
    "Karp_9780593798706_epub3_c015_r1.md"     # 第15章
    "Karp_9780593798706_epub3_c016_r1.md"     # 第16章
    "Karp_9780593798706_epub3_c017_r1.md"     # 第17章
    "Karp_9780593798706_epub3_c018_r1.md"     # 第18章
    "Karp_9780593798706_epub3_epi_r1.md"      # 结语
    "Karp_9780593798706_epub3_ack_r1.md"      # 致谢
    "Karp_9780593798706_epub3_bib_r1.md"      # 参考文献
    "Karp_9780593798706_epub3_ata_r1.md"      # 关于作者
    "Karp_9780593798706_epub3_cre_r1.md"      # 版权信息
    "Karp_9780593798706_epub3_fsq_r1.md"      # 更多阅读
    "Karp_9780593798706_epub3_loi_r1.md"      # 插图列表
)

# 清理临时文件
rm -f "$temp_file"

# 检查并合并文件
echo "合并Markdown文件..."
missing_files=0
for file in "${files_order[@]}"; do
    if [ -f "$zh_dir/$file" ]; then
        echo "添加文件: $file"
        # 添加页面分隔符
        echo -e "\n\\newpage\n" >> "$temp_file"
        cat "$zh_dir/$file" >> "$temp_file"
        echo -e "\n" >> "$temp_file"
    else
        echo "警告: 文件不存在 - $file"
        ((missing_files++))
    fi
done

if [ $missing_files -gt 0 ]; then
    echo "警告: 有 $missing_files 个文件缺失"
fi

# 检查是否有合并的内容
if [ ! -s "$temp_file" ]; then
    echo "错误: 没有找到任何可用的markdown文件"
    exit 1
fi

echo "文件合并完成，开始生成电子书..."

# 生成PDF
echo "生成PDF..."
pandoc "$temp_file" \
    --from markdown \
    --to pdf \
    --pdf-engine=xelatex \
    --variable mainfont="DejaVu Sans" \
    --variable CJKmainfont="Noto Sans CJK SC" \
    --variable geometry:margin=2cm \
    --variable documentclass=book \
    --variable papersize=a4 \
    --variable fontsize=11pt \
    --toc \
    --toc-depth=2 \
    --metadata title="科技共和国" \
    --metadata author="Alex Karp, Nils Gilman" \
    --metadata subject="技术与政治" \
    --metadata keywords="科技,政治,硅谷,人工智能" \
    --output "$output_dir/${output_name}.pdf" \
    2>&1

if [ $? -eq 0 ]; then
    echo "PDF生成成功: $output_dir/${output_name}.pdf"
else
    echo "PDF生成失败"
fi

# 生成EPUB
echo "生成EPUB..."
pandoc "$temp_file" \
    --from markdown \
    --to epub \
    --toc \
    --toc-depth=2 \
    --metadata title="科技共和国" \
    --metadata author="Alex Karp, Nils Gilman" \
    --metadata language=zh-CN \
    --metadata subject="技术与政治" \
    --metadata description="关于技术、政府与未来的思考" \
    --output "$output_dir/${output_name}.epub" \
    2>&1

if [ $? -eq 0 ]; then
    echo "EPUB生成成功: $output_dir/${output_name}.epub"
else
    echo "EPUB生成失败"
fi

# 生成HTML
echo "生成HTML..."
pandoc "$temp_file" \
    --from markdown \
    --to html5 \
    --standalone \
    --toc \
    --toc-depth=2 \
    --css style.css \
    --metadata title="科技共和国" \
    --metadata author="Alex Karp, Nils Gilman" \
    --output "$output_dir/${output_name}.html" \
    2>&1

if [ $? -eq 0 ]; then
    echo "HTML生成成功: $output_dir/${output_name}.html"
else
    echo "HTML生成失败"
fi

# 清理临时文件
rm -f "$temp_file"

echo "电子书编译完成！"
echo "输出文件位于: $output_dir/"
ls -la "$output_dir/"
