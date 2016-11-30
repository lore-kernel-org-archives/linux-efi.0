From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] Lock down drivers that can have io ports, io mem, irqs and dma changed
Date: Wed, 30 Nov 2016 16:25:38 +0000
Message-ID: <31255.1480523138@warthog.procyon.org.uk>
References: <20161130144105.2b6be4fe@lxorguk.ukuu.org.uk> <2cd73312-c074-1367-6daa-710d11ac68f1@acm.org> <a4642e43-4598-96ca-c25a-2bd844631a47@acm.org> <20161116222731.563fb85e@lxorguk.ukuu.org.uk> <147933283664.19316.12454053022687659937.stgit@warthog.procyon.org.uk> <26173.1479769852@warthog.procyon.org.uk> <10164.1480378260@warthog.procyon.org.uk> <6973.1480428211@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161130144105.2b6be4fe-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>
Content-ID: <31254.1480523138.1-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: One Thousand Gnomes <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, minyard-HInyCGIudOg@public.gmane.org, jforbes-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

One Thousand Gnomes <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org> wrote:

> > I thought that if I'm changing the module_param annotations anyway then it's
> > probably worth bunging in an extra parameter that notes what the parameter
> > modifies (ioport, iomem, etc.) for future reference, even if we don't store
> > it.
> 
> With a security hat on the security best practice and long standing
> accepted rule is that you whitelist rather than blacklist, so there ought
> to be a 
> 
> module_param_safe_array()
> etc
> 
> to mark parameters that are safe, not the reverse.

Whilst that may be true, it's a lot more work.  Mind you, that said, you can
take the annotations I've made and script the inverse.

> That debate aside I think the patch is exactly what is needed for this,
> and is probably useful for more general hardening as well.

Okay, I've done a preliminary patchset, labelling all the parameters that
appear to be associated with hardware details and pushed them here:

	http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=efi-lock-down

The patch that modifies the module parameter header is labelled:

	Lock down module params that specify hardware parameters (eg. ioport)

and all the driver dir lockdown patches follow that.

I still need to do a bit of commenting in that patch and add various
maintainer cc's in the other patches.

David
