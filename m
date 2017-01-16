From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH 5/8] efi: Get the secure boot status [ver #6]
Date: Mon, 16 Jan 2017 14:49:54 +0000
Message-ID: <20170116144954.GB27351@codeblueprint.co.uk>
References: <20170111143304.GA29649@codeblueprint.co.uk>
 <148120020832.5854.5448601415491330495.stgit@warthog.procyon.org.uk>
 <148120024570.5854.10638278395097394138.stgit@warthog.procyon.org.uk>
 <7948.1484148443@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <7948.1484148443-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

(Cc'ing Peter A. and Peter J. for boot params discussion)

On Wed, 11 Jan, at 03:27:23PM, David Howells wrote:
> Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:
> 
> > > +	movb	$0, BP_secure_boot(%rsi)
> > >  #ifdef CONFIG_EFI_STUB
> > >  	/*
> > >  	 * The entry point for the PE/COFF executable is efi_pe_entry, so
> > 
> > Is clearing ::secure_boot really necessary? Any code path that goes
> > via efi_main() will set it correctly and all other code paths should
> > get it cleared in sanitize_boot_params(), no?
> 
> No.
> 
> The boot_params->secure_boot parameter exists whether or not efi_main() is
> traversed (ie. if EFI isn't enabled or CONFIG_EFI_STUB=n) and, if not cleared,
> is of uncertain value.
>
> Further, sanitize_boot_params() has to be modified by this patch so as not to
> clobber the secure_boot flag.

Any new parameters that boot loaders do not know about should be
cleared to zero by default in the boot loader because boot_params
itself should be zero'd when allocated.

There are two cases to consider:

 1) boot_params is not zero'd
 2) boot_params is zero'd

1) This is a broken boot loader implementation that violates the x86
boot specification and I would never expect ->secure_boot to have a
valid value. It should not be special-cased in sanitize_boot_params(),
it should be zero'd.

2) In this case ->secure_boot should be zero unless modified inside of
efi_main().

Did you hit the scenario where ->secure_boot has a garbage value while
developing these patches? I wouldn't expect to see it in practice.
