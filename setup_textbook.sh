#!/bin/bash

# ==============================================================================
# MkDocs Textbook Structure Initializer
# ==============================================================================
# This script sets up the directory and file structure for the
# "Real-Time Simulation Modeling for Digital Twins" textbook.
#
# USAGE:
# 1. Save this script as 'setup_textbook.sh' in your project's root folder.
# 2. Open your terminal and run: chmod +x setup_textbook.sh
# 3. Then execute it with:      ./setup_textbook.sh
# ==============================================================================

# --- Safety Check ---
# Ensure the script is being run from a directory containing 'mkdocs.yml'
if [ ! -f "mkdocs.yml" ]; then
  echo "Error: 'mkdocs.yml' not found in the current directory."
  echo "Please run this script from the root of your MkDocs project."
  exit 1
fi

echo "🚀 Initializing textbook structure..."
echo "-------------------------------------"

# --- 1. Create Core Directories ---
echo "-> Creating directories (parts, appendix, assets, javascripts)..."
mkdir -p docs/part1
mkdir -p docs/part2
mkdir -p docs/part3
mkdir -p docs/part4
mkdir -p docs/part5
mkdir -p docs/appendix
mkdir -p docs/assets
mkdir -p docs/javascripts
echo "   ✅ Directories created."
echo ""

# --- 2. Create Markdown Files with Placeholder Titles ---
# This makes it easy to identify and start editing the right chapter.
echo "-> Creating Markdown files for each chapter..."

# Homepage
echo '# Real-Time Simulation Modeling for Digital Twins' > docs/index.md
echo '' >> docs/index.md
echo 'Welcome to the online textbook for the graduate course on Real-Time Simulation Modeling for Digital Twins.' >> docs/index.md

# Part I
echo '# Chapter 1: The Digital Twin Paradigm' > docs/part1/chapter01.md
echo '# Chapter 2: Simulation as the Core Engine' > docs/part1/chapter02.md
echo '# Chapter 3: A Methodological Survey' > docs/part1/chapter03.md

# Part II
echo '# Chapter 4: Discrete-Event Simulation' > docs/part2/chapter04.md
echo '# Chapter 5: Agent-Based Modeling' > docs/part2/chapter05.md
echo '# Chapter 6: System Dynamics' > docs/part2/chapter06.md
echo '# Chapter 7: Dynamical Systems & Physics-Based Modeling' > docs/part2/chapter07.md

# Part III
echo '# Chapter 8: Real-Time Data Ingestion' > docs/part3/chapter08.md
echo '# Chapter 9: State Synchronization' > docs/part3/chapter09.md
echo '# Chapter 10: Hybrid Simulation' > docs/part3/chapter10.md

# Part IV
echo '# Chapter 11: Continuous Validation & UQ' > docs/part4/chapter11.md
echo '# Chapter 12: Predictive Analysis & What-If' > docs/part4/chapter12.md
echo '# Chapter 13: Optimization and Control' > docs/part4/chapter13.md

# Part V
echo '# Chapter 14: Architectures and Platforms' > docs/part5/chapter14.md
echo '# Chapter 15: The Future of Simulation-Powered DTs' > docs/part5/chapter15.md

# Appendix
echo '# Appendix: Glossary' > docs/appendix/glossary.md
echo '# Appendix: Software Setup Guide' > docs/appendix/setup.md

echo "   ✅ Markdown files created."
echo ""

# --- 3. Create MathJax Configuration File ---
# This enables LaTeX-style math rendering.
echo "-> Creating MathJax configuration file for math support..."

# A "here document" is used to write the multi-line JS content to the file.
cat << 'EOF' > docs/javascripts/mathjax.js
window.MathJax = {
  tex: {
    inlineMath: [["\\(", "\\)"]],
    displayMath: [["\\[", "\\]"]],
    processEscapes: true,
    processEnvironments: true,
  },
  options: {
    ignoreHtmlClass: ".*|",
    processHtmlClass: "arithmatex",
  },
};
EOF
echo "   ✅ 'docs/javascripts/mathjax.js' created."
echo ""

# --- 4. Create Placeholder Asset Files ---
echo "-> Creating placeholder asset files..."
touch docs/assets/favicon.png
touch docs/assets/logo.svg
echo "   ✅ Placeholder assets created. (Replace these with your own files)"
echo ""

# --- Final Message ---
echo "-------------------------------------"
echo "🎉 Success! Your textbook structure is ready."
echo "You can now run 'mkdocs serve' to preview your site and start adding content."