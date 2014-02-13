global="heyo"

call_my_name (){
  FILENAME=$1
  echo $FILENAME
  global="affected"
  # echo $*
}

NAME="Bob"

call_my_name "$NAME" "number two"

call_my_name "Tony"

echo $global