[![Codacy Badge](https://api.codacy.com/project/badge/Grade/ea9cfcc5831b449c9a1096d1dfd0037b)](https://www.codacy.com/manual/jsfierro/standoff?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=jsfierro/standoff&amp;utm_campaign=Badge_Grade)

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

# ./standoff_install.sh
```

### Usage

See the man page (standoff.1) for full usage examples. Below is a brief explanation
to get you running. 

Standoff requires a file containing a list of target machines (one per line) to configure.
You can then specify a payload file with a list of commands to run on those machines with the -c option.
Additionally, you can give standoff a list of files to upload with the -f option. 

These payload files are all read line by line. A typical usage might look like this:
 
```

standoff.pl -t targets -c commands -f files
```

where "targets" is a text file containing the hostnames or IP addresses to configure (one per line),
"commands" is a text file containing the shell commands to run (one command per line) and
"files" is a list of files to upload. It is important to note that files are always uploaded before any commands
are executed on the remote machine, so if you need to move them to the correct locations on the target, you can put 
the commands to do so in the commands file.

Example payload files for each are provided to show acceptable formats. 

### Limitations

standoff is not very fast. Targets are handled serially in order to simplify the code.
Clever use of threading could speed up this process, but is not implemented yet.

Aruba APs will not work as targets as they do not allow logins over SSH without a terminal.
This problem may also affect other HP products. 

The user-facing connection options for SSH are limited. This is to avoid too many knobs, but
some edge cases may require more fine-tuning for successful connections.

standoff is a bit clunky to use on a single target.
