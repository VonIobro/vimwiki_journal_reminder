# Vimwiki Journal Reminder
A simple Bash script to remind you to update your journal.

I was inspired by [Mark Dennehy's post]( http://www.stochasticgeometry.ie/2012/11/23/vimwiki/) about automating a Vimwiki reminder and thought I could build one myself. This script gives the user options about how they want to input their journal entry, or whether they even want to create one. And there are timeouts to automatically close the terminal window if their isn't a response.

## Prerequisites
This script was created for a Mac running OS X 10.11 and Vim with the Vimwiki plugin. The script is fairly generic, though it does require Bash, so some simple modifications may work for your build. As cron is deprecated on Mac, a LaunchD plist file was created for scheduling.

## Installation

### Configure the Bash Script
Inside the vimwiki_journal_reminder.sh file is a $JOURNALDIR variable for the location of your wiki diary folder. Make sure to set that. 

Also, you can play with the time-out settings. I have it set to exit the terminal if:
  * no option is selected after 60 seconds
  * when selecting option 3) terminal screen input, no text is submitted after 4 minutes

### Set up the Bash Script
1. Copy the Bash script to your ~/bin folder:
  * cp vimwiki_journal_reminder.sh ~/bin
2. Make sure the file is executable:
  * chmod 700 vimwiki_journal_reminder.sh
  * cd ~/bin
  * ./vimwiki_journal_reminder.sh

The last command will run the script and you can verify that is working and setup correctly.

### Set up the LaunchD Scheduler
1. Copy the plist file to your LaunchAgents folder: 
  * cp local.vimwiki_journal_reminder.plist ~/Library/LaunchAgents/local.vimwiki_journal_reminder.plist
2. Load the new plist file with launchctl:
  * launchctl load ~/Library/LaunchAgents/local.vimwiki_journal_reminder.plist
3. Start the plist file with launchctl:
  * launchctl start ~/Library/LaunchAgents/local.vimwiki_journal_reminder

From this point on, the plist will launch every time you start your computer. The scheduler runs the Bash script every 30 minutes.

## Tips
Make sure to set the setting "Close if the shell exited cleanly" in Terminal > Preferences > Shell > When the shell exits. Otherwise you might be hitting CTRL-W and ENTER a lot...

# Future Improvements
When the program times-out because of no input, it can be assumed that the user is away from their keyboard. However, they probably still have access to email. In that situation, it would be useful to send an email to the user. And they could respond to the email which would then update the journal on the local machine... 
