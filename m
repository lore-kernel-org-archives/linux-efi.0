From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] Fix efifb initialisation when the only GOP device
 implements ConOut.
Date: Mon, 07 Jan 2013 17:15:23 +0000
Message-ID: <1357578923.8203.72.camel@mfleming-mobl1.ger.corp.intel.com>
References: <1357431222.9270.73.camel@shinybook.infradead.org>
	 <1357524250.9270.86.camel@shinybook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1357524250.9270.86.camel-Fexsq3y4057IgHVZqg5X0TlWvGAXklZc@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, linux-efi <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, 2013-01-07 at 02:04 +0000, David Woodhouse wrote:
> On Sun, 2013-01-06 at 00:13 +0000, David Woodhouse wrote:
> > When booting under OVMF we have precisely one GOP device, and it
> > implements the ConOut protocol.
> > 
> > We break out of the loop when we look at it... and then promptly abort
> > because 'first_gop' never gets set.
> 
> Hmmm. I've just fixed OVMF so that when qemu is invoked with the
> '-kernel' argument, it uses the EFI handover protocol. And now graphics
> is broken on kernels *without* this patch. I can't even initialise the
> graphics info in OVMF (as it does for non-EFI handover) because the
> kernel helpfully zeroes it all out before failing to set it up
> correctly.
> 
> Does it make sense to bump the boot protocol to 2.12 to indicate that
> this bug is fixed, and then let things like OVMF use the EFI handover
> protocol only for boot protocol >= 2.12? Or is there a better way...?

Bumping the boot protocol seems like a sensible idea.

Peter, any objection to that?
