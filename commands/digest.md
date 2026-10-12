---
description: "Digest a large file (log, CI output, long doc, diff) into the few lines you need, without loading it into this conversation"
argument-hint: "<path> [more paths] [question, e.g. why did the build fail]"
---

Use the **digest** agent for: $ARGUMENTS

If the arguments contain no file path but a command to inspect (e.g. "the test output"), run that command yourself with its output redirected to a file in the scratchpad or `/tmp` (`<command> > <file> 2>&1`) and pass that path; don't print the output here.

Relay its report as-is (it's already short). Only open the cited `file:line` locations yourself if the next step needs them.
