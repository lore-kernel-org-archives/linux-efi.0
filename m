From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] Lock down drivers that can have io ports, io mem, irqs and dma changed
Date: Tue, 29 Nov 2016 00:11:00 +0000
Message-ID: <10164.1480378260@warthog.procyon.org.uk>
References: <a4642e43-4598-96ca-c25a-2bd844631a47@acm.org> <20161116222731.563fb85e@lxorguk.ukuu.org.uk> <147933283664.19316.12454053022687659937.stgit@warthog.procyon.org.uk> <26173.1479769852@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <a4642e43-4598-96ca-c25a-2bd844631a47@acm.org>
Content-ID: <10163.1480378260.1@warthog.procyon.org.uk>
Sender: owner-linux-security-module@vger.kernel.org
To: minyard@acm.org
Cc: dhowells@redhat.com, One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>, keyrings@vger.kernel.org, matthew.garrett@nebula.com, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

Corey Minyard <minyard@acm.org> wrote:

> This would prevent any IPMI interface from working if any address was given
> on the kernel command line. I'm not sure what the best policy is, but that
> sounds like a possible DOS to me.

Okay, reasonable point.

> Can you put this check in hardcode_find_bmc()?  Thats the only place where
> the hardcoded addresses are used, and a check there won't affect anything
> else.

I could do that.  I presume you'd want hardcode_find_bmc() to return 1 in that
case without doing anything else.  Another possibility is to give a warning
and then clear ports[], addrs[] and irqs[].

> Also, the error message sounds a little vague to me.  If I was a sysadmin
> and got this, I wouldn't be sure what was going on.  Maybe something like:
> The kernel is locked down, but hard-coded device addresses were given on
> the driver command line.  Ignoring these, but this is a possible security
> issue.
>
> That's fairly wordy, but it gets the point across.  You could also move the
> pr_err() into kernel_is_locked_down() and pass in the prefix, since there is
> basically the same pr_err() after every check.

I don't think your suggested summary quite gets it right.  A lot of drivers,
sound drivers, for example, that aren't really critical can simply be
disabled - and some have to be disabled because there's no other way to
configure them.

It would have to be more like pr_err("Hard-coded device addresses, irqs and
dma channels are not permitted when the kernel is locked down."), possibly
with the addition of either "The driver has been disabled" or "These settings
have been ignored".

David
