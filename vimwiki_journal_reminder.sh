#!/bin/bash

## A Vimwiki Journal Reminder:
# Display options to the user via pop-up terminal window
# User will be prompted to decide how to input their entry:
# 1) Open up Vim 
# 2) Abort journal update
# 3) Input entry from terminal window

## Note:
# Make sure to set the setting "Close if the shell exited cleanly"
# in Terminal > Preferences > Shell > When the shell exits.
# Otherwise you might be hitting CTRL-W and ENTER a lot...


## Designate your journal folder location
JOURNALDIR="/Users/organized/Documents/wiki/diary"    

attempts=3 # The number of attempts a user is allowed before process exits

DATE=$(date +"%Y-%m-%d")
CURJOURNAL="$DATE.wiki"
TIME=$(date +"%H:%M")
TEMPDATE="= $DATE ="          # formats date as h1 vimwiki link
TEMPTIME="\n== $TIME =="        # formats timestamp as h2 vimwiki link

## Update the time in the most current journal files
function update_journal_date
{
  ## Check if directory exists
  if [ ! -d $JOURNALDIR ]
    then
      echo "$JOURNALDIR does not exist."
      echo "Check your settings."
      exit 1
  fi

  ## Check for current journal file for day
  if [ -f $JOURNALDIR/$CURJOURNAL ]
    then
      # Append to journal file
      echo -e "$TEMPTIME" >> "$JOURNALDIR/$CURJOURNAL"
    else
      # Create journal file
      touch $JOURNALDIR/$CURJOURNAL
      echo "Created $JOURNALDIR/$CURJOURNAL"
      echo "$TEMPDATE" > "$JOURNALDIR/$CURJOURNAL"
      echo -e "$TEMPTIME" >> "$JOURNALDIR/$CURJOURNAL"
  fi
}

## Update the journal file with tempentry
function update_journal_entry
{
  echo "Note to self: "
  secs=240

  while [ $secs -gt 0 ] && [ -z "${TEMPENTRY+set}" ]; do
    read -t 1 TEMPENTRY
    : $((secs--)) # subtract one sec from timer
  done

  if [ -z "${TEMPENTRY+set}" ]
    then
      echo "Response not received in time."
    else
      echo "$TEMPENTRY" >> "$JOURNALDIR/$CURJOURNAL"
      echo "Time stamp and journal updated."
  fi
}

## Clean up and exit
function clean_up
{
  echo "Happy Journaling!"

  secs=5
  while [ $secs -gt 0 ]; do
    echo -ne "Closing in $secs\033[0K\r"
    sleep 1
    : $((secs--))
  done

  exit 0
}

## Display options to the user
function display_options
{
  echo -e "===========================\n$DATE $TIME\nTime to update the journal.\n*What HAVE you been up to?*\n==========================="
  echo "1) Open vim to input your journal entry"
  echo "2) Ignore this update"
  echo "3) Or, just enter your update here."
}

## Get the selected option
function get_selection
{
  secs=60

  while [ $secs -gt 0 ] && [ -z "${OPTIONSELECTED+set}" ]; do
    read -t 1 OPTIONSELECTED # look for user input for one second 
    : $((secs--)) # subtract one sec from timer
  done

  # Count number of attempts by the user
  if [ $attempts -eq 1 ]; then
    echo "Error understanding input, or no response."
    echo "Try again later."
    exit 1
  fi

  process_selection
}

## Process option according to user selection
function process_selection
{
  case $OPTIONSELECTED in
    # Open vim to input your journal entry, place cursor at EOF,
    # insert new line, and start in 'insert mode'
    1) 
      update_journal_date
      echo "Opening vim for editing..."
      vim '+normal Go' +startinsert $JOURNALDIR/$CURJOURNAL
      echo "Vim process complete." 
      ;;
    # Close terminal
    2) 
      echo "Canceling journal update."
      ;;
    # Prompt user to write note
    # Timeout if no response is received
    3) 
      update_journal_date
      update_journal_entry
      ;;
    *)
      echo "Option not recognized. Try again."
      unset OPTIONSELECTED    # Clear var
      : $((attempts--))
      get_selection           # GOTO 10, err, go back and try again
      ;;
  esac
}

display_options
get_selection
clean_up  
