From: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
Subject: Re: EFI_STUB fails to boot non-EFI on arm64
Date: Wed, 28 May 2014 16:59:31 +0100
Message-ID: <20140528155931.GA20523@arm.com>
References: <20140523094513.GC9252@arm.com>
 <20140523131656.GR4179@bivouac.eciton.net>
 <20140523134720.GA9256@arm.com>
 <20140523150331.GS4179@bivouac.eciton.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140523150331.GS4179-t77nlHhSwNqAroYi2ySoxKxOck334EZe@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Catalin Marinas <Catalin.Marinas-5wv7dgnIgG8@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, May 23, 2014 at 04:03:31PM +0100, Leif Lindholm wrote:
> On Fri, May 23, 2014 at 02:47:20PM +0100, Catalin Marinas wrote:
> > Can we add another of detecting whether it's an EFI application and
> > avoid calling efi_init()? I can see x86 sets some efi_loader_signature
> > string in exit_boot() and checks against it later when calling
> > efi_init().
> 
> Well, I agree that we shouldn't be spewing error messages for expected
> operation, but efi_init() is the function we call to determine
> whether we _are_ booting via UEFI - and it sets flags accordingly for
> the efi_enabled() macro.
> 
> My view is that this should be fixed in fdt_find_uefi_params(). A
> single info message that we can't find evidence of UEFI should be
> printed in the non-error case.
> 
> Like below?

Why not move the efi_get_fdt_params call out of efi_init and into
setup_arch via a wrapper? Then efi_get_fdt_params and efi_init can have
useful return values, which allow us to distinguish between "My DT doesn't
have the necessary UEFI properties" and "UEFI failed to initialise" without
having to make some printks pr_info and others pr_err within efi_init
itself..

Will
