From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] Lock down drivers that can have io ports, io mem, irqs and dma changed
Date: Tue, 29 Nov 2016 10:40:03 +0000
Message-ID: <20242.1480416003@warthog.procyon.org.uk>
References: <10164.1480378260@warthog.procyon.org.uk> <a4642e43-4598-96ca-c25a-2bd844631a47@acm.org> <20161116222731.563fb85e@lxorguk.ukuu.org.uk> <147933283664.19316.12454053022687659937.stgit@warthog.procyon.org.uk> <26173.1479769852@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <10164.1480378260@warthog.procyon.org.uk>
Content-ID: <20241.1480416003.1@warthog.procyon.org.uk>
Sender: owner-linux-security-module@vger.kernel.org
To: minyard@acm.org
Cc: dhowells@redhat.com, One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>, keyrings@vger.kernel.org, matthew.garrett@nebula.com, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

David Howells <dhowells@redhat.com> wrote:

> It would have to be more like pr_err("Hard-coded device addresses, irqs and
> dma channels are not permitted when the kernel is locked down."), possibly
> with the addition of either "The driver has been disabled" or "These settings
> have been ignored".

That should be "Command line-specified" rather than "Hard-coded".  The latter
are actually okay.

A better way to do this would probably be to annotate the module parameter
declarations and have the module_param() invoker reject the locked-down
parameters.  I'm not sure how easy that would be to do, though.

David
