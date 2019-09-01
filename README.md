## standoff

Standoff is a Perl program to automate remote configuration of machines via SSH.
It is intended to be a much simpler alternative to Ansible. Its configuration files do not require 
any knowledge of markup languages, nor does it require any setup on the remote machines
at all beyond running SSH. 

As of right now, standoff is an unrefined work-in-progress. 

### Installing

The only module required is Net::OpenSSH. If this is not present, 
run the following command first:

```

# cpan -i Net::OpenSSH
```

To install the script and man page, run:
```

# ./standoff_install
```

### Usage

See the man page (standoff.1) for full usage examples. Below is a brief explanation
to get you running. 

Standoff requires a list of target machines to configure,
a list of commands to run on them, and optionally, a list of files to upload to those targets.

These files are read line by line. A typical usage might look like this:
 
```

standoff -t targets -c commands -f files
```

where "targets" is a text file containing the hostnames or IP addresses to configure (one per line),
"commands" is a text file containing the shell commands to run (one command per line) and, if desired,
"files" is a list of files to upload. It is important to note that files are always uploaded before any commands
are executed, so if you need to move them to the correct locations on the target, you can put 
the commands to do so in the commands file.

If you do not want to run any commands on the target, the "commands" file can be an empty file,
but it must be supplied. This is useful if you only want to upload files.

Sample files for each are provided to show acceptable formats. 
