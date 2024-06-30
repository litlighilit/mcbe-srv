"""
build a mc server ready for run.

do:
    - unpack archive and place world into server
    - change configure
    - chmod of execuatble


"""

import os
from argparse import ArgumentParser, RawDescriptionHelpFormatter

from . import ch_cfg

from .mk import mk_with_archive, init_parser

SRV_BIN = "bedrock_server"

mk_parser = init_parser(add_help=False)
parser = ArgumentParser(parents=[mk_parser], formatter_class=RawDescriptionHelpFormatter, description=__doc__)

args = parser.parse_args()

world_archive = args.world
server_archive = args.server
mk_with_archive(server_archive, world_archive, args)

srv_dir = args.dest

ch_cfg(srv_dir)

if os.name == "posix":
    os.chmod(os.path.join(srv_dir, SRV_BIN), 0o777)

