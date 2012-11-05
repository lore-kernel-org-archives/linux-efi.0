From: Josh Boyer <jwboyer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH RFC 0/4] Add firmware signature file check
Date: Mon, 5 Nov 2012 15:43:09 -0500
Message-ID: <CA+5PVA52rjx+E6tDcoiy+7tj+ZrYO0yHevdMUpvL-vuRcTkDKA@mail.gmail.com>
References: <1348152065-31353-1-git-send-email-mjg@redhat.com>
	<alpine.LRH.2.00.1210290848450.10392@twin.jikos.cz>
	<20121029174131.GC7580@srcf.ucam.org>
	<s5hobjia6vj.wl%tiwai@suse.de>
	<20121031173728.GA18615@srcf.ucam.org>
	<s5h390utqv3.wl%tiwai@suse.de>
	<1351743715.21227.95.camel@linux-s257.site>
	<20121101131849.752df6fd@pyramind.ukuu.org.uk>
	<s5hip9k9dng.wl%tiwai@suse.de>
	<s5hhap49den.wl%tiwai@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <s5hhap49den.wl%tiwai-l3A5Bk7waGM@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Takashi Iwai <tiwai-l3A5Bk7waGM@public.gmane.org>
Cc: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, joeyli <jlee-IBi9RG/b67k@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Mon, Nov 5, 2012 at 12:18 PM, Takashi Iwai <tiwai-l3A5Bk7waGM@public.gmane.org> wrote:
> Hi,
>
> this is a patch series to add the support for firmware signature
> check.  At this time, the kernel checks extra signature file (*.sig)
> for each firmware, instead of embedded signature.
> It's just a quick hack using the existing module signing mechanism,
> thus provided only as a proof of concept for now.
>
> To be noted, it doesn't support the firmwares via udev but only the
> direct loading, and the check for built-in firmware is missing, too.

Just to make sure I'm reading this correctly, it will sign any of the
firwmare files installed directly from the kernel tree if the option is
set.  So for the firmware in the linux-firmware tree we'd need to
either copy that into the kernel tree during build time, or duplicate the
signing bits in the linux-firmware tree itself.  However if we do the
latter, we'd probably need to use the same keys as the per-build kernel
key which means copying keys (ew) or tell the kernel to include a
separate firmware key in the extra list.

I feel like I'm rambling a bit, but I'm trying to work out how signed
firmware would look from a distro perspective.  A significant amount of
work has been done to decouple linux-firmware from the kernel tree and
if signed firmware is used it seems to couple them together one way or
another.  At the moment, using generated per-build keys to come up with
the firmware signatures seems a bit suboptimal in that regard.

josh
