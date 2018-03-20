---
layout: post
title: A comprehensive Linux command cheat sheet
date: 2017-03-25 10:30:15 -06:00
tags:
- linux
---

I think that it doesn't matter what operating system you use &mdash; as long as you know your OS of choice well!:bowtie:
This is a Linux command cheat sheet covering a wide range of topics. I cannot guarantee that the information is fully up-to-date or even correct. Use at own risk :stuck_out_tongue:. It is intended primarily as a reference for myself in the future. I have learned most of the material covered below a couple of years ago in [the LinuxFoundationX's Introduction to Linux course offered through edx.org](https://courses.edx.org/courses/LinuxFoundationX/LFS101x/2T2014/info).



## Table of contents

* TOC
* Learned about the TOC implementation from <http://www.seanbuscay.com/blog/jekyll-toc-markdown/>
{:toc}

## The most basic operations

* Power off / reboot: `shutdown -h now`, `halt`, `poweroff`, `reboot`, `shutdown -r now`
* Most basic navigation: `pwd`, `cd`, `cd ~`, `cd ..`, `cd -`, `ls`, `ls -a`, `ls -li`, `tree`
* Most basic file management: `mv`, `cp`, `rm -f`, `rm -i`, `rm -r`, `rmdir <empty_dir>`
* Date and time: `date`, `cal`, `cal -y`

## Create files, directories, and links

* Create files and directories:

```shell
$ touch <file>
$ touch -t 1703270159 <file>
$ mkdir <path/dir>
```

* Create a hard / soft (symbolic) link: `ln` / `ln -s`
* Create a temporary file or directory:

```shell
$ TEMP=$(mktemp /tmp/tempfile.XXXXXXXX)
$ TEMPDIR=$(mktemp -d /tmp/tempdir.XXXXXXXX)
```

## I/O redirection

Assume that `do_something` reads from `stdin` and writes to `stdout` and `stderr`.

* Get the input from a file using `<`.
* Send the output to a new file using `>`.
* Append to an existing file using `>>`.

Example:

```bash
$ do_something < input-file
$ do_something > output-file
$ do_something 2> error-file
$ do_something > all-output-file 2>&1
$ do_something >& all-output-file
```

Pipe the output of one command or program into another as its input:

```bash
$ command1 | command2 | command3
```

## Search

* Locate applications: `which`, `whereis`
* Update database, and search for a character string in the database with `updatedb` and `locate`. E.g., to list all files and directories with both "zip" and "bin" in their name:
```shell
$ updatedb
$ locate zip | grep bin
```

* Locate files recursively from a given directory: `find`
  - E.g., searching only for regular files named "test1" in `/usr`:
  ```shell
  $ find /usr -type f -name test1
  ```
  - E.g., search based on file size or time stamp:
  ```shell
  $ find / -size +10M
  $ find / -ctime 3
  ```
  - `find` uses wildcards such as `?`, `*`, `[set]`, `[!set]` (where "set" is a set of letters).
  - Run commands on the found files with the `-exec` option.
  - E.g., to find and remove all files that end with `.swp` in current directory:
  ```shell
  $ find -name "*.swp" -exec rm {} ’;’
  ```

* Use `grep` to search for a pattern in a file and print all matching lines. Examples:
```shell
$ grep [pattern] <filename>
$ grep -C 3 [pattern] <filename>
```

## Viewing text files

* `cat` for short files, no scroll-back.
* `tac` to look at a file backwards.
* Concatenate multiple files and display the output:
```shell
$ cat <file1> <file2>
$ tac <file1> <file2> <file3>
```
* `less` for larger files; use `/` and `?` for forward and backward search.
* Print the first `n` or the last `n` lines of a file:
```shell
$ head -n
$ tail -n
```
* Monitor new output in a growing file:
```shell
$ tail -f
```

## Create and fill text files

* Create a file and fill it with content:
```shell
$ echo line one > myfile
$ echo line two >> myfile
$ echo line three >> myfile
```
or
```shell
$ cat << EOF > myfile
> line one
> line two
> line three
> EOF
```
* From existing text files:
```shell
$ cat file1 file2 > newfile
$ cat file >> existingfile
```

## More text utilities

* Sort the lines in file alphabetically:
```shell
$ sort <filename>
```
* Remove consecutive duplicate lines from file:
```shell
$ uniq <filename>
```
* Split a file into 1000-line segments:
```shell
$ split <infile> <prefix>
```
* Count lines, words, and characters in a file:
```shell
$ wc <filename>
```
* Print or join files by column (field): `awk`, `paste`, `join`, `cut`
* Miscellaneous text utilities: `sed`, `tr`, `tee`, `strings`

## Comparing and patching files

* Show the file type of a file:
```shell
$ file <filename>
```
* Compare two files:
```shell
$ diff <filename1> <filename2>
```
* Compare two files to a common file:
```shell
$ diff3 <filename1> <commonfile> <filename2> 
```
* Produce a patch file:
```shell
$ diff -Nur oldfile newfile > patchfile
```
* Apply a patch file:
```shell
$ patch -p0 < patchfile
```
or
```shell
$ patch file patchfile
```

## Postscript and PDF files

* Convert `bar.txt` to `foo.ps`:
```shell
$ enscript -p foo.ps bar.txt
```
* View the details of a PDF file:
```shell
$ pdfinfo <filename>.pdf
```
* Converting between PostScript and PDF:
```shell
$ ps2pdf <filename>.pdf
$ pdf2ps <filename>.ps
$ epstopdf <filename>.eps <filename>.pdf
```
* `pdftk` is the Swiss Army knife of PDF tools. Usage examples:
  - Merge `1.pdf` and `2.pdf`, and save as `12.pdf`:
```shell
$ pdftk 1.pdf 2.pdf cat output 12.pdf
```
  - Save pages 1 and 2 of `1.pdf` to `new.pdf`:
```shell
$ pdftk A=1.pdf cat A1-2 output new.pdf
```
  - Rotate all pages of `in.pdf` 90 deg. clockwise, and save as `out.pdf`:
```shell
$ pdftk in.pdf cat 1-endeast output out.pdf
```
  - Encrypt a PDF file:
```shell
$ pdftk public.pdf output private.pdf user_pw PROMPT
```

## Viewing linux documentation

1. `man` to search, format, and displays the manual pages. Examples:
  - `man -f` displays a one-line manual pages descriptions:
```shell
$ man -f printf
printf (1) - format and print data
printf (3) - formatted output conversion
```
  or equivalently,
```shell
$ whatis printf
printf (1) - format and print data
printf (3) - formatted output conversion
```
  - The section number can be supplied:
```shell
$ man 3 printf
```
  - `man -k` shows all man pages that discuss a specified subject:
```shell
$ man -k ruby
erb (1)    - Ruby Templating
erb2.3 (1) - Ruby Templating
gem (1)    - frontend to RubyGems, the Ruby package manager
(...)
```
2. GNU Info System:
```shell
$ info
$ info <topic name>
```

3. Every command has a `--help` or `-h` option.

## File ownership and permissions

* Change user ownership:
```shell
$ chown <owner> <filename>
```
* Change group ownership:
```shell
$ chgrp <group> <filename>
```
* Change the permissions on a file:
```shell
$ chmod <permissions> <file>
```

## User accounts and groups

* Identify currently logged-on users:
```shell
$ who
$ who -a
$ whoami
```
* Add / Remove a user: `useradd` / `userdel`
* Set the initial password for a new user:
```shell
$ passwd <username>
```
* Display information about a user:
```shell
$ id <user>
$ groups <user>
```
* Add / Remove a group: `groupadd` / `groupdel`
* Add a user to a group:
```shell
$ groupmod -G <group> <user>
```
* Grant root privileges to user temporarily:
```shell
$ su
$ sudo <command>
```
* Show last time each user has logged into the system:
```shell
$ last
```

## Environment variables and aliases

* View the values of currently set environment variables:
```shell
$ set
$ env
$ export
```
* Show the value of a specific variable:
```shell
$ echo $VARIABLE
```
* Export a new variable value:
```shell
$ export VARIABLE=value
```
* E.g., to prefix a private bin directory to your path:
```shell
$ export PATH=$HOME/bin:$PATH
```
* List currently defined aliases:
```shell
$ alias
```
* Create an alias, e.g.:
```shell
$ alias vi='vim'
```

## Filesystems

* Attach a filesystem:
```shell
$ mount <device node> <mount point>
$ mount /dev/sda5 /home
```
* Display information about mounted filesystems:
```shell
$ df -Th
$ mount
$ fdisk -l
```
* NFS (Network Filesystem)
  1. On the Server:
    - Start the NFS:
```shell
$ sudo service nfs start
```
    - Modify `/etc/exports`. Example entry:
```shell
/projects *.example.com(rw)`
```
    - After modifying the `/etc/exports` file run:
```shell
$ exportfs -av
```
  2. On the client:
    - Mount the remote filesystem:
```shell
$ mount servername:/projects /mnt/nfs/projects
```
    - Or modify `/etc/fstab`. Example entry:
```shell
servername:/projects /mnt/nfs/projects nfs default 0 0`
```

* The `proc` Filesystem
  - Some important files in `/proc` are: `/proc/cpuinfo`, `/proc/interrupts`, `/proc/meminfo`, `/proc/mounts`, `/proc/partitions`, `/proc/version`.
  - `/proc` also has subdirectories, such as `/proc/<Process-ID-#>` and `/proc/sys`.

## Processes

* All processes / all processes and all threads / all processes for all users:

```shell
$ ps -ef
$ ps -eLf
$ ps aux
```

* Process tree:

```shell
$ pstree
```

* Proc list with updates in real time:

```shell
$ top
$ htop
```

(press `A` to sort when using `top`)

* Terminate a process:

```shell
$ kill -SIGKILL <pid>
$ kill -9 <pid>
```

* View the background processes in the current terminal:

```shell
$ jobs -l
```

* Suspend a foreground process: `CTRL-z`
* Cancel a foreground process: `CTRL-c`
* Move process to the background / foreground:

```shell
$ bg
$ fg
```

* Schedule future non-interactive proc, e.g.:

```shell
$ at 11 am may 20
at> echo Hello! > hello.txt
at> <CTRL-D>
$
$ at now + 3 minutes
at> mkdir dirfrom3minutesago
at> <CTRL-D>
$
```

* Schedule periodic background work:

```shell
$ crontab -e
```

* Suspend execution (suffix = `s`, `m`, `h`, `d`):

```shell
$ sleep <number><suffix>
```


## Backing up data

* Synchronize directory trees with `rsync`, which copies only the differences between directories. Examples:

```shell
$ rsync -avP --delete dir1/ dir2
$ rsync -avPe ssh --delete dir/ user@host:/path/to/dir
```

* Test the `rsync` command using the `--dry-run` option.

## Compressed data and archives

1. Compressing data using `gzip`, `bzip2` and `xz`
  * There is an efficiency vs. speed trade-off. Ranked by space-efficiency:
    > `xz` > `bzip2` > `gzip`.
  * Replace each file in the current directory with its compressed version:
```shell
$ gzip *
$ bzip2 *
$ xz *
```
  * Compress the file `foo` into `foo.xz` using the default compression level (-6), and remove `foo` if compression succeeds:
```shell
$ xz foo
```
  * De-compress:
```shell
$ gunzip foo
$ bunzip2 *.bz2
```
  * Decompress `bar.xz` into `bar` and don't remove `bar.xz` even if decompression is successful:
```shell
$ xz -dk bar.xz
```

2. Handling Files Using zip
  * E.g., archive the login directory (`~`) and all files and directories under it as `backup.zip`:
```shell
$ zip -r backup.zip ~
```
  * Extracts all files in the file `backup.zip`:
```shell
$ unzip backup.zip
```

3. Archiving and Compressing Data Using `tar`
  * Extract all the files in `mydir.tar` into the `mydir` directory:
```shell
$ tar xvf mydir.tar
```
  * Create the archive and compress with `gzip`/`bz2`/`xz`:
```shell
$ tar zcvf mydir.tar.gz mydir
$ tar jcvf mydir.tar.bz2 mydir
$ tar Jcvf mydir.tar.xz mydir
```
  * Extract all the files in `mydir.tar.*` into the `mydir` directory:
```shell
$ tar xvf mydir.tar.gz
```

4. Working with compressed data
  * For `gzip`'ed files: `zcat`, `zless`, `zgrep`, `zdiff`.
  * For `bzip2`'ed files: `bzcat`, `bzless`.
  * For `xz`'ed files: `xzcat`, `xzless`.

## Network operations

* Using Domain Name System (DNS) and Name Resolution Tools
  - View IP and domain information about your system:
```shell
$ hostname
$ cat /etc/hosts
$ cat /etc/resolv.conf
```
  - View IP and domain information about linux.com:
```shell
$ host linux.com
$ nslookup linux.com
$ dig linux.com
$ dig +trace linux.com
$ dig @8.8.8.8 linux.com
```
  (`8.8.8.8` is Google's recursive DNS server)
* Network Interfaces and Configuration
  - List all currently active network interfaces:
```shell
$ ifconfig
```
  - Show IP address of active network device:
```shell
$ ip addr show
```
  - Show routing info of active network device:
```shell
$ ip route show
```
  - Check the status of the remote host:
```shell
$ ping <hostname>
```
* Routing Tables / Routes
  - Show current IP routing table:
```shell
$ route -n
```
  - Add/delete static route:
```shell
$ route add -net address
$ route del -net address
```
  - Print the route taken by the packet to reach the network host at `<domain>`:
```shell
$ traceroute <domain>
```
  - Display all active connections and routing tables:
```shell
$ netstat -r
```
* Dump network traffic for analysis:
```shell
$ tcpdump
$ sudo tcpdump host google.com
```
* Interaction with webpages
  - Download a webpage:
```shell
$ wget <url>
```
  - Read or save the source code and other info of a URL:
```shell
$ curl <url>
$ curl -o saved.html http://www.mysite.com
```

## Transferring files over the network

- FTP (File Transfer Protocol)
  * An example of connecting to the server and downloading a file:
```shell
$ ftp -p some.server.com
ftp> ls
ftp> get somefile.txt
ftp> quit
$
```

- SSH (Secure Shell)
  * Log into `remotesystem` with `username`:
```shell
$ ssh <username@remotesystem>
```
  * Run `my_command` on a remote system via SSH:
```shell
$ ssh <user@remotesystem> my_command
```
  * Copy a local file to a remote system (similarly vice versa):
```shell
$ scp <localfile> <user@remotesystem>:/home/user/
$ scp <user@remotesystem>:/home/user/somefile /local/dir/
```

## Cool links

* <http://explainshell.com> &mdash; see help text that matches each argument of a given command line. *Extremely* useful!
* <http://jvns.ca/zines/> &mdash; *informative* fanzines about some Linux tools.
* <http://tldr.sh/> &mdash; *simplified* man pages (so short!), driven by practical examples.
