From: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: EFI_STUB fails to boot non-EFI on arm64
Date: Fri, 23 May 2014 16:03:31 +0100
Message-ID: <20140523150331.GS4179@bivouac.eciton.net>
References: <20140523094513.GC9252@arm.com>
 <20140523131656.GR4179@bivouac.eciton.net>
 <20140523134720.GA9256@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140523134720.GA9256-5wv7dgnIgG8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
Cc: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, May 23, 2014 at 02:47:20PM +0100, Catalin Marinas wrote:
> That's a first (possibly temporary) step and I think it's fine:
> 
> Acked-by: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
> 
> But we need some further tweaking to the way we call efi_init().
> Currently it doesn't matter whether Linux booted as an EFI application
> or not and efi_init() is always called, causing some pr_err() in
> fdt_find_uefi_params(). It's not really an error as we support the same
> image booting non-EFI as well.

OK.

> Can we add another of detecting whether it's an EFI application and
> avoid calling efi_init()? I can see x86 sets some efi_loader_signature
> string in exit_boot() and checks against it later when calling
> efi_init().

Well, I agree that we shouldn't be spewing error messages for expected
operation, but efi_init() is the function we call to determine
whether we _are_ booting via UEFI - and it sets flags accordingly for
the efi_enabled() macro.

My view is that this should be fixed in fdt_find_uefi_params(). A
single info message that we can't find evidence of UEFI should be
printed in the non-error case.

Like below?

/
    Leif

>From 67283e60923c14c024460b4512c49563a92acce7 Mon Sep 17 00:00:00 2001
From: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Date: Fri, 23 May 2014 15:50:51 +0100
Subject: [PATCH] efi: fdt: Drop error messages for non-error case

Change fdt_find_uefi_params() to only write error messages if actual
error encountered, rather than if no UEFI information is encountered.
For the non-error case, print a single info message.

Signed-off-by: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 drivers/firmware/efi/efi.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index cd36deb..4bb42e1e 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -366,11 +366,8 @@ static int __init fdt_find_uefi_params(unsigned long node, const char *uname,
 
 	for (i = 0; i < ARRAY_SIZE(dt_params); i++) {
 		prop = of_get_flat_dt_prop(node, dt_params[i].propname, &len);
-		if (!prop) {
-			pr_err("Can't find %s in device tree!\n",
-			       dt_params[i].name);
-			return 0;
-		}
+		if (!prop)
+			goto fail;
 		dest = info->params + dt_params[i].offset;
 
 		val = of_read_number(prop, len / sizeof(u32));
@@ -385,6 +382,14 @@ static int __init fdt_find_uefi_params(unsigned long node, const char *uname,
 				dt_params[i].size * 2, val);
 	}
 	return 1;
+
+	fail:
+	if (i == 0)
+		pr_info("  UEFI not found.\n");
+	else
+		pr_err("Can't find %s in device tree!\n", dt_params[i].name);
+
+	return 0;
 }
 
 int __init efi_get_fdt_params(struct efi_fdt_params *params, int verbose)
-- 
1.7.10.4
