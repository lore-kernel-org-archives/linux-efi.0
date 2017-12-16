From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] x86: move parse_early_param to earlier code for
 add_efi_memmap
Date: Sat, 16 Dec 2017 15:06:32 +0100
Message-ID: <20171216140632.462yk7pmlvpmz6if@gmail.com>
References: <20171130052327.GA3500@dhcp-128-65.nay.redhat.com>
 <20171214104119.GA2437@dhcp-128-65.nay.redhat.com>
 <20171215151822.GB3204@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171215151822.GB3204-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org


* Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:

> >  	x86_init.oem.arch_setup();
> > @@ -962,6 +959,8 @@ void __init setup_arch(char **cmdline_p)
> >  
> >  	parse_early_param();
> >  
> > +	if (efi_enabled(EFI_BOOT))
> > +		efi_memblock_x86_reserve_range();
> >  #ifdef CONFIG_MEMORY_HOTPLUG
> >  	/*
> >  	 * Memory used by the kernel cannot be hot-removed because Linux
> > 
> 
> I prefer this version. Please re-send a full patch and update the
> subject line to include the "fix" somewhere; it wasn't obvious to me
> from the start that this is a bug fix.

Agreed.

I dropped the commit I just applied to tip:efi/core, since you are handling this, 
so this patch should come through the regular EFI channels, right?

Thanks,

	Ingo
