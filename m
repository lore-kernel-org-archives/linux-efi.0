From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH] efi earlyprintk fix
Date: Fri, 8 Nov 2013 10:36:48 +0000
Message-ID: <20131108103648.GA2318@console-pimps.org>
References: <20131103121647.GA4770@dhcp-16-126.nay.redhat.com>
 <20131104103739.GD21688@console-pimps.org>
 <20131104125853.GB5118@dhcp-16-126.nay.redhat.com>
 <20131106092335.GA3952@dhcp-16-126.nay.redhat.com>
 <20131106093832.GC22856@console-pimps.org>
 <20131107120906.GB4116@dhcp-16-126.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20131107120906.GB4116-je1gSBvt1TcFLmT5oZ11vB/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, 07 Nov, at 08:09:06PM, Dave Young wrote:
> Here is my debug message about the efifb params (all hex values):
> [    0.000000] efi fb lfb width: 280
> [    0.000000] efi fb lfb height: 1e0
> [    0.000000] efi fb lfb base: e0000000
> [    0.000000] efi fb lfb linelength: a00
> [    0.000000] efi fb font height: 10
> [    0.000000] efi fb font width: 8
> 
> The problem looks related to the pr_cont(), here is what I observed:
> [    0.000000] efi: EFI v2.00 by Lenovo
>                     ACPI=0xdabfe000  ACPI 2.0=0xdabfe014  SMBIOS=0xdaa9e000
> [    0.000000] efi: 
> 
> After relooking the code, below fix is more reasonable than my original one,
> But I still confused why it only happens on this machine.

Dave, could you try this patch?

---

diff --git a/arch/x86/platform/efi/early_printk.c b/arch/x86/platform/efi/early_printk.c
index 6599a0027b76..81b506d5befd 100644
--- a/arch/x86/platform/efi/early_printk.c
+++ b/arch/x86/platform/efi/early_printk.c
@@ -142,7 +142,7 @@ early_efi_write(struct console *con, const char *str, unsigned int num)
 			efi_y += font->height;
 		}
 
-		if (efi_y + font->height >= si->lfb_height) {
+		if (efi_y + font->height > si->lfb_height) {
 			u32 i;
 
 			efi_y -= font->height;
-- 
Matt Fleming, Intel Open Source Technology Center
