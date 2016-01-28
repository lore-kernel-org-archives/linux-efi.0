From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH v10 1/1] efi: a misc char interface for user to update
 efi firmware
Date: Thu, 28 Jan 2016 12:16:02 +0000
Message-ID: <20160128121602.GD2571@codeblueprint.co.uk>
References: <F54AEECA5E2B9541821D670476DAE19C4A8ABF06@PGSMSX102.gar.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <F54AEECA5E2B9541821D670476DAE19C4A8ABF06-j2khPEwRog0FyVwBAnZdSLfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Kweh, Hock Leong" <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "Ong, Boon Leong" <boon.leong.ong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sam Protsenko <semen.protsenko-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Anvin, H Peter" <h.peter.anvin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, 26 Jan, at 03:10:03AM, Kweh Hock Leong wrote:
> > 
> > This mutex is not needed. It doesn't protect anything in your code.
> 
> This is to synchronize/serializes one of the instant is calling efi_capsule_supported()
> and the other one is calling efi_capsule_update() which they are exported symbol
> from capsule.c.
 
You don't need to synchronise them.

Looking at my original capsule patches I can see why you might be
doing this locking, but it's unnecessary. You don't need to serialise
access to efi_capsule_supported() and efi_capsule_update().

Internally to the core EFI capsule code we need to ensure that we
don't allow capsules with conflicting reset types to be sent to the
firmware (how would we know the type of reset to perform?), but that
should be entirely transparent to your driver.  

I'm planning on re-sending my capsule patches, so all this should
become clearer.

> > This function would be much more simple if you handled the above
> > condition differently.
> > 
> > Instead of having code in efi_capsule_setup_info() to allocate the
> > initial ->pages memory, why not just allocate it in efi_capsule_open()
> > at the same time as you allocate the private_data? You can then
> > free it in efi_capsule_release() (you're leaking it at the moment).
> > 
> > You are always going to need at least one element in ->pages for
> > successful operation, so you might as well allocate it up front.
> 
> Just want to double check I understand you correctly. Do you mean
> I should free ->pages during close(2) but not free the ->pages[X] if
> there is any successfully submitted?

Yes, that's correct.
