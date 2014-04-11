From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: "54b52d87268034859191d671505bb1cfce6bd74d - x86/efi: Build our
 own EFI services pointer table" breaks boot on thinkpad t440s
Date: Fri, 11 Apr 2014 09:20:44 +0200
Message-ID: <20140411072044.GA15418@gmail.com>
References: <AF4406ED-6B0B-4E15-A329-04162E0ADC8A@dominion.thruhere.net>
 <20140410121146.GA17021@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140410121146.GA17021-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: Koen Kooi <koen-QLwJDigV5abLmq1fohREcCpxlwaOVQ5f@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Zhang Yanfei <zhangyanfei-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org


* Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org> wrote:

> On Thu, 10 Apr, at 12:43:43PM, Koen Kooi wrote:
> > Hi,
> > 
> > After updating from 3.14-rc7 to a recent git the kernel fails to boot on my thinkpad t440s and displays:
> > 
> > 	Failed to get file info size
> > 	Failed to alloc highmem for files
> > 
> > After a morning of running git bisect and rebooting, the bad commit seems to be:
> > 
> > 	54b52d87268034859191d671505bb1cfce6bd74d - x86/efi: Build our own EFI services pointer table
> 
> Thanks for the report. Can you try this patch against Linus' tree?
> 
> 
> diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
> index 1e6146137f8e..280165524ee4 100644
> --- a/arch/x86/boot/compressed/eboot.c
> +++ b/arch/x86/boot/compressed/eboot.c
> @@ -112,7 +112,7 @@ __file_size64(void *__fh, efi_char16_t *filename_16,
>  	efi_file_info_t *info;
>  	efi_status_t status;
>  	efi_guid_t info_guid = EFI_FILE_INFO_ID;
> -	u32 info_sz;
> +	u64 info_sz;

Might be prudent to do the same in __file_size32(), instead of 
truncating silently, especially is that function too has a u64 output 
AFAICS.

Also, while reviewing the file I noticed that there's "u32 fb_base", 
which is recovered like:

                status = __gop_query64(gop64, &info, &size, &fb_base);

but ->frame_buffer_base is u64. Is it always guaranteed u32?

Thanks,

	Ingo
