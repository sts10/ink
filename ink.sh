#!/bin/bash

# ink
# https://github.com/sts10/ink

  BLOG_DIRECTORY="/Users/$USER/Documents/code/sts10.github.io"
  

  cd $BLOG_DIRECTORY


  INPUT="$1"

  # POST_TITLE="$2"
  
  FILENAME="placeholder"

  DRAFT_CAPABLE=0

  initialize_draft() {
    
    cd $BLOG_DIRECTORY

    if [[ $(git branch | grep 'ink_drafts') == "" ]]
    then 

      echo "Welcome to ink! It looks like you don't have a ink_drafts Git branch set up yet."
      echo "This will let ink save drafts for you to load later."
      echo "May I make one for you now? (y/n)"
      read REPLY3 
      if [[ $REPLY3 =~ ^[Yy]$ ]]
      then

        echo "Need to create an ink_drafts branch"
        git checkout -b ink_drafts
        git checkout ink_drafts

        cd source/_posts
        # echo "I'd delete all these files"
        
        # git branch
        
        git rm * # removes duplicated published posts carried over from checkout

        touch "saved_drafts_will_go_here.md"
        git add .
        git commit -m "Removed duplicates of published posts moved to ink_drafts branch automatically."
        DRAFT_CAPABLE=1
      else 
        echo "OK, you can either create the branch in "$BLOG_DIRECTORY" yourself, or not use ink's"
        echo "draft-saving functionality."
        DRAFT_CAPABLE=0
      fi

      # get back to source. 

      git checkout source
    else 
      echo 'You have an ink_drafts branch already. Awesome.'
      DRAFT_CAPABLE=1
    fi

    cd $BLOG_DIRECTORY
  }


  initialize_draft
  
  open_file_name() {
    FILENAME=$1
    $EDITOR $FILENAME

    clear 
   
    echo "I just opened a file called "$FILENAME" for you! Go write an awesome post -- I'll wait!"

    echo ''
    echo "Once you've saved the file of your new post, here are your options:"
    echo ''
    echo "p - publish your Octopress blog and push to GitHub"
    if [[ $DRAFT_CAPABLE == 1 ]]
    then
    echo 's - save this post as a draft.'
    fi 
    echo "x - delete the post you just wrote, and remove it from your local Git repo"
    echo "q - quit without doing either of the above"
    echo ''


    read -p "" -n 1 -r  
    echo ''  

    git checkout source

    if [[ $REPLY =~ ^[Pp]$ ]]    # if [[ $REPLY =~ ^[Yy]$ ]]
    then
        # commit git and publish blog
        
        cd $BLOG_DIRECTORY
        
        
        git add .
        git commit -m  "Used ink to publish a new post called "$FILENAME"." # $FILENAME ?

        git push origin source
        rake generate
        rake deploy 

 

    elif [[ $REPLY =~ ^[Xx]$ ]]
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
        else
          echo "Goodbye"
          exit 
          # cd ../../
        fi
    elif [[ $REPLY =~ ^[Ss]$ ]]
    then 

      cd $BLOG_DIRECTORY

      git add .
      git commit -m "add draft to source branch temporarily"

      git checkout ink_drafts

      if [ ! -f source/_posts/$FILENAME ]  #if this IS a new draft
      then
        echo "Saving new draft!"

        touch source/_posts/$FILENAME
        
      fi 

      git add .
        git commit -m "add blank"


      git checkout source -- source/_posts/$FILENAME  # move the file I'm working on to ink_drafts

      git add .
      git commit -m "add draft "$FILENAME" to ink_drafts branch."


      # clean up the source branch

      git checkout source

      cd source/_posts

      rm $FILENAME
          git add --all .
          git commit -m "Moved post "$FILENAME" to ink_drafts branch and remove from source branch."
          git push origin source

      cd $BLOG_DIRECTORY

    else
      echo "OK, we'll just leave this post in your source/_posts directory, unstaged."
     

    fi

    return 

  }


  open_existing_posts(){
    $EDITOR source/_posts

    clear
    echo "All done? Do you want to..."
    echo "p - publish blog with your edits"
    echo "q - quit without publishing"

    read -p "" -n 1 -r  
    echo ''  

    git checkout source

    if [[ $REPLY =~ ^[Pp]$ ]]
    then
      echo "Publishing blog with edits"
      publish_blog
    else
      echo "Quitting"
    fi
      

  }

  load_ink_drafts(){
    git checkout --quiet ink_drafts

    cd source/_posts/


    echo ''
    echo 'Here are your saved drafts:'
    echo ''

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
      echo "Quitting..."
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

    # move $FILENAME from ink_drafts to source, assuming we'll publish it
    git checkout source
    git checkout ink_drafts -- $FILENAME  # get draft from ink_drafts branch, put in source branch

      # commit changes to source branch 
      git add . 
      git commit -m "move your selected draft to source branch"


    # (temporarily) delete $FILENAME from the ink_drafts branch
    git checkout ink_drafts
      rm $FILENAME
      git add --all . 
      git commit -m "move your selected draft to source branch"

    git checkout source 
  }


  publish_blog() {
    bundle install
    git add --all .
    git commit -m  "Used ink to publish a new post called "$FILENAME"."  

    git push origin source
    rake generate
    rake deploy 
  }


  # Now start program



  if [[ $INPUT == "drafts" ]]
  then
    load_ink_drafts

    open_file_name "$FILENAME"

    exit 

  elif [[ $INPUT == "publish" ]]
  then 
    publish_blog
    exit 
  elif [[ $INPUT == "help" ]]
  then
    echo "some help"

  elif [[ $INPUT == "menu" ]]
  then
    echo "loading menu"
 
  elif [[ $INPUT == "" ]]
  then
    echo "loading menu"
 
  elif [[ $INPUT == ""*"" ]]
  then
    rake new_post["$INPUT"]
    echo "Creating new octopress post called \""$INPUT"\""

    cd source/_posts
    FILENAME=`ls -t | head -1`
    open_file_name "$FILENAME"
    exit 

  fi

  
  # present menu 
  clear
  echo ''
  echo "Welcome to ink v. 0.0.4"
  echo ''
  echo "n - Open a new post"
  echo "e - Open all your existing posts"
  echo "p - publish your Octopress blog and push to GitHub"
  if [[ $DRAFT_CAPABLE == 1 ]]
    then
  echo "d - load your saved drafts"
  fi
  echo "r - preview your Octopress blog"
  echo "h - help"
  echo "q - quit without doing any of the above"
  echo ''
  read -p "" -n 1 -r  
    echo ''  

  if [[ $REPLY == "d" ]]
  then
    load_ink_drafts

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
    echo "Please refer to https://github.com/sts10/ink for more information"

  elif [[ $REPLY == "e" ]]
  then 
    open_existing_posts

  elif [[ $REPLY == "r" ]]
  then
    echo "loading preview"
    rake preview
 
  elif [[ $REPLY == "q" ]]
  then
    echo "Goodbye"
 
  fi

