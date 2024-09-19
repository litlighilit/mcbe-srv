# Minecraft BE server tool chain

## init

First of all, these tools are aimed to run in a seperated user.

To init,
clone this repo,
if using default cfg,
please place this repo's dir to $HOME and rename as `app`.

The simplest way to make it is:

```shell
# assuming this is executed by a newly created user.
git clone https://github.com/litlighilit/mcbe-srv ~/app
```

### Download mc be server

Then go to <https://www.minecraft.net/en-us/download/server/bedrock>,

scroll to section of "Minecraft Dedicated Server software for Ubuntu (Linux)",

tick "I agree to the Minecraft End User License Agreement and Privacy Policy" (after reading and agreeing policy),

finally click "DOWNLOAD"

(or copy its url and directly install it in your linux via curl, wget, etc)

### Install mc be server
unzip it, placing content in ~/bedrock-server/


## Tools

> Almost every tool accepts `-h` for help, try it if wanting details.

### Change default Configure of mc BE server
- the `init_srv` is a python module containing a `__main__.py` which makes up a server from existing world(called "level" by MC), and is used to change some cfg of mcbe srv like making default player `Visitor` level.

### World backup
- new_one_backup: creates a new backup of the world currently runned by server
- push_backup: creates like `new_one_backup` but will delete the oldest one if the number of backups has exceeded the specified number (default: 10)

### Pack(addon) manager
- add_pack: add a new pack to the server

### Service run
- auto-off_mc: auto-shutdown the server and computer after there is no player
- log_srv: logged server and will auto-backup:
    - create a screen named `mcbe-srv`, which serves the origin mc server CLI (`screen -r mcbe-srv` to enter, Ctrl-a-d to deattch`)
    - if wanna quit the whole server, only one Ctrl-c is needed. log_srv will shut down all.

## Naming notations of tools

- snake_case for scripts (bash or python)
- pascalCase for executable (whose source code is in ./src) [^exe]


[^exe]: the executable in this repo is of x86_x64 Ubuntu. If you are using other architectures/OSes, it's quite easy to compile. All you need is just a [Nim compiler](https://nim-lang.org/install.html), which is as small as dozens of Mb, and run `./build_sh.bash`