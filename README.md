# lnav QA reproduction for tstack/lnav#1749

Independent reproduction and investigation of
[tstack/lnav#1749](https://github.com/tstack/lnav/issues/1749).

## Environment

- Linux Mint 22.1 Xia
- Linux kernel 6.8.0-139-generic
- x86_64
- lnav 0.14.1
- CMake / CTest 3.28.3
- TERM=xterm-256color
- Bash

## Reproduced behavior

Opening CTest's `LastTest.log` directly with:

    lnav build/Testing/Temporary/LastTest.log

and repeatedly running CTest eventually causes lnav 0.14.1 to display:

    No log or text files are currently loaded
    Use the :open command to open a file or directory

All 30 CTest runs passed successfully.

## Reproduction

Run:

    ./run-repro.sh

The script executes CTest repeatedly while recording the inode, size,
and modification time of `LastTest.log`.

## inode observation

Across 30 executions, `LastTest.log` alternated between two inode values:

    15 inode=26107355
    15 inode=26107359

Example:

    run=1 inode=26107359
    run=2 inode=26107355
    run=3 inode=26107359
    run=4 inode=26107355

This shows that CTest is not modifying one file in place.

## strace observation

CTest creates a temporary log and replaces the pathname:

    openat(.../LastTest.log.tmp, O_WRONLY|O_CREAT|O_TRUNC, 0666)
    rename(.../LastTest.log.tmp, .../LastTest.log) = 0

This suggests that the lnav behavior may be related to handling a file
whose pathname is replaced through `rename()`.

This observation does not establish the root cause inside lnav.

## Directory test

Opening `build/Testing/Temporary/` instead of `LastTest.log` directly did
not leave lnav with zero loaded files during 30 further CTest runs.

Other files were also present, so this does not prove that lnav
successfully reattached specifically to `LastTest.log`.

## Scope

This repository contains an independent QA reproducer and investigation.
It is not a fork of lnav and does not contain lnav source code.

## Follow-up comparison

Additional testing was performed across two hosts and with isolated
XDG configuration state.

Summary:

| Test | lnav | XDG state | Runs | Result |
|---|---:|---|---:|---|
| Host 1 original | 0.14.1 | existing/default state | within 30 | REPRODUCED |
| Host 1 clean XDG | 0.14.1 | isolated clean XDG_CONFIG_HOME | 100 | NOT REPRODUCED |
| Host 2 | 0.11.2 | default | 100 | NOT REPRODUCED |
| Host 2 | 0.14.1 | isolated clean XDG_CONFIG_HOME | 100 | NOT REPRODUCED |

The Host 1 clean-XDG run remained attached to LastTest.log for all
100 CTest executions.

The same lnav version therefore produced different observed outcomes
between the original Host 1 run and the later clean-XDG run.

This weakens a simple version-only regression hypothesis, but does not
establish XDG state, timing, or any other factor as the root cause.

See evidence/comparison.md and evidence/host1-clean-xdg/ for details.
