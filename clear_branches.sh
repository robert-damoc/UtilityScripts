# PATH_TO_SCRIPT=/usr/local/bin/
PATH_TO_SCRIPT=./

SCRIPT_NAME=clear_branches
touch $PATH_TO_SCRIPT$SCRIPT_NAME
chmod +x $PATH_TO_SCRIPT$SCRIPT_NAME

function read_bucket_name {
  echo -e -n "\n\033[33mEnter a bucket name for the CA: \033[0m"
  read BUCKET_NAME
  aws s3 ls s3://$BUCKET_NAME > /dev/null
  if [ -z "$BUCKET_NAME" -o $? -ne 0 ]; then
    echo -e "\n\033[31mInvalid bucket name\033[0m\n"
    echo -e "\033[94mAvailable buckets:\033[0m"
    aws s3 ls | awk '{print $3}'
    echo
    exit
  fi
}

cat << CLEAN_BRANCHES_SCRIPT > $PATH_TO_SCRIPT$SCRIPT_NAME
#! /bin/sh

function containsElement () {
  local e match="\$1"
  shift
  for e; do [[ "\$e" == "\$match" ]] && return 0; done
  return 1
}

if ! [[ \$(git rev-parse --is-inside-work-tree 2>/dev/null) ]]; then
  echo "\033[31mYou are not inside a git repository\033[0m"
  exit 1
fi

keep=("develop" "master")
for branch in "\$@"; do
  keep+=("\$branch")
done

echo "\033[33mThe branches you want to keep are:\033[0m"
for branch in \${keep[@]}; do
  echo "  \$branch"
done
echo "Do you want to continue?[Yy]"
read -n 1 -r
echo
[[ \$REPLY =~ ^[Yy]$ ]] || exit

for branch in \$(git branch | cut -c 3-); do
  containsElement \$(echo \$br | tr -d [:space:]) \${keep[@]}
  if [ \$? -ne 0 ]; then
    git branch -D \$branch
  fi
done
CLEAN_BRANCHES_SCRIPT
