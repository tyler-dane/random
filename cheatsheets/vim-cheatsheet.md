# VIM CHEATSHEET

## Getting Help
```bash    
:help           #Opens VIM help window in terminal
CTRL-W CTRL-W   #Jump from help window
CTRL-J          #Jump
CTRL-T CTRL-O   #Return to previous location
F1              #Opens OS help window
```
## Common Tasks
```bash
A       #Appends cursor to end of line and enters insert mode
dw      #Deletes word
d$      #Deletes to end of line
de      #Deletes to end of current word 
dd      #Deletes entire line
2w      #Moves cursor 2 words forward
3e      #Moves cursor to end of third word forward
0       #Moves cursor to start of line
p       #Puts previously deleted text below the cursor
r{x}    #Replaces text with the letter after r
R       #Replaces more than one character, entering you into Insert Mode
ce      #Changes until end of a word and enter Insert Mode. This is a better option than d[motion] when you want to insert text
c$      #Changes until end of line
o ; O   #Opens below, above -- enters you into Insert Mode
a       #Insert text AFTER the cursor

u       #Undo previous command
CTL-r   #Re-do prevoius command

CTL-G   #Shows location in the file and file status
G       #Moves cursor to bottom of file
gg      #Moves cursor to top of file
{#}G    #Moves cursor to the given line number
:{#}    #Moves cursor to the given line number
y       #Yanks (pastes) text
            EXAMPLE 1:
                yw  #Yanks word
            EXAMPLE 2:
                v       #Enters visual mode
                ARROWS  #Highlights command
                y       #Enters yank mode
                j$      #Moves cursor to end of line (highlighting)
                p       #Puts (pastes) the text
                ESC     #Exits visual mode
```
### Advanced Tasks
```bash
:!                          #Executes external shell command
v {motion} :w FILENAME      #Saves part of the file that you highlighted to current directory
:r FILENAME                 #Retrieves the highlighted text that you previously saved and enter it into current VIM session
:r !COMMAND [e.g. `:r !ls]  #Reads the output of an external command in the VIM session. Useful for log review.
m(x)                        #Marks point in file, where (x) is any lowercase character
`(x)                        #Returns to the exact mark point
'(x)                        #Returns to the beginning of the mark point's line
```
### Searching
```bash
/{search}          #Searches for results in file
    n                  #Cycles forward through results
    N                  #Cycles backwards through results
%                  #When cursor is over a (, [, or {, this finds the matching closing symbol.
```
### History
:his                    # Print history
:<up/down arrow>        # Scroll through history
### Substitution
```bash
:s/old/new/g        #Substitutes 'old' for 'new' in current line only
:s/old/new/gc       #Globally substitutes 'old' for 'new', prompting for confirmation for each substitution
:%s/old/new/g       #Globally substitutes 'old' for 'new' without prompting for confirmation
:#,#s/old/new/g     #Substitutes 'old' for 'new', where #,# are the line numbers of the range of lines to substitute  
```
### Ignoring Case
```bash
EXAMPLE 1:      
    /ignore\c       #Searches for 'ignore' and ignores case
EXAMPLE 2:
    /ignore         #Searches for 'ignore'
    :set ic         #Sets 'ignore case' option
    :set hls is     #Sets hlsearch in search options
    /ignore         #Type command again for new options to take effect
    :set noic       #Disables ignoring case again
    :nohls          #Disables highlighting
```
### Commenting Out Blocks of Text:
```bash	
ESC
CTRL+v (visual block mode)
up/down arrow
SHIFT + I   # You should be directed to the beginning of the visual block and enter INSERT MODE
#           # This will insert a hashtag (#) for each of the highlighted lines
ESC
```
### Uncommenting Blocks of Text:
```bash
ESC
CTRL + v 	#Enters visual block mode
(up/down arrow to select lines to uncomment)
x       	#Deletes comments
ESC         #Exits visual block mode
```

### Column Edit Mode
- `CTRL + V` to enter Column Mode
- Select columns and rows you want to edit
- `SHIFT + i` to enter Column Insert Mode
- Type in or delete text you want to change
            - Only the first row will be changed at this step
- `Esc` to apply changes
