#!/usr/bin/env python3

import os
from shutil import unpack_archive as decompress
from shutil import rmtree


class World:
    pure_dir = "worlds"
    name = "Bedrock level"


def dir_empty(d):
    res = True
    for _de in os.scandir(d):
        res = False
        break
    return res

def mk_with_archive(server_archive,  world_archive, args):
    if os.path.isdir(args.dest) and not dir_empty(args.dest):
        if args.ok_if_dest_exists: pass
        else: raise IOError(args.dest + " is not empty. Consider to pass -D arg if wanted.")
    decompress(server_archive, args.dest)

    world_dest = os.path.join(args.dest, World.pure_dir , World.name)
    if os.path.isdir(world_dest):
        if args.overwrite_if_world_exists: rmtree(world_dest)
        else: raise IOError(world_dest + " exists alreadly! Consider to pass -O arg if wanted.")


    os.makedirs(world_dest)
    decompress(world_archive, world_dest)

def init_parser(add_help=True):
    from argparse import ArgumentParser, ArgumentDefaultsHelpFormatter
    parser = ArgumentParser(add_help=add_help, formatter_class=ArgumentDefaultsHelpFormatter)

    parser.add_argument("-w", "--world", required=True)
    parser.add_argument("-s", "--server", required=True)

    parser.add_argument("-d", "--dest", default="./bedrock-server", help="directory to extract the server contents to")

    parser.add_argument("-D", "--ok-if-dest-exists", action="store_true", default=False)
    parser.add_argument("-O", "--overwrite-if-world-exists", action="store_true", default=False)

    return parser

def main():
    parser = init_parser()
    args = parser.parse_args()

    world_archive = args.world
    server_archive = args.server
    mk_with_archive(server_archive, world_archive, args)

if __name__ == "__main__": main()


