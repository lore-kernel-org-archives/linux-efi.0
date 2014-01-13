From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH 1/2] efi: Fix krealloc defect
Date: Mon, 13 Jan 2014 14:03:34 +0000
Message-ID: <20140113140334.GB3256@console-pimps.org>
References: <cover.1388793978.git.joe@perches.com>
 <9a8eb1c9478049318e834d5223053a5fb7484bff.1388793978.git.joe@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <9a8eb1c9478049318e834d5223053a5fb7484bff.1388793978.git.joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Fri, 03 Jan, at 04:08:47PM, Joe Perches wrote:
> krealloc should use a temporary pointer for allocations
> and check the temporary pointer returned against NULL too.
> 
> Signed-off-by: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
> cc: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
> ---
>  arch/x86/platform/efi/efi.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)

Thanks Joe, but I've already got the following commit queued up from
Borislav that addresses this,

---

>From ee41143027706d9f342dfe05487a00b20887fde7 Mon Sep 17 00:00:00 2001
From: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
Date: Thu, 31 Oct 2013 17:25:09 +0100
Subject: [PATCH] x86/efi: Check krealloc return value

Check it just in case. We might just as well panic there because runtime
won't be functioning anyway.

Signed-off-by: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
Signed-off-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 arch/x86/platform/efi/efi.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index b453069236fd..3fac4dee492f 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -860,6 +860,9 @@ void __init efi_enter_virtual_mode(void)
 		new_memmap = krealloc(new_memmap,
 				      (count + 1) * memmap.desc_size,
 				      GFP_KERNEL);
+		if (!new_memmap)
+			goto err_out;
+
 		memcpy(new_memmap + (count * memmap.desc_size), md,
 		       memmap.desc_size);
 		count++;
@@ -914,6 +917,11 @@ void __init efi_enter_virtual_mode(void)
 			 EFI_VARIABLE_BOOTSERVICE_ACCESS |
 			 EFI_VARIABLE_RUNTIME_ACCESS,
 			 0, NULL);
+
+	return;
+
+ err_out:
+	pr_err("Error reallocating memory, EFI runtime non-functional!\n");
 }
 
 /*
-- 
1.8.3.1

-- 
Matt Fleming, Intel Open Source Technology Center
