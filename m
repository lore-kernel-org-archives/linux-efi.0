From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] Lock down drivers that can have io ports, io mem, irqs and dma changed
Date: Thu, 24 Nov 2016 17:34:45 +0000
Message-ID: <30473.1480008885@warthog.procyon.org.uk>
References: <20161123192143.GA482@light.dominikbrodowski.net> <20161122061233.GA4762@light.dominikbrodowski.net> <20161116222731.563fb85e@lxorguk.ukuu.org.uk> <147933283664.19316.12454053022687659937.stgit@warthog.procyon.org.uk> <26173.1479769852@warthog.procyon.org.uk> <8342.1479905906@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161123192143.GA482-SGhQLRGLuNwb6pqDj42GsMgv3T4z79SOrE5yTffgRl4@public.gmane.org>
Content-ID: <30472.1480008885.1-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dominik Brodowski <linux-X3ehHDuj6sIIGcDfoQAp7OTW4wlIGRCZ@public.gmane.org>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Dominik Brodowski <linux-X3ehHDuj6sIIGcDfoQAp7OTW4wlIGRCZ@public.gmane.org> wrote:

> > > 	- Abort in drivers/pcmcia/cistpl.c::pccard_store_cis() or remove
> > > 	  write access to the "cis" file in
> > > 	  drivers/pcmcia/cistpl.c::pccard_cis_attr
> > 
> > What is that doing?  Allowing the device to be reconfigured?
> 
> Exactly. It is a different interface for updating the firmware -- which
> includes ioports etc. In theory, any access should be limited to areas which
> are registered to the bridge devices. But you never know...

Ah, I see.  Should this be using request_firmware()?

David
