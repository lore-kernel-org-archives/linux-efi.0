From: Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>
Subject: Re: [RFC] Second attempt at kernel secure boot support
Date: Wed, 31 Oct 2012 15:55:03 +0000
Message-ID: <20121031155503.1aaf4c93@pyramind.ukuu.org.uk>
References: <1348152065-31353-1-git-send-email-mjg@redhat.com>
	<alpine.LRH.2.00.1210290848450.10392@twin.jikos.cz>
	<20121029174131.GC7580@srcf.ucam.org>
	<alpine.LNX.2.00.1210311444080.12781@pobox.suse.cz>
	<CA+5PVA63EHiXbGAox+FmJPvztSj_i7QgnDG8vdj=p0xE+dqgGQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+5PVA63EHiXbGAox+FmJPvztSj_i7QgnDG8vdj=p0xE+dqgGQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Josh Boyer <jwboyer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

> > is basically DMA-ing arbitrary data over the whole RAM. I am currently not
> > able to imagine a scenario how this could be made "secure" (without
> > storing private keys to sign the hibernation image on the machine itself
> > which, well, doesn't sound secure either).

That's what the TPM is for (in fact all of this stuff can be done
properly with a TPM while the 'secure' boot stuff can do little if any of
it.

> 
> I have a patch that disables that.  I imagine it will be included in the
> next submission of the patchset.
> 
> You can find it here in the meantime:
> 
> http://jwboyer.fedorapeople.org/pub/0001-hibernate-Disable-in-a-Secure-Boot-environment.patch

All this depends on your threat model. If I have physical access to
suspend/resume your machine then you already lost. If I don't have
physical access then I can't boot my unsigned OS to patch your S4 image
so it doesn't matter.

In fact the more I think about this the more it seems disabling hibernate
is basically farting in the wind.

Alan
