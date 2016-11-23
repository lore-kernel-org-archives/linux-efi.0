From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] Lock down drivers that can have io ports, io mem, irqs and dma changed
Date: Wed, 23 Nov 2016 12:58:26 +0000
Message-ID: <8342.1479905906@warthog.procyon.org.uk>
References: <20161122061233.GA4762@light.dominikbrodowski.net> <20161116222731.563fb85e@lxorguk.ukuu.org.uk> <147933283664.19316.12454053022687659937.stgit@warthog.procyon.org.uk> <26173.1479769852@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161122061233.GA4762@light.dominikbrodowski.net>
Content-ID: <8341.1479905906.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: dhowells@redhat.com, keyrings@vger.kernel.org, matthew.garrett@nebula.com, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, gnomes@lxorguk.ukuu.org.uk
List-Id: linux-efi@vger.kernel.org

Dominik Brodowski <linux@dominikbrodowski.net> wrote:

> You might also need to disable CIS overrides and CIS firmware loading for
> PCMCIA drivers, I presume. That needs two changes:
> 
> 	- Abort in drivers/pcmcia/ds.c::pcmcia_load_firmware() or disable
> 	  the CONFIG_PCMCIA_LOAD_CIS config option permanently.

This really ought to be handled through signature checking in
request_firmware().

> 	- Abort in drivers/pcmcia/cistpl.c::pccard_store_cis() or remove
> 	  write access to the "cis" file in
> 	  drivers/pcmcia/cistpl.c::pccard_cis_attr

What is that doing?  Allowing the device to be reconfigured?

David
