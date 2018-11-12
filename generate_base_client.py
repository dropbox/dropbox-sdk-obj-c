#!/usr/bin/env python
from __future__ import absolute_import, division, print_function, unicode_literals

import argparse
import glob
import json
import os
import shutil
import subprocess
import sys

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
    '-o',
    '--output-path',
    type=str,
    help='Path to generation output.',
)
_cmdline_parser.add_argument(
    '-f',
    '--format-output-path',
    type=str,
    help='Path to format output.',
)
_cmdline_parser.add_argument(
    '-e',
    '--exclude-from-analysis',
    action='store_true',
    help='Sets whether generated code should marked for exclusion from analysis.',
)
_cmdline_parser.add_argument(
    '-r',
    '--route-whitelist-filter',
    type=str,
    help='Path to route whitelist filter used by Stone. See stone -r for detailed instructions.',
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

    dropbox_src_path = os.path.abspath('Source')
    dropbox_default_output_path = os.path.abspath('Source/ObjectiveDropboxOfficial/Shared/Generated')
    dropbox_pkg_path = args.output_path if args.output_path else dropbox_default_output_path
    dropbox_format_script_path = os.path.abspath('Format')
    dropbox_format_output_path = args.format_output_path if args.format_output_path else dropbox_src_path

    # clear out all old files
    if not args.format_output_path:
        shutil.rmtree(dropbox_default_output_path)
        os.makedirs(dropbox_default_output_path)

    if verbose:
        print('Dropbox package path: %s' % dropbox_pkg_path)

    if verbose:
        print('Generating Obj-C types')

    stone_cmd_prefix = [
        sys.executable,
        '-m', 'stone.cli',
        '-a', 'host',
        '-a', 'style',
        '-a', 'auth',
    ]
    if args.route_whitelist_filter:
        stone_cmd_prefix += ['-r', args.route_whitelist_filter]

    types_cmd = stone_cmd_prefix + ['obj_c_types', dropbox_pkg_path] + specs

    if args.documentation or args.exclude_from_analysis:
        types_cmd += ['--']
        if args.documentation:
            types_cmd += ['-d']
        if args.exclude_from_analysis:
            types_cmd += ['-e']

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
        (stone_cmd_prefix + ['obj_c_client', dropbox_pkg_path] +
         specs + ['--', '-w', 'user', '-m', 'DBUserBaseClient', '-c', 'DBUserBaseClient',
         '-t', 'DBTransportClient', '-y', client_args, '-z', style_to_request]),
        cwd=stone_path)
    if o:
        print('Output:', o)
    o = subprocess.check_output(
        (stone_cmd_prefix + ['obj_c_client', dropbox_pkg_path] +
         specs + ['--', '-w', 'team', '-m', 'DBTeamBaseClient', '-c', 'DBTeamBaseClient',
         '-t', 'DBTransportClient', '-y', client_args, '-z', style_to_request]),
        cwd=stone_path)
    if o:
        print('Output:', o)
    o = subprocess.check_output(
        (stone_cmd_prefix + ['obj_c_client', dropbox_pkg_path] +
         specs + ['--', '-w', 'app', '-m', 'DBAppBaseClient', '-c', 'DBAppBaseClient',
         '-t', 'DBTransportClient', '-y', client_args, '-z', style_to_request]),
        cwd=stone_path)
    if o:
        print('Output:', o)

    if verbose:
        print('Formatting source files')

    cmd = ['./format_files.sh', dropbox_format_output_path]
    o = subprocess.check_output(cmd, cwd=dropbox_format_script_path)
    if o:
        print('Output:', o)


def _get_client_args():
    input_doc = "The file to upload, as an {} object."
    dest_doc = ('The file url of the desired download output location.')

    overwrite_doc = ('A boolean to set behavior in the event of a naming conflict. `YES` will '
        + 'overwrite conflicting file at destination. `NO` will take no action, resulting in an `NSError` '
        + 'returned to the response handler in the event of a file conflict.')

    download_range_start_doc = ('For partial file download. Download file beginning from this starting byte'
        + ' position. Must include valid end range value.')
    download_range_end_doc = ('For partial file download. Download file up until this ending byte position.'
        + ' Must include valid start range value.')

    client_args = {
        'upload': [
            ('upload', ['Url', [('inputUrl', 'inputUrl', 'NSString *', input_doc.format('NSString *')), ], ]),
            ('upload', ['Data', [('inputData', 'inputData', 'NSData *', input_doc.format('NSData *')), ], ]),
            ('upload', ['Stream', [('inputStream', 'inputStream', 'NSInputStream *', input_doc.format('NSInputStream *')), ], ]),
        ],
        'download': [
            ('download_url', ['Url', [('overwrite', 'overwrite', 'BOOL', overwrite_doc),
                ('destination', 'destination', 'NSURL *', dest_doc), ], ]),
            ('download_url', ['Url', [('overwrite', 'overwrite', 'BOOL', overwrite_doc),
                ('destination', 'destination', 'NSURL *', dest_doc),
                ('byteOffsetStart', 'byteOffsetStart', 'NSNumber *', download_range_start_doc),
                ('byteOffsetEnd', 'byteOffsetEnd', 'NSNumber *', download_range_end_doc)], ]),
            ('download_data', ['Data', []]),
            ('download_data', ['Data', [('byteOffsetStart', 'byteOffsetStart', 'NSNumber *', download_range_start_doc),
                ('byteOffsetEnd', 'byteOffsetEnd', 'NSNumber *', download_range_end_doc)]]),
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
