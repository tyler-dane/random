# Bash Cheatsheet 

Shortcuts - Bash
    Notes
        {} = does not apply to Bash

    Ctl+A       Moves cursor to beginning of line (==home) [Opposite Ctrl+E]
    Ctl+B       Backspace (nondestructive)
    Ctl+C       Terminate a foreground job
    Ctl+D       Delete - forward [Opposite Ctrl+B]
    Ctl+D       No command - Log out from a shell (==exit) 
    Ctl+E       Moves cursor to end of line [opposite Ctrl+A]
    Ctl+F       Moves cursor forward [opposite of Ctl+B]
    Ctl+G       Ring OS's bell
    Ctl+H       Delete - backwards [AKA: backspace] [opposite Ctrl+D]
    Ctl+I       {Horizontal tab} [list files]
    Ctl+J       Create new line
    Ctl+K       Deletes from cursor to end of line (opposite of Ctl+U) (==d$ in vim)
    Ctl+L       Clears terminal (==clear) (Formfeed)
    Ctl+P       Recalls commands (==up arrow)
    Ctl+Q       Resume stdin (combine with Ctl+S)
    Ctl+R       Backwards search in history buffer
    Ctl+S       Suspend - freezes stdin (combind w Ctl+Q)
    Ctl+T       Reverses character highlighted in cursor with the character before it
    Ctl+U       Erases from cursor to beginning of line (opposite of Ctl+K)
    Ctl+V       {}
    Ctl+W       Whitespace - Erases backwards to first instance of Whitespace
    Ctl+X       {}
    Ctl+Y       Pastes back previously erased text (combine with Ctl+U & Ctl+W)
    Ctl+Z       Pauses foreground job (e.g. vim session)
                fg %{#} to return to foreground job (vim session)

    
# SCRIPTS: 
## Backups
    Backup of all files changed in last day:
        #!/bin/bash
        # Backs up all files in current directory modified within last 24 hours
        #+ in a "tarball" (tarred and gzipped file).
        BACKUPFILE=backup-$(date +%m-%d-%Y)
        #
        Embeds date in backup filename.
        #
        archive=${1:-$BACKUPFILE}
        # If no backup-archive filename specified on command-line,
        #+ it will default to "backup-MM-DD-YYYY.tar.gz."
        tar cvf - `find . -mtime -1 -type f -print` > $archive.tar
        gzip $archive.tar
        echo "Directory $PWD backed up in archive file \"$archive.tar.gz\"."
        # Stephane Chazelas points out that the above code will fail
        #+ if there are too many files found

## Basic Commands
    memory info:
        cat /proc/meminfo
    ip - show external
        curl
            curl ifconfig.mem
        dig
            dig +short myip.opendns.com @resolver1.opendns.com

## Format
    Change text in a file to uppercase:
        tr 'a-z' 'A-Z'
	    exit 0
        #You could save the above as a script (uppercase.sh) and invoke it with:
            #+ ls-l | ./uppercase.sh
## Jobs
    Kill possibly hanging PID       #substitute 'possibly_handing_job' for PID
        possibly_hanging_job & { sleep ${TIMEOUT}; eval 'kill -9 $!' &> /dev/null; }
            # Forces completion of an ill-behaved program.
            # Useful, for example, in init scripts.

## Logs
    Combine logs into a file:
        	cat {file1,file2,file3} > combined_file


# SYNTAX
Tests       `man test`

    Syntax
        [       bash built-in for 'test'
                considers arguments as comparison expressions/test files
                returns an exit status for the result of the comparison 
                0 is true, 1 is false
        [[..]]  bash built in keyword for an 'extended test command'
                more familiar to other programming languages
                use [[..]] instead of [..] in scritpts to prevent logic errors 
                  like from &&, ||, <, and >
                no filename expansion
                no word splitting
        ((..))  
        let     both used for arithmetic expressions
                return exit status, according to whether the arithmetic expressions
                they evaluabe expand to a non-zero value
                exit status is not an error value with arithmetic expressions
        Note    test == /usr/bin/test == [] == /usr/bin/[
                ^these three are fundamentally equivalent
    Arithmetic Tests
        (())
            (( 5 == 5 ))
            echo "Exit status of \"(( 5 == 5 ))\" is $?." #0 ; true
    Errors - Suppress
        2>/dev/null     # ((1 / 0)) 2>/dev/null
    File test operators - returns true if ...
        -e      | file exists
        -f      | file is a regular file (not a directory/device)
        -s      | file is not zero size
        -d      | file is a directory
        -b      | file is a block device (CDROM drive, flash drives)
        -c      | file is a character device (keyboard, mouse)
        -p      | file is a pipe
        -h      | file is a symbolic link
        -L      | file is a symbolic link
        -S      | file is a socket
        -t      | file is associated with a terminal device
                + may be used to test whether stdin [ -t 0] or stout [ -t 1] 
                + in a script is a terminal
        -r      | file has read permissions (for the user running the test)
        -w      | file has write permissions (for user running test)
        -x      | file has execute permission ( for user running test)
        -g      | set-group-id (sgid) flag set on file/directory 
        -u      | set-user-id (suid) flag set on file 
        -k      | stick bit set 
        -O      | you are the owner of the file
        -G      | group-id of file same as yours
        -N      | file modified since it was last read 
        f1 -nt f2       | f1 is newer than f2 
        f1 -ot f2       | f1 is older than f2
        f1 -ef f2       | files f1 and f2 are hard links to the same file
        !       | "not" -- reverses the sense of the tests above (returns true if condition absent)
    
    Integer comparison operators 
        syntax: if ["$a" -<operator> "$b"] | e.g.: if ["$a" -lt "b"]
        -eq     | is equal to
        -ne     | is not equal to
        -gt     | is greater than
        -ge     | is greater than or equal to
        -lt     | is less than
        -le     | is less than or equal to
        <       | is less than (within double parentheses)
                + (("$a" < "$b"))
        <=      | is less than or equal to (within double parentheses)
        >       | is greater than (within double parentheses)
        >=      | is greater than or equal to (within double parentheses)
    String comparison operators
        =       | is equal to 
                + if [ "$a" = "$b"] (*note the whitespace)
        ==      | is equal to (note: behaves differently than = in [[]])
        !=      | is not equal to 
        <       | is less than, in ASCII alphabetical order
                + if [[ "$a" < "$b"]]
                + if ["$a" \< "$b" ]    (*note that it needs to be escaped within single ()s)
        >       | is greater than, in ASCII alphabetical order 
        -z      | string is null (has zero length)
        -n      | string is not null (*requires string to be quoted within test brackets)
                + always quote a tested string
    Compound comparison
        -a      | logical 'and' [exp1 -a exp2] #returns true if BOTH exp1 and exp2 = true
        -o      | logical 'or'
## Operators
    Assignment:
        =       | all-purpose assignment operator for arithmetic and strings
                + var=27 , category=minerals #no spaces allowed
                + different than the "=" test operator
    Arithmetic operators
        +       | plus
        -       | minus
        *       | multiplication
        /       | division
        **      | exponentiation
        %       | modulo/mod (REMAINDER of a division operation)
                + expr 5 % 3 #2 #5/3 = 1, with remainder 2
        +=      | increment variable by a constant
                + let "var += 5" #results in var being incremented by 5
        -=      | decrement variable by a constant
        *=      | multiply variable by a constant
        /=      | divide variable by a constant
        %=      | remainder of dividing variable by a constant
    Numerical Constants
        Shell scripts interpret numbers as decimals (base 10), unless that number 
        + has a special prefix or notation. Prefixes:
        0   - octal (base 8)
        0x  - hexadecimal (base 16)
        #   - BASE#NUMBER (with base and number between 2 and 64)
            Examples:
                let "bin = 2#111100111001101"
                    echo "binary number = $bin" # 31181
                let "b32 = 32#77"
                    echo "base-32 number = $b32" # 231
                let "b64 = 64#@_"
                echo "base-64 number = $b64"  # 4031
                    # This notation only works for a limited range (2 - 64) of ASCII characters.
                    # 10 digits + 26 lowercase characters + 26 uppercase characters + @ + _
    Precedence:
        Arithmetic operator - "My Dear Aunt Sally" = multiply, divide, add, subtract   
        Compound operators  - &&, ||, -a and -o have low precedence 
        Order of evaluation of equal-precedence is usually left-to-right
    Grep Tests - Example
        if grep -q Error /var/log/messages #-q option supresses output
            then echo "File contains at least one error."
        fi 
        
## Variables
    Variable assignment - backquotes
        a=`echo Hello`
        echo $a         #unquoted, so not tabs or newlines
        echo "$a"       #quoted, so whitespace stays the same

    Variable assignment - parentheses 
        R=$(cat /etc/redhat-release)
        arch=$(uname -m)
    Internal (built-in) Variables:
        $BASH           | the path to the bash binary
        $BASH_ENV       | environmental variable pointing to Bash startup file to be read when
                        +script is invoked
        $BASH_SUBSHELL  | indicates the subshell level
        $BASHPID        | Process ID of the current instance of Bash.
                        + not the same as `echo $$` , but often gives same result
        $BASH_VERSION   | the version of Bash installed on system
        $BASH_VERSIONINFO [n]       | 6-element arrary containing version info 
                                    + similar to BASH_VERSION, but more detailed
        $CDPATH         | a colon-separated list of search paths available to the `cd` command
                        + similar to the $PATH variable for binaries
                        +may be set in the local ~/.bashrc file 
        $DIRSTACK       | the top value in the directory stack (affected by `pushd` and `popd`)
        $EDITOR         | the default editor invoked by a script (usually vi or emacs)
        $EUID           | "effective" user ID number of whatever identity current user 
                        + has assumed (perhaps by `su`) ; not necessarily same as $UID 
        $FUNCNAME       | name of the current function
            xyz23 ()
            {
                echo "$FUNCNAME now executing." #xyz23 now executing 
            }
        $GLOBIGNORE     | a list of filename patterns to be excluded from matching in globbing
        $GROUPS         | groups current user belongs to (based off /etc/passwd and /etc/group)
        $HOME           | home directory of the user, usually /home/username
        $HOSTNAME       | The hostname command assigns the system host name at bootup in an init script.
                        + However, the gethostname() function sets the Bash internal variable $HOSTNAME.
        $HOSTTYPE       | Like $MACHTYPE, identifies the system hardware (e.g. x86_64)
        $IFS            | internal field separator
        $IGNOREEOF      | How many end-of-files (Ctrl-D) the shell will ignore before logging out
        $LC_COLLATE     | Controls collation order in filename expansion and pattern matching
                        + collation = sort order 
                        + often set in .bashrc or /etc/profiles
        $LC_CTYPE       | controls character interpretation in globbing and pattern matching
        $LINENO         | Line number of shell script in which this variale appears
                        + Useful for debugging:
                            # *** BEGIN DEBUG BLOCK ***
                            last_cmd_arg=$_ # Save it.
                            echo "At line number $LINENO, variable \"v1\" = $v1"
                            echo "Last command argument processed = $last_cmd_arg"
                            # *** END DEBUG BLOCK ***
        $MACHTYPE       | identifies system hardware (similar to $HOSTTYPE)
        $OLDPWD         | Old working directory (OLD-print-working-directory)
                        + previous directory you were in 
        $OSTYPE         | operating system type (linux-gnu)
        $PATH           | path to binaries ; normaley saved in /etc/profile or ~/.bashrc
                            PATH=${PATH}:/opt/bin appends the /opt/bin directory to the current path. In a script, it
                            may be expedient to temporarily add a directory to the path in this way. When the script exits, this
                            restores the original $PATH (a child process, such as a script, may not change the environment of the
                            parent process, the shell).
        $PIPESTATUS     | arrary variable holding exit status(es) of last executed foreground pipe
                        + $PIPESTATUS is a "volatile" variable, so it needs to be captured immediately
                        ++after the pipe in question, before other commands intervene
                        +Example
                            bash$ echo $PIPESTATUS
                            0
                            bash$ ls -al | bogus_command
                            bash: bogus_command: command not found
                            bash$ echo ${PIPESTATUS[1]}
                            127
                            bash$ ls -al | bogus_command
                            bash: bogus_command: command not found
                            bash$ echo $?
                            127
        $PPID           | The $PPID of a process is the process ID (pid) of its parent process
                        + compare this with `pidof` command 
        $PROMPT_COMMAND | A variable holding a command to be executed just before the primary
                        + prompt. $PS1 is to be displayed
        $PS1            | Main prompt, seen at the command-line
        $PS2            | Secondary prompt, seen when additional input is expected
                        + It displays as ">".
        $PS3            | Tertiary prompt, displayed in select loop
        $PS4            | Quartenary prompt, shown at the beginning of each line of output
                        + when invoking a script with the -x option. Displays as "+"
        $PWD            | prints working directory | Example below - Deletes directory contents
                            #!/bin/bash 
                            E_WRONG_DIRECTORY=85
                            clear
                            TargetDirectory=/home/tyler/fakedir/

                            cd $TargetDirectory
                            echo "Deleting stale files in $TargetDirectory

                            cd $TargetDirectory
                            echo "Deleting stale files in $TargetDirectory."

                            if [ "$PWD" != "$TargetDirectory" ]
                            then        #keep from wiping wrong dir by accident
                                echo "Wrong directory!"
                                echo "In $PWD rather than $TargetDirectory!"
                                echo "Cancelling command"
                                exit $E_WRONG_DIRECTORY
                            fi 

                            rm -rf *
                            rm .[A-Aa-z0-9]*    #Delete dot files 
                            rm -f .[^.]* ..?*   #To remove filenames with multiple dots

                            echo
                            ls -al      #Any files left?
                            echo "Old files deleted in $TargetDirectory."
                            echo 
                            exit $result 
        $REPLY          | Default value when a variable is not supplied to read
                        +Example:
                            #!/bin/bash
                            # reply.sh
                            # REPLY is the default value for a 'read' command.
                            echo
                            echo -n "What is your favorite vegetable? "
                            read
                            echo "Your favorite vegetable is $REPLY."
                            # REPLY holds the value of last "read" if and only if
                            #+ no variable supplied.
                            echo
                            echo -n "What is your favorite fruit? "
                            read fruit
                            echo "Your favorite fruit is $fruit."
                            echo "but..."
                            echo "Value of \$REPLY is still $REPLY."
                            # $REPLY is still set to its previous value because
                            #+ the variable $fruit absorbed the new "read" value.
                            echo
                            exit 0
        $SECONDS        | The number of seconds the script has been running 
                        +Example:
                             #!/bin/bash

                            TIME_LIMIT=10
                            INTERVAL=1

                            echo
                            echo "Hit Control-C to exit before $TIME_LIMIT seconds."
                            echo
                            while [ "$SECONDS" -le "$TIME_LIMIT" ]
                            do      #$SECONDS is an internal shell variable
                            if [ "$SECONDS" -eq 1 ]
                            then
                                units=second
                            else
                                units=seconds
                            fi

                            echo "This script has been running $SECONDS $units."
                            sleep $INTERVAL
                            done

                            echo -e "\a" #Beep!"

                            exit 0                            
        $SHELLOPTS      | List of enabled shell options, a readonly variable
        $SHLVL          | Shell level, how deeply Bash is nested. If $SHLVL = 1, then a
                        + script will increment to 2
                        +variable is NOT affected by subshells (use $BASH SUBSHELL instead)
        $TMOUT          | Time out value (in seconds)
                        + Example - using $TMOUT with `read`:
                            #!/bin/bash
                            #tmout.sh

                            TMOUT=3         #Prompt times out at three seconds
                            echo "What is your favorite song?"
                            echo "Quickly now, you only have $TMOUT seconds to answer!"
                            read song

                            if [ -z "$song" ]
                            then
                            song="(no answer)"
                            fi

                            echo "Your favorite song is $song."
                         + In scripts, might be easier to just use `read -t`:
                            #!/bin/bash
                            #read-t.sh

                            TIMELIMIT=4 #seconds
                            echo "What's your favorite variable?"
                            read -t $TIMELIMIT variable

                            echo

                            if [ -z "$variable" ]   # is null?
                            then
                            echo "Timed out, variable still unset."
                            else
                            echo "Your fav variable = $variable"
                            fi

                            exit 0

        $UID            | User ID number, as listed in /etc/passwd
                        + Current user's real ID, even if she used `su`
                        +Read only variable, not subject to change in script

    Positional Parameters
        $0, $1, $2      | Positional parameters, passed from command line to script
                        + passed to a function, or set to a variable 
        $#              | number of command-lind arguments or positional parameters
        $*              | All of the positional parameters, seen as a single word 
                        + "$*" must be quoted
        $@              | Same as $*, but each parameter is a quoted string 
                        + i.e. the parameters are passed intact, without interpretation or expansion
                        + each parameter is seen as a separate word 
                        + "$@" should be quoted 
    Other Special Parameters:
        $!              | PID (process ID) of last job run in background
        $_              | Special variable set to final argument of previous command executed
        $?              | Exit status of command/function/script
        $$              | Process ID (PID) of the script itself 
                        + Useful for constructing "unique" temp file names 
                        
    Declare/Typeset options:
        -r | read only  | `declare -r var1` works the the same as `readonly var1` 
        -i | Integer    | Example below        
                declare -i number   #will treat subsequent occurences of "number" as an integer 
                number=3 
                echo "Number = $number" #Number = 3
                number=three       
                echo "Number = $number" #Number=0
        -a | array
        -f | function(s)
            + a `declare -f` line with no arguments in a script causes a listing
            ++ of all the functions previously defined in that script 
        -x  | export 
        -x var=$value       | example below:
            declare -x var3=373 
            #^ Allows you to assign a value to the variable in the same 
            ##statement as setting its properties (cool!)

### Variable Manipulation
    String Length
        ${#strin}
	expr length $string
	expr "$string" :'.#'
	Example
		StringZ=abcABC123ABCabc
		
		echo ${#stringZ} 		#15
		echo   `expr length $stringZ`	#15
		echo `expr "$strinZ" : '.*'`	#15         
    Substring - Length
	expr match "$string" '$substring'	#$substring is a regular expression
        expr match "$string" '$substring'	#$substring is a regular expression
	Example:
		stringZ=abcABC123ABCabc
		#       |------|
		#	12345678
		echo `expr match "$stringZ" 'abc[A-Z]*.2'`	#8
		echo `expr "$stringZ" : 'abc[A-Z]*.2'` 		#8
    Substring - Extraction
	${sting:position}		#Extracts substring from $string at $position
	${string:position:length}	#Extracts $length characters of substring from $string at $position
	Examples:
		stringZ=abcABC123ABCabc
		#	0123456789.....
		echo ${stringZ:0} 	#abcABC123ABCabc
		echo ${stringZ:1}	#bcABC123ABCabc
		echo ${stringZ:7}	#23ABCabc
		
		echo ${stringZ:7:3}	#23A	 #Three characters of substring

		echo ${stringZ:-4}	#Cab	 #Index from right end of string
	expr substr $string $position $length	 #Extracts $length characters from $string starting at $position
		Example:
			stringZ=abcABC123ABCabc
		#		12356789.... 	#1-based indexing (not 0)
			echo `expr substr $stringZ 1 2`	#ab
			echo `expr substr $stringZ 4 3`	#ABC
	expr match "$string" `\($substring\)'	#Extracts $substring at beginning of $string, where $substring is a regex
	expr "$string" : '\($substring\)'	#Extracts $substring at beginning of $string, where $substring is a regex
		Example:
			stringZ=abcABC123ABCabc
			echo `expr match "$stringZ" '.*\([A-C] [A-C] [A-C] [a-c]*\)'`	#ABCabc
			echo `expr "$stringZ" : '.*\(......\)'`
    Substring - Removal
	${string#substring} 		#Deletes SHORTEST match of $substring from FRONT of $string
	${string##substring}		#Deletes LONGEST match of $substring from FRONT of $string
		Example:
			stringZ=abcABC123ABCabc
			#	|----|		shortest
			#	|----------|	longest
			
			echo ${stringZ#a*C}	#123ABCabc #is what's left after the string is removed
			echo ${stringZ##a*C}	#abc	   #is what's left after the string is removed
			
			#TIP: You can parameterize the substrings:
			X='a*C'
			
			echo ${stringZ#$X}	#123ABCabc
			echo ${stringZ##$X}	#abc
    	${string%substring}		#Deletes SHORTEST match of $substring from BACK of $string
		Example - Script:
			# Rename all filenames in $PWD with "TXT" suffix to "txt" suffix.
			# E.g., "file1.TXT" becomes "file1.txt"

			SUFF=TXT
			suff=txt
			
			for i in $(ls *.$SUFF)
			do
			    mv -f $i ${i%.$SUFF}.$suff
			    # Leave unchanged everything *except* the shortest pattern match
			    # +starting from the right-hand-side of the variable $i . . . 
			done
		Example - Rename file extensions:
			for i in $(ls *.TXT)
			do
			     mv -f $i ${i%.TXT}.txt
			 done
	${string%%substring}		#Deletes LONGEST match of $substring from BACK of $sting ##Useful for generating filenames
		Example:
			stringZ=abcABC123ABCabc
		#		             ||		shortest
		#		|-------------|		longest
			echo ${stringZ%b*c}		#What's left: abcABC123ABCa 
			echo ${stingZ%%b*c}		#What's left: a
    
    String - Replacement ***
	${string/substring/replacement} 		#Replace FIRST match of $substring with $replacement
	${string//substring/replacement}		#Replace ALL matches of $substring with $replacement
		Example:
			stringZ=abcABC123ABCabc
			
			echo ${stringZ/abc/!!!}		#!!!ABC123ABCabc 	## Replaces first match of 'abc' with '!!!'
			echo ${stringZ//abc/@@@}	#@@@ABC123ABC@@@	## Replaces all matches of 'abc' with '@@@'
			echo "$stringZ"			#abcABC123ABCabc	# The string itself is not altered :)

			#Replacement, using parameters:
			match=abc
			repl=***
			echo ${stringZ/$match/$repl} 	#***ABC123ABCabc
			echo ${stringZ//$match/$repl}	#***ABC123ABC***

	${string/#substring/replacement}		#If $substring matches FRONT end of $string, substitute $replacement for $substring
	${string/%substring/replacement}		#If $substring matches BACK end of $string, substitute $replacement for $substring
		Examples:
			stringZ=abcABC123ABCabc
			echo ${stringZ/#abc/&&&}	#&&&ABC123ABCabc	##front
			echo ${stringZ/%abc/$$$}	#abcABC123ABC$$$	##back 
    String - awk
			
