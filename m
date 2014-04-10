From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: "54b52d87268034859191d671505bb1cfce6bd74d - x86/efi: Build our
 own EFI services pointer table" breaks boot on thinkpad t440s
Date: Thu, 10 Apr 2014 13:11:46 +0100
Message-ID: <20140410121146.GA17021@console-pimps.org>
References: <AF4406ED-6B0B-4E15-A329-04162E0ADC8A@dominion.thruhere.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <AF4406ED-6B0B-4E15-A329-04162E0ADC8A-QLwJDigV5abLmq1fohREcCpxlwaOVQ5f@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Koen Kooi <koen-QLwJDigV5abLmq1fohREcCpxlwaOVQ5f@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Zhang Yanfei <zhangyanfei-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, 10 Apr, at 12:43:43PM, Koen Kooi wrote:
> Hi,
> 
> After updating from 3.14-rc7 to a recent git the kernel fails to boot on my thinkpad t440s and displays:
> 
> 	Failed to get file info size
> 	Failed to alloc highmem for files
> 
> After a morning of running git bisect and rebooting, the bad commit seems to be:
> 
> 	54b52d87268034859191d671505bb1cfce6bd74d - x86/efi: Build our own EFI services pointer table

Thanks for the report. Can you try this patch against Linus' tree?


diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index 1e6146137f8e..280165524ee4 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -112,7 +112,7 @@ __file_size64(void *__fh, efi_char16_t *filename_16,
 	efi_file_info_t *info;
 	efi_status_t status;
 	efi_guid_t info_guid = EFI_FILE_INFO_ID;
-	u32 info_sz;
+	u64 info_sz;
 
 	status = efi_early->call((unsigned long)fh->open, fh, &h, filename_16,
 				 EFI_FILE_MODE_READ, (u64)0);
-- 
Matt Fleming, Intel Open Source Technology Center
