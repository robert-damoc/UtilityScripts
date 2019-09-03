PATH_TO_SCRIPT=/usr/local/bin/
# PATH_TO_SCRIPT=./
SCRIPT_NAME=omoara

touch $PATH_TO_SCRIPT$SCRIPT_NAME
chmod +x $PATH_TO_SCRIPT$SCRIPT_NAME

cat << OMOARA_PROCESS_SCRIPT > $PATH_TO_SCRIPT$SCRIPT_NAME
#! /bin/sh

if ! [[ \$1 =~ ^[1-9][0-9]*$ ]]; then
  echo "\033[31merror: PORT is not a number\033[0m"
  echo "\033[33mSyntax: \$0 <PORT>\033[0m"
  exit 1
fi

lsof -i :\$1 >> /dev/null
if [ \$? -eq 0 ]; then
  kill \$(lsof -i :\$1 | awk '{ print \$2 }' | uniq) &> /dev/null
  echo "\033[32mDone!\033[0m"
fi
OMOARA_PROCESS_SCRIPT

echo "\033[32mScript created under $PATH_TO_SCRIPT$SCRIPT_NAME"
echo "Syntax: $SCRIPT_NAME <PORT>\033[0m"
