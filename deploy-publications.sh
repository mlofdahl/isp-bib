#!/bin/bash
# ====================================================================
# Script to build Publication Database locally and push to gh-pages
# ====================================================================

# 1. Clear out any old HTML files from the temporary deployment folder
rm -rf out-html
mkdir -p out-html

# 2. Run your local IDL program using idl86
idl86 -e ".r bib2html"

# 3. Safety check: Ensure the program actually generated the main file
if [ ! -f "svst-publications.html" ]; then
    echo "Error: svst-publications.html was not found in the root directory. Aborting."
    exit 1
fi

# 4. Copy the generated main file and rename it to index.html for GitHub Pages
cp svst-publications.html out-html/index.html

# 5. NEW: Also copy the entire bibitems/ folder into the deployment directory
#    The -r flag ensures all subfolders and individual files follow along
if [ -d "bibitems" ]; then
    cp -r bibitems out-html/
else
    echo "Warning: bibitems/ directory was not found!"
fi

# 6. Jump into the deployment folder
pushd out-html > /dev/null

# 7. Initialize a clean, isolated Git space and target gh-pages
git init
git checkout -b gh-pages

# 8. Commit the fresh HTML files and bibitems locally
git add .
git commit -m "Automated local publication database update with bibitems"

# 9. Force-push the files directly to the hidden gh-pages branch
git push -f git@github.com:ISP-SST/publications.git gh-pages

# 10. Jump back to your project root folder and delete the local deployment folder
popd > /dev/null
rm -rf out-html

echo ""
echo "Your publication database and bibitems have been pushed to GitHub Pages."
