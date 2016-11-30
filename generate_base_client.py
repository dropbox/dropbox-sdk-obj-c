#!/usr/bin/env python
from __future__ import absolute_import, division, print_function, unicode_literals

import argparse
import glob
import json
import os
import subprocess

cmdline_desc = """\
Runs Stone to generate Obj-C types and client for the Dropbox client.
"""

_cmdline_parser = argparse.ArgumentParser(description=cmdline_desc)
_cmdline_parser.add_argument(
    '-v',
    '--verbose',
    action='store_true',
    help='Print debugging statements.',
)
_cmdline_parser.add_argument(
    'spec',
    nargs='*',
    type=str,
    help='Path to API specifications. Each must have a .stone extension.',
)
_cmdline_parser.add_argument(
    '-s',
    '--stone',
    type=str,
    help='Path to clone of stone repository.',
)
_cmdline_parser.add_argument(
    '-d',
    '--documentation',
    action='store_false',
    help='Sets whether documentation config file should be generated.',
    default=True,
)
_cmdline_parser.add_argument(
    '-f',
    '--formatting',
    action='store_false',
    help='Sets whether source should be formatted.',
    default=True,
)
_cmdline_parser.add_argument(
    '-o',
    '--output_path',
    type=str,
    help='Path to generation output.',
)


def main():
    """The entry point for the program."""

    args = _cmdline_parser.parse_args()
    verbose = args.verbose

    if args.spec:
        specs = args.spec
    else:
        # If no specs were specified, default to the spec submodule.
        specs = glob.glob('spec/*.stone')  # Arbitrary sorting
        specs.sort()

    specs = [os.path.join(os.getcwd(), s) for s in specs]

    stone_path = os.path.abspath('stone')
    if args.stone:
        stone_path = args.stone

    default_path = os.path.abspath('Source/ObjectiveDropboxOfficial/Shared/Generated')
    dropbox_pkg_path = args.output_path if args.output_path else default_path
    dropbox_format_path = os.path.abspath('Format')

    if verbose:
        print('Dropbox package path: %s' % dropbox_pkg_path)

    if verbose:
        print('Generating Obj-C types')

    types_cmd = (['python', '-m', 'stone.cli', '-a', 'host', '-a', 'style',
                 '-a', 'auth', 'obj_c_types', dropbox_pkg_path] + specs)

    if args.documentation:
        types_cmd += ['--', '-d', 'true']
    o = subprocess.check_output(
        (types_cmd),
        cwd=stone_path)
    if o:
        print('Output:', o)

    client_args = _get_client_args()
    style_to_request = _get_style_to_request()

    if verbose:
        print('Generating Obj-C user and team clients')
    o = subprocess.check_output(
        (['python', '-m', 'stone.cli', '-a', 'host', '-a', 'style', '-a', 'auth', 'obj_c_client', dropbox_pkg_path] +
         specs + ['-b', 'team', '--', '-m', 'DBBase', '-c', 'DBBase',
         '-t', 'DBTransportClient', '-y', client_args, '-z', style_to_request]),
        cwd=stone_path)
    if o:
        print('Output:', o)
    o = subprocess.check_output(
        (['python', '-m', 'stone.cli', '-a', 'host', '-a', 'style', '-a', 'auth', 'obj_c_client', dropbox_pkg_path] +
         specs + ['-w', 'team', '--', '-m', 'DBBaseTeam', '-c', 'DBBaseTeam',
         '-t', 'DBTransportClient', '-y', client_args, '-z', style_to_request]),
        cwd=stone_path)
    if o:
        print('Output:', o)

    with open(dropbox_format_path + '/list_files_reformat.txt', "w") as outfile:
        get_files_cmd = ['find', '../Source/', '-iname', '*.[mh]']
        subprocess.call(get_files_cmd, stdout=outfile, cwd=dropbox_format_path)

    if args.formatting:
        if verbose:
            print('Formatting source files')
        o = subprocess.check_output(
            (['sh', 'reformat_files.sh', 'list_files_reformat.txt']), cwd=dropbox_format_path)
        if o:
            print('Output:', o)


def _get_client_args():
    input_doc = "The file to upload, as an {} object."
    dest_doc = ('The file url of the desired download output location.')

    overwrite_doc = ('A boolean to set behavior in the event of a naming conflict. `YES` will '
        + 'overwrite conflicting file at destination. `NO` will take no action, resulting in an `NSError` '
        + 'returned to the response handler in the event of a file conflict.')

    client_args = {
        'upload': [
            ('upload', ['Url', [('inputUrl', 'inputUrl', 'NSURL * _Nonnull', input_doc.format('NSURL *')), ], ]),
            ('upload', ['Data', [('inputData', 'inputData', 'NSData * _Nonnull', input_doc.format('NSData *')), ], ]),
            ('upload', ['Stream', [('inputStream', 'inputStream', 'NSInputStream * _Nonnull', input_doc.format('NSInputStream *')), ], ]),
        ],
        'download': [
            ('download_url', ['Url', [('overwrite', 'overwrite', 'BOOL', overwrite_doc),
                ('destination', 'destination', 'NSURL * _Nonnull', dest_doc), ], ]),
            ('download_data', ['Data', []]),
        ],
    }

    return json.dumps(client_args)


def _get_style_to_request():
    style_to_request = {
        'rpc': 'DBRpcTask',
        'upload': 'DBUploadTask',
        'download_url': 'DBDownloadUrlTask',
        'download_data': 'DBDownloadDataTask',
    }

    return json.dumps(style_to_request)

if __name__ == '__main__':
    main()
