From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 2/2] x86/efi: Add EFI framebuffer earlyprintk support
Date: Sat, 12 Oct 2013 19:56:15 +0200
Message-ID: <20131012175615.GB18849@gmail.com>
References: <1381502037-22225-1-git-send-email-matt@console-pimps.org>
 <1381502037-22225-3-git-send-email-matt@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1381502037-22225-3-git-send-email-matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org


* Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org> wrote:

> From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> It's incredibly difficult to diagnose early EFI boot issues without
> special hardware because earlyprintk=vga doesn't work on EFI systems.
> 
> Add support for writing to the EFI framebuffer, via earlyprintk=efi,
> which will actually give users a chance of providing debug output.
> 
> Cc: H. Peter Anvin <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
> Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
> Cc: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
>  Documentation/kernel-parameters.txt  |   8 +-
>  arch/x86/Kconfig.debug               |   9 ++
>  arch/x86/include/asm/efi.h           |   2 +
>  arch/x86/kernel/early_printk.c       |   6 ++
>  arch/x86/platform/efi/Makefile       |   1 +
>  arch/x86/platform/efi/early_printk.c | 191 +++++++++++++++++++++++++++++++++++
>  6 files changed, 214 insertions(+), 3 deletions(-)
>  create mode 100644 arch/x86/platform/efi/early_printk.c

Looks really nice now!

Reviewed-by: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

One detail:

> +static void early_efi_write_char(u32 *dst, unsigned char c, unsigned int h)
> +{
> +	const u32 color_black = 0x00000000;
> +	const u32 color_grey = 0x00aaaaaa;

I still think this should be white - that should be more visible than 
grey, especially in brightly lit places. (And I'm really sorry about nerds 
in the basement getting eye damage.)

Also, what is the highest byte typically, can that ever be part of 
multiple framebuffers and can it mean an alpha channel? If yes then '0x00' 
(read: fully translucent) might not be the best of choices for console 
output. In that case -1 (0xffffffff) would work in a natural way.

(If it's reserved bits then it has to be all zeroes.)

Thanks,

	Ingo
