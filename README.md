ink
========

A shell script that serves as a crude CMS for Octopress blogs. 

v 0.3


### Installation (as of v 0.3)

**Recommend you read through the code first** 

To install ink v 0.3, 

1. Clone this Git repo. I’d recommend cloning it somewhere in your “code” directory. Inside you’ll find a .sh file and a README. 
2. Open the ink.sh file in a text editor like Sublime. On line 9, put in the path to your Octopress directory (user.github.io). Then verify that line 17 is the correct path from your github.io directory to your posts. 
3. Now navigate to your user.github.io directory in your terminal. If you run ```git branch``` you should see two branches: “source” and “master”. Create a new branch called “drafts” by typing ```git branch drafts```. Do NOT checkout the new “drafts” branch, just create it. Keep “source” checked out.  
4. Next, you’ll want to put a function in your bash profile so you can call ink from anywhere in your terminal. To open your bash profile, run the following in your command line: ```open ~/.bash_profile```. Paste in this function in the top level:
```
function ink { bash /Users/$USER/Documents/code/ink/ink.sh "$1" }
```
Close and reopen your terminal. You should now be able to call ```ink``` from anywhere in your terminal to run ink.


### Use

From anywhere in the terminal, user can call ```$ ink “blog post title”```.

Then user’s default editor launches. The user writes his or her post, saves it, closes the editor. 

User should return to the open terminal window and user will find a menu with three choices: publish, delete, and quit. 

**Publish** adds, commits, and pushes the user’s Git up to GitHub, then deploys your Octopress blog. Here’s the Bash code:

``` bash
  git add .
  git commit -m  "Used ink to publish a new post called "$FILENAME"." 
  git push origin source
  rake generate
  rake deploy 
```
and then takes you back to the directory from which you called ```ink```.

**Save** moves the file to the users’ “drafts” branch and stores it there. This way publishing the blog through the rake commands does NOT publish the drafts. Users can access their save drafts by entering ```ink “drafts”``` from anywhere in the terminal. 

**Delete** removes the file of the post you just created. It also removes it from the source branch of your local Git repo commits it, and pushes to your remote source branch with ```git push origin source```. It then returns the user to the directory from which they originally called ```ink```.

**Quit** just returns user to the directory from which they originally called ```ink```. It leaves the Git not added, not pushed, and not pushed. It also does not run ```rake generate``` or ```rake deploy```.