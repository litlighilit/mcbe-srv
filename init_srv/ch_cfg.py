#!/usr/bin/env python3
"""
change configure of {cfg_fname} into {cfg_map}
"""

CONF_FNAME = "server.properties"
chmap = {
        "server-name": "lit-srv",
        "default-player-permission-level": "visitor"
        }

__doc__ = __doc__.format(cfg_map=chmap, cfg_fname=CONF_FNAME)

import sys
import os.path

import argparse
from argparse import ArgumentParser

def main():
    argp = ArgumentParser(
        description=__doc__
            )
    argp.add_argument("cfgDir",
            help="directory of "+CONF_FNAME)


    args = argp.parse_args()

    assert os.path.isdir(args.cfgDir)

    fpath = os.path.join(args.cfgDir, CONF_FNAME)

    rewrite(fpath)


class Cfg:
    sep = '='
    comment = '#'

def rewrite(fpath):
    outls = []
    with open(fpath, "r+", encoding="utf-8") as f:
        for line in f:
            if line.strip()=="" or line.startswith(Cfg.comment):
                outls.append(line)
                continue
            key, _val = line.split(Cfg.sep,1)

            if key in chmap:
                outl = key + Cfg.sep + chmap.pop(key)
                if line[-1] == '\n': outl += '\n'
            else:
                outl = line
            outls.append(outl)

        f.seek(0)
        f.truncate()
        f.writelines(outls)

if __name__ == '__main__': main()



