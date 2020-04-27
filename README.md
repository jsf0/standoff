## standoff

Standoff is a Perl program to automate remote configuration of machines via SSH.
It is intended to be a much simpler alternative to Ansible. Its configuration files do not require 
any knowledge of markup languages, nor does it require any setup on the remote machines
at all beyond running SSH. 

As of right now, standoff is an unrefined work-in-progress. 

### Installing

You will need the following Perl modules: Net::OpenSSH and Config::IniFiles. If they are not present, 
install them first:

```

# cpan -i Net::OpenSSH
# cpan -i Config::IniFiles
```

OpenBSD users are advised to use pkg_add(1) to install these modules
rather than cpan(1):

```
# pkg_add p5-Net-OpenSSH p5-Config-IniFiles
```

To install standoff and its man page, run:
```

# ./standoff_install.sh
```

### Usage

See the man page (standoff.1) for full usage examples. Below is a brief explanation
to get you running. 

Standoff requires a payload file in INI format. A simple example might look like this:
 
```
[Target]
target=172.16.1.1
ssh_key=/path/to/ssh_key

[Files]
file=httpd.conf

[Commands]
command=doas cp httpd.conf /etc
command=doas rcctl reload httpd

```

Then, to run standoff, run:
```
standoff -f payload_file.ini
```

This will upload a file called httpd.conf into the remote user's home directory, then execute
the commands in the Commands section. 
Any files are always uploaded before commands
are executed on the remote machine, so if you need to move them to the correct locations on the target, you can put 
the commands to do so in the commands section.
The ssh_key parameter is optional. If you don't provide one, standoff will 
attempt to connect to the target with passphrase-based authentication.

More complex example payload files can be found in the examples/ directory. 

standoff can also be run in "pull" mode by specifying the -p option.
This will connect to the server in the [Target] section, download any files requested in the
[Files] section, and then locally run the commands from the [Commands] section.
This is especially useful when combined with cron, as it can be used to remotely manage
endpoints even if they are behind NAT and/or firewalls. 

### Limitations

The user-facing connection options for SSH are limited. This is to avoid too many knobs, but
some edge cases may require more fine-tuning for successful connections.
