From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 01/16] Add the ability to lock down access to the running kernel image
Date: Sun, 25 Dec 2016 21:44:29 +0000
Message-ID: <26272.1482702269@warthog.procyon.org.uk>
References: <20161225212023.GB26891@amd> <147933283664.19316.12454053022687659937.stgit@warthog.procyon.org.uk> <147933284407.19316.17886320817060158597.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161225212023.GB26891@amd>
Content-ID: <26271.1482702269.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Pavel Machek <pavel@ucw.cz>
Cc: dhowells@redhat.com, keyrings@vger.kernel.org, matthew.garrett@nebula.com, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

Pavel Machek <pavel@ucw.cz> wrote:

> > +config ALLOW_LOCKDOWN_LIFT
> > +	bool
> 
> Don't you need to add 'bool "something"' so that user can actually
> select this?

No - see patch 6.  This option merely makes the function available.  Actually,
I haven't done it quite right: the function in the .c file should be
conditionalised too.

David
