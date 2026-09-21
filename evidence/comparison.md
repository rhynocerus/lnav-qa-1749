# Cross-host comparison

## Summary

| Test | lnav | XDG state | Runs | Observed result |
|---|---:|---|---:|---|
| Host 1 original | 0.14.1 | existing/default state | within 30 | REPRODUCED |
| Host 1 clean XDG | 0.14.1 | isolated clean XDG_CONFIG_HOME | 100 | NOT REPRODUCED |
| Host 2 | 0.11.2 | default | 100 | NOT REPRODUCED |
| Host 2 | 0.14.1 | isolated clean XDG_CONFIG_HOME | 100 | NOT REPRODUCED |

## Host 1 clean-XDG result

lnav 0.14.1 remained attached to LastTest.log after all 100 CTest runs.

Observed inode distribution:

    50 inode=26107351
    50 inode=26107361

The reported message:

    No log or text files are currently loaded

was not observed.

## Host 2 clean-XDG result

lnav 0.14.1 also remained attached to LastTest.log after 100 CTest runs.

Observed inode distribution:

    41 inode=32531634
     9 inode=32531635
    50 inode=32531644

## Interpretation

The same lnav version, 0.14.1, produced different observed outcomes
between the original Host 1 run and the later clean-XDG Host 1 run.

This weakens a simple version-only regression hypothesis.

The results are consistent with several possibilities, including
persistent state/configuration differences or intermittent timing/state,
but they do not establish any of these as the root cause.

The clean-XDG result does not prove that XDG state caused the original
failure, and the negative 100-run tests do not prove that the issue
cannot occur.
