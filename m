From: Dominik Brodowski <linux@dominikbrodowski.net>
Subject: Re: [PATCH] Lock down drivers that can have io ports, io mem, irqs
 and dma changed
Date: Tue, 22 Nov 2016 07:12:33 +0100
Message-ID: <20161122061233.GA4762@light.dominikbrodowski.net>
References: <20161116222731.563fb85e@lxorguk.ukuu.org.uk>
 <147933283664.19316.12454053022687659937.stgit@warthog.procyon.org.uk>
 <26173.1479769852@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <26173.1479769852@warthog.procyon.org.uk>
Sender: owner-linux-security-module@vger.kernel.org
Cc: dhowells@redhat.com, keyrings@vger.kernel.org, matthew.garrett@nebula.com, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, gnomes@lxorguk.ukuu.org.uk
List-Id: linux-efi@vger.kernel.org

On Mon, Nov 21, 2016 at 11:10:52PM +0000, David Howells wrote:
> One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk> wrote:
> 
> > You need to filter or lock down kernel module options because a lot of
> > modules let you set the I/O port or similar (eg mmio) which means you can
> > hack the entire machine with say the 8250 driver just by using it with an
> > mmio of the right location to patch the secure state to zero just by
> > getting the ability to write to the modules conf file.
> 
> Is the attached patch the right sort of idea?  [Note that I haven't actually
> compiled most of these drivers to check my changes yet.]
> 
> David
> ---
> commit 8613a9655dad98c3358d82a9c4310cebdcb852ae
> Author: David Howells <dhowells@redhat.com>
> Date:   Mon Nov 21 22:43:27 2016 +0000
> 
>     Lock down drivers that can have io ports, io mem, irqs and dma changed
>     
>     Lock down drivers that can have io ports, io mem, irqs and dma channels
>     changed so that they can't be used to cause hardware to access the kernel
>     image.
>     
>     Notes:
>     
>      (1) module_isa_driver() gets an extra parameter that, if true, will cause
>          the module load to be rejected if the kernel is locked down.
>     
>      (2) module_driver() calls module_lockdown_check() to ask if the module
>          load should be rejected if the kernel is locked down.  This is a macro
>          that should be #undef'd and then redefined right before
>          module_driver() is called.
>     
>      (3) module_pci_driver() is a wrapper around module_driver(), so the same
>          macro is used as in (2).
>     
>      (4) A number of drivers use parport 'ports' - so I haven't touched those.

You might also need to disable CIS overrides and CIS firmware loading for PCMCIA
drivers, I presume. That needs two changes:

	- Abort in drivers/pcmcia/ds.c::pcmcia_load_firmware() or disable
	  the CONFIG_PCMCIA_LOAD_CIS config option permanently.

	- Abort in drivers/pcmcia/cistpl.c::pccard_store_cis() or remove
	  write access to the "cis" file in
	  drivers/pcmcia/cistpl.c::pccard_cis_attr

Best,
	Dominik
