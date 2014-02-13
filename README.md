ink
========

A shell script that serves as a crude CMS for Octopress blogs. 

v 0.0.4


### Installation (as of v 0.0.4)

**Recommend you read through the code first** 

To install ink v 0.0.4, 

1. Download or clone this Git repo. I’d recommend saving/cloning it somewhere in your “code” directory, but it doesn't really matter where you put it. Inside you’ll find a .sh file and a README. 
2. Open the ink.sh file in a text editor like Sublime. On line 5, for the variable BLOG_DIRECTORY, replace my path with the path to your Octopress directory (user.github.io). Then verify that line 37 is the correct path from your github.io directory to your posts (it probably is). 
3. Next, you’ll want to put a function in your bash profile so you can call ink from anywhere in your terminal. To open your bash profile, run the following in your command line: ```open ~/.bash_profile```. Paste in this function in the top level:
```
function ink { bash /Users/$USER/Documents/code/ink/ink.sh "$1" }
```
Close and reopen your terminal. You should now be able to call ```ink``` from anywhere in your terminal to run ink. On the first run, it should ask you for permission to create an "ink_drafts" Git branch. If you'd like ink to be able to save drafts, type "y". If you say yes you won't be asked again. 

### Warnings

It should be noted that version 0.0.4 includes a ```git rm *``` command. This command is only run on the “ink_drafts” Git branch that the script itself creates, and it is only run on the initial setup of the branch, after the script detects that the user has not already created an “ink_drafts” branch. If you have concerns, please read through the ink.sh file. 

### Use

From anywhere in the terminal, user can call ```$ ink ``` to access ink's main menu. As a shortcut, user's can create a new post by typing: ```$ ink “blog post title”``` in the terminal.

Once a user opens a new post, their default text/markdown editor launches. The user should then write his or her post, save it, and exit the editor. 

The user should then immediately return to the open terminal window, where the user will find a menu with the following choices: publish, save, delete, and quit. 

**Publish** adds, commits, and pushes the user’s Git up to GitHub, then deploys your Octopress blog. Here’s the Bash code:

``` bash
  git add .
  git commit -m  "Used ink to publish a new post called "$FILENAME"." 
  git push origin source
  rake generate
  rake deploy 
```
and then takes you back to the directory from which you called ```ink```.

**Save** moves the file to the users’ “ink_drafts” branch and stores it there. This way publishing the blog through the rake commands does NOT publish the drafts. Users can access their save drafts by entering ```ink “drafts”``` from anywhere in the terminal. 

**Delete** removes the file of the post you just created. It also removes it from the source branch of your local Git repo commits it, and pushes to your remote source branch with ```git push origin source```. It then returns the user to the directory from which they originally called ```ink```.

**Quit** just returns user to the directory from which they originally called ```ink```. It leaves the Git not added, not pushed, and not pushed. It also does not run ```rake generate``` or ```rake deploy```.