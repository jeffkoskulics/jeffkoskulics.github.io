---
title: "It was asleep"
description: >-
  A home NAS looked dead for fifteen seconds and I believed it. A note on
  timeouts, cheap reversible checks, and diagnosing before theorising.
tags: [debugging, measurement]
---

I have a small NAS at home, wired straight into an always-on laptop with no
switch in between. One morning it stopped answering. Ping timed out, the mount
was gone, and the share had vanished from the network.

So I started theorising. Cable, adapter, DHCP, the bridge interface, whether
some macOS update had quietly reshuffled the network stack. An hour went into
building a story about which layer had failed.

<!--more-->

The fix was renewing the DHCP lease on the wired interface. One command. It had
been available the entire time, and it was cheap, reversible, and diagnostic —
if it worked, that told me something; if it didn't, I'd lost ten seconds.

The second lesson was worse, because I'd made the same mistake in a different
shape earlier. I had once called that same host dead after a fifteen-second
timeout. It wasn't dead. Its disks had spun down, and a healthy machine waking
from disk hibernation can take far longer than fifteen seconds to answer. I had
chosen a timeout, gotten no reply inside it, and promoted "no reply yet" to
"not there."

That's a measurement error, not a network problem. I set an observation window
without checking it against the response time of the thing I was observing, and
then I trusted the result. The instrument said nothing and I recorded *absent*.

Both mistakes have the same correction, and it's the one I keep having to
relearn at work as well as at home:

**Run the cheap reversible check before you build the theory.** A theory costs
an hour and biases everything you look at afterward. Renewing a lease, power
cycling, re-seating, re-running with a longer timeout — these cost seconds and
they partition the problem space for you.

**Know your instrument's settling time.** Every measurement has one. If you
don't know what it is for the system in front of you, your timeout is not a
threshold, it's a guess, and a null result means nothing.

I wrote both of these into the notes file for that machine, at the top, in the
imperative, so the next person to debug it — which is me, six months from now,
having forgotten — reads them before touching anything.

The failure was never the NAS. It was that I trusted a number I had not
justified.
