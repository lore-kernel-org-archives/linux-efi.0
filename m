From: Toshi Kani <toshi.kani-VXdhtT5mjnY@public.gmane.org>
Subject: Re: [PATCH 0/3] EFI memmap fix
Date: Mon, 16 Dec 2013 18:11:44 -0700
Message-ID: <1387242704.21140.44.camel@misato.fc.hp.com>
References: <1387236997-26975-1-git-send-email-bp@alien8.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1387236997-26975-1-git-send-email-bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: Linux EFI <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Arjan van de Ven <arjan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, 2013-12-17 at 00:36 +0100, Borislav Petkov wrote:
> From: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
> 
> Hi guys,
> 
> this is the result of Toshi and me debugging a #GP on one of his big HP
> boxes sporting UEFI. Each commit message should be self-explanatory so
> please look there.
> 
> This has more or less an RFC nature thus I'm sending it now to collect
> feedback. It is going to wait in the EFI queue anyway after the kexec
> stuff gets sorted out first.
> 
> Comments and suggestions as always are very much appreciated.
> 
> Thanks.
> 
> Borislav Petkov (3):
>   x86, ptdump: Add the functionality to dump an arbitrary pagetable
>   efi: Dump the EFI page table
>   efi: Make efi virtual runtime map passing more robust
> 
>  arch/x86/include/asm/pgtable.h |  3 +-
>  arch/x86/mm/dump_pagetables.c  | 77 ++++++++++++++++++++++++++++--------------
>  arch/x86/platform/efi/efi.c    | 68 ++++++++++++++++++++++++++++++++-----
>  3 files changed, 112 insertions(+), 36 deletions(-)
> 

Thanks for the quick turnaround!  For the series:

Tested-by: Toshi Kani <toshi.kani-VXdhtT5mjnY@public.gmane.org>

Toshi
