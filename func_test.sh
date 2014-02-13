
DIRECTORY="/Users/$USER/Documents/code/test"
  cd $DIRECTORY

# echo $(git branch | grep 'dev')

if [[ $(git branch | grep 'master') == "" ]]
then 
  echo "no branch by that name here"
else 
  echo 'yeah we got one of those already'
fi

# global="heyo"

# call_my_name (){
#   FILENAME=$1
#   echo $FILENAME
#   global="affected"
#   # echo $*
# }

# NAME="Bob"

# call_my_name "$NAME" "number two"

# call_my_name "Tony"

# echo $global