From: Dominik Brodowski <linux@dominikbrodowski.net>
Subject: Re: [PATCH] Lock down drivers that can have io ports, io mem, irqs
 and dma changed
Date: Wed, 23 Nov 2016 20:21:43 +0100
Message-ID: <20161123192143.GA482@light.dominikbrodowski.net>
References: <20161122061233.GA4762@light.dominikbrodowski.net>
 <20161116222731.563fb85e@lxorguk.ukuu.org.uk>
 <147933283664.19316.12454053022687659937.stgit@warthog.procyon.org.uk>
 <26173.1479769852@warthog.procyon.org.uk>
 <8342.1479905906@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <8342.1479905906@warthog.procyon.org.uk>
Sender: owner-linux-security-module@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: keyrings@vger.kernel.org, matthew.garrett@nebula.com, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, gnomes@lxorguk.ukuu.org.uk
List-Id: linux-efi@vger.kernel.org

On Wed, Nov 23, 2016 at 12:58:26PM +0000, David Howells wrote:
> Dominik Brodowski <linux@dominikbrodowski.net> wrote:
> 
> > You might also need to disable CIS overrides and CIS firmware loading for
> > PCMCIA drivers, I presume. That needs two changes:
> > 
> > 	- Abort in drivers/pcmcia/ds.c::pcmcia_load_firmware() or disable
> > 	  the CONFIG_PCMCIA_LOAD_CIS config option permanently.
> 
> This really ought to be handled through signature checking in
> request_firmware().
> 
> > 	- Abort in drivers/pcmcia/cistpl.c::pccard_store_cis() or remove
> > 	  write access to the "cis" file in
> > 	  drivers/pcmcia/cistpl.c::pccard_cis_attr
> 
> What is that doing?  Allowing the device to be reconfigured?

Exactly. It is a different interface for updating the firmware -- which
includes ioports etc. In theory, any access should be limited to areas which
are registered to the bridge devices. But you never know...

Best
	Dominik

