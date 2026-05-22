#!/bin/bash
set -euo pipefail

echo "==> Building the latest .deb package..."
dpkg-deb --root-owner-group --build catdir-pkg catdir_1.0.0_all.deb

echo "==> Setting up apt repository structure..."
mkdir -p dists/stable/main/binary-amd64
mkdir -p dists/stable/main/binary-all
mkdir -p pool/main

mv catdir_1.0.0_all.deb pool/main/

echo "==> Generating Packages index..."
dpkg-scanpackages --multiversion pool/main > dists/stable/main/binary-all/Packages
gzip -9k -f dists/stable/main/binary-all/Packages

cd dists/stable/main/
ln -sf ../binary-all/Packages binary-amd64/Packages
ln -sf ../binary-all/Packages.gz binary-amd64/Packages.gz
cd -

echo "==> Generating Release file..."
cd dists/stable
apt-ftparchive release . > Release
cd -

echo "==> Apt repository update complete!"
