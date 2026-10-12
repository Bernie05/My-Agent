---
description: Summarize the given text or file in a few concise bullet points
argument-hint: [text, file path, or leave blank to summarize the current conversation]
---

Summarize the following in 3-5 concise bullet points. Focus on key facts and decisions,
skip filler.

Target: $ARGUMENTS

If the target is a file of roughly 300+ lines, don't read it here: use the **digest** agent with the path (question: "key points") and turn its report into the bullets.
