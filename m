From: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 06/10] arm64/efi: use UEFI memory map unconditionally if
 available
Date: Wed, 22 Oct 2014 13:29:32 -0400
Message-ID: <1413998972.2985.76.camel@deneb.redhat.com>
References: <1413987713-30528-1-git-send-email-ard.biesheuvel@linaro.org>
	 <1413987713-30528-7-git-send-email-ard.biesheuvel@linaro.org>
	 <1413997616.2985.74.camel@deneb.redhat.com>
	 <CAKv+Gu-zy-3uGtq4a9EmRBLDsG5Q0vf32_=g7+x0p4HyrXEhxg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKv+Gu-zy-3uGtq4a9EmRBLDsG5Q0vf32_=g7+x0p4HyrXEhxg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Yi Li <yi.li-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, 2014-10-22 at 19:20 +0200, Ard Biesheuvel wrote:
> On 22 October 2014 19:06, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > On Wed, 2014-10-22 at 16:21 +0200, Ard Biesheuvel wrote:
> >> On systems that boot via UEFI, all memory nodes are deleted from the
> >> device tree, and instead, the size and location of system RAM is derived
> >> from the UEFI memory map. This is handled by reserve_regions, which not only
> >> reserves parts of memory that UEFI declares as reserved, but also installs
> >> the memblocks that cover the remaining usable memory.
> >>
> >> Currently, reserve_regions() is only called if uefi_init() succeeds.
> >> However, it does not actually depend on anything that uefi_init() does,
> >> and not calling reserve_regions() results in a broken boot, so it is
> >> better to just call it unconditionally.
> >>
> >> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> >> ---
> >>  arch/arm64/kernel/efi.c | 11 ++++-------
> >>  1 file changed, 4 insertions(+), 7 deletions(-)
> >>
> >> diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
> >> index 51522ab0c6da..4cec21b1ecdd 100644
> >> --- a/arch/arm64/kernel/efi.c
> >> +++ b/arch/arm64/kernel/efi.c
> >> @@ -313,8 +313,7 @@ void __init efi_init(void)
> >>       memmap.desc_size = params.desc_size;
> >>       memmap.desc_version = params.desc_ver;
> >>
> >> -     if (uefi_init() < 0)
> >> -             return;
> >> +     WARN_ON(uefi_init() < 0);
> >>
> >>       reserve_regions();
> >>  }
> >
> > It also looks like EFI_BOOT flag will be set even if uefi_init fails.
> > If uefi_init fails, we only need reserve_regions() for the purpose
> > of adding memblocks. Otherwise, we end up wasting a lot of memory.
> 
> Indeed. But perhaps it would be cleaner to add the memblocks in a
> separate function that gets called before uefi_init(), let
> reserve_regions() do just what it name implies, and retain the above
> hunk so that the reserve_regions() call is only performed if UEFI
> initialized correctly.
> 

That works for me.
