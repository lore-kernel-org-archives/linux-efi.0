From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: Re: [PATCH] x86, efi: print debug values in Kib not MB
Date: Wed, 30 Jul 2014 00:29:32 +0200
Message-ID: <20140729222932.GA17481@pd.tnic>
References: <1406653761-3884-1-git-send-email-prarit@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1406653761-3884-1-git-send-email-prarit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Prarit Bhargava <prarit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lszubowi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Tue, Jul 29, 2014 at 01:09:21PM -0400, Prarit Bhargava wrote:
> The current debug print in EFI does
> 
> [    0.000000] efi: mem84: type=3, attr=0xf, range=[0x00000000645b5000-0x00000000645fb000) (0MB)
> 
> and rounds off the size to 0MB and isn't very useful.  We should print this in
> Kib.  After applying this patch we get better info with
> 
> [    0.000000] efi: mem84: type=3, attr=0xf, range=[0x00000000645b5000-0x00000000645fb000) (280kiB)

Turning this into kiB unconditionally won't always work ok:

First of all, there might be something which parses that output so I'd
make sure I'm not breaking that. Maybe fwts... Matt will know.

Then, I have an UEFI region which is > 13G:

[    0.000000] efi: mem42: type=7, attr=0xf, range=[0x0000000100000000-0x0000000450000000) (13568MB)


With your patch it is even worse:

[    0.000000] efi: mem42: type=7, attr=0xf, range=[0x0000000100000000-0x0000000450000000) (13893632kiB)


I'd guess you'll have to go all out and do this properly. :-)

Something like showing the highest unit which is still > 1. In the above
case, this should be (13GB) or maybe even introduce fractions.

Depends on how involved this output should be.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
