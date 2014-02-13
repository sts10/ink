# ink

# https://github.com/sts10/ink


  INPUT="$1"

  POST_TITLE="$2"
  

  cd /Users/$USER/Documents/code/sts10.github.io 

  FILENAME="placeholder"
  
  open_file_name() {
    FILENAME=$1
    open $FILENAME

    clear 
   
    echo "I just opened a file called "$FILENAME" for you! Go write an awesome post!"

    echo ''
    echo "Once you've saved the file of your new post, here are your options:"
    echo ''
    echo "p - publish your octopress blog and commit and push your source branch to GitHub"
    echo 's - save this post as a draft. Drafts are accessible by entering ink "drafts" on the command line.'
    echo "d - delete the post you just wrote, and remove it from the source branch of your local Git repo"
    echo "q - quit without doing either of the above"
    echo ''


    read -p "" -n 1 -r  
    echo ''  

    git checkout source

    if [[ $REPLY =~ ^[Pp]$ ]]    # if [[ $REPLY =~ ^[Yy]$ ]]
    then
        # commit git and publish blog
        
        cd ../../
        
        
        git add .
        git commit -m  "Used ink to publish a new post called "$FILENAME"." # $FILENAME ?

        git push origin source
        rake generate
        rake deploy 

 

    elif [[ $REPLY =~ ^[Dd]$ ]]
    then 
        echo ''
        echo "Are you sure you want to delete "$FILENAME"? (y/n) "
        read REPLY2 
        if [[ $REPLY2 =~ ^[Yy]$ ]]
        then
          rm $FILENAME
          git add --all .
          git commit -m "Deleted post "$FILENAME" using ink."
          git push origin source
          echo ''
          echo "Deleted "$FILENAME", removed it from Git, and committed and pushed Git"  
          # cd $cwd
        else
          echo "OK, we'll just leave it in your _posts folder."
          cd ../../
        fi
    elif [[ $REPLY =~ ^[Ss]$ ]]
    then 

      cd ../../

      git add .
      git commit -m "add draft to source branch temporarily"

      git checkout drafts

      if [ ! -f source/_posts/$FILENAME ]  #if this IS a new draft
      then
        echo "Saving new draft!"

        touch source/_posts/$FILENAME
        
      fi 

      git add .
        git commit -m "add blank"


      git checkout source -- source/_posts/$FILENAME  # move the file I'm working on to drafts

      git add .
      git commit -m "add draft "$FILENAME" to drafts branch."


      # clean up the source branch

      git checkout source

      cd source/_posts

      rm $FILENAME
          git add --all .
          git commit -m "Moved post "$FILENAME" to drafts branch and remove from source branch."
          git push origin source

      cd ../../

    else
      echo "OK, we'll just leave this post in your source/_posts directory, unstaged."
      cd ../../  # return to main octopress directory  

    fi

    return 

  }

  load_drafts(){
    git checkout drafts

     cd source/_posts/


    FILENAME="q"

    PS3="Type a number or 'q' to quit: "
  
    # Create a list of files to display  http://wuhrr.wordpress.com/2009/09/10/simple-menu-with-bashs-select-command/
    fileList=$(find . -maxdepth 1 -type f \( ! -iname ".*" \))  # ignores dot files like .DS_STORE 

    

    # Show a menu and ask for input. 
    select draftFileName in $fileList; do
        if [ -n "$draftFileName" ]; then
            FILENAME=${draftFileName}
        fi
        break
    done


  

    if [[ $FILENAME == "q" ]]
    then
      echo ''
      echo "Sorry, I don't have that draft. Goodbye."
      git checkout source 
      exit 
    fi


    if [ ! -f $FILENAME ]  # if user entry does not match an existing draft file name. 
    then
      echo ''
      echo "Sorry, I don't have that draft. Goodbye."
      git checkout source 
      # cd $cwd
      exit 
    fi

    # move $FILENAME from drafts to source, assuming we'll publish it
    git checkout source
    git checkout drafts -- $FILENAME  # get draft from drafts branch, put in source branch

      # commit changes to source branch 
      git add . 
      git commit -m "move your selected draft to source branch"


    # (temporarily) delete $FILENAME from the drafts branch
    git checkout drafts
      rm $FILENAME
      git add --all . 
      git commit -m "move your selected draft to source branch"

    git checkout source 
  }


  # Now start program



  if [[ $INPUT == "drafts" ]]
  then
    load_drafts

    open_file_name "$FILENAME"

  elif [[ $INPUT == "publish" ]]
  then 
    publish_blog

  elif [[ $INPUT == "help" ]]
  then
    echo "some help"

  elif [[ $INPUT == "menu" ]]
  then
    echo "loading menu"
 
  elif [[ $INPUT == "" ]]
  then
    echo "loading menu"
 
  else # if [[ $INPUT == "new" ]]
  # then
    rake new_post["$INPUT"]
    echo "Creating new octopress post called \""$INPUT"\""

    cd source/_posts
    FILENAME=`ls -t | head -1`
    open_file_name "$FILENAME"

  # else
  #   echo "Here's help info"

  fi

  
  # present menu 
  clear

   echo ''
  echo "Welcome to ink v. 0.31"
  echo ''
  echo "n - Open a new post"
  echo "p - publish your octopress blog and commit and push your source branch to GitHub"
  echo "d - load your saved drafts"
  echo "r - preview your Octopress blog"
  echo "h - help"
  echo "q - quit without doing any of the above"
  echo ''
  read -p "" -n 1 -r  
    echo ''  

  if [[ $REPLY == "d" ]]
  then
    load_drafts

    open_file_name "$FILENAME"

  elif [[ $REPLY == "n" ]]
  then
    rake new_post # ["$INPUT"]
    echo "Creating new octopress post called \""$INPUT"\""

    cd source/_posts
    FILENAME=`ls -t | head -1`
    open_file_name "$FILENAME"


  elif [[ $REPLY == "p" ]]
  then 
    publish_blog

  elif [[ $REPLY == "h" ]]
  then
    echo "some help"

  elif [[ $REPLY == "r" ]]
  then
    echo "loading preview"
    rake preview
 
  elif [[ $REPLY == "q" ]]
  then
    echo "Goodbye"
 
  fi

