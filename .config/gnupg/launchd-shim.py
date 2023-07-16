#!/usr/bin/env python3

import contextlib
import sys
import os
import fcntl
import ctypes
import ctypes.util

from os.path import join as path_join
from socket import socket

from ctypes import byref, c_int, c_size_t, POINTER

libSystem = ctypes.CDLL(ctypes.util.find_library('System'))


# https://github.com/ihaveamac/random-tools/blob/8c4ddb72642ece22ffa698c6843e76cfb062f89d/launchd-stuff/launchdsocket.py
def launch_activate_socket(name: str):
    fds = POINTER(c_int)()
    count = c_size_t()

    res = libSystem.launch_activate_socket(
        name.encode('utf-8'), byref(fds), byref(count))
    if res:
        raise OSError(res, os.strerror(res))

    sockets = [socket(fileno=fds[s]) for s in range(count.value)]
    libSystem.free(fds)
    if len(sockets) != 1:
        raise Exception('Expected single socket entry')
    return sockets[0]


def silent_unlink(path):
    try:
        os.unlink(path)
    except FileNotFoundError:
        pass


def main(argv):
    GNUPGHOME = os.getenv("GNUPGHOME") or os.path.expanduser('~/.gnupg')
    AGENT_SOCKS = {
        'std': path_join(GNUPGHOME, 'S.gpg-agent'),
        'extra': path_join(GNUPGHOME, 'S.gpg-agent.extra'),
        'ssh': path_join(GNUPGHOME, 'S.gpg-agent.ssh'),
        'browser': path_join(GNUPGHOME, 'S.gpg-agent.browser'),
    }

    listen_fdnames = os.getenv('LISTEN_FDNAMES') or ''

    for agent_sock in AGENT_SOCKS.values():
        silent_unlink(agent_sock)

    for name in listen_fdnames.split(':'):
        if name not in AGENT_SOCKS:
            raise Exception(f'Unknown agent socket: {name}')

        sock = launch_activate_socket(name)

        path = sock.getsockname()
        sock.set_inheritable(True)
        fd = sock.detach()

        # print(name, fd, path)
        os.symlink(path, AGENT_SOCKS[name])

    os.putenv('LISTEN_PID', str(os.getpid()))
    sys.stdout.flush()

    os.execvp(argv[1], argv[1:] + ['--supervised'])


if __name__ == '__main__':
    sys.exit(main(sys.argv))
