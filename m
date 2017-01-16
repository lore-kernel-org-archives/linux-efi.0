From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH V2 3/4] efi/x86: add debug code to print cooked memmap
Date: Mon, 16 Jan 2017 10:45:57 +0800
Message-ID: <20170116025026.533512936@redhat.com>
References: <20170116024554.461236678@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline; filename=efi-print-memmap-after-merge-ranges.patch
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Nicolai Stange <nicstange-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, mika.penttila-MRsr7dthA9VWk0Htik3J/w@public.gmane.org, bhsharma-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

It is not obvious if the reserved boot area are added correctly, add a
efi_print_memmap to print the new memmap.

Signed-off-by: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Acked-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 arch/x86/platform/efi/efi.c |    5 +++++
 1 file changed, 5 insertions(+)

--- linux-x86.orig/arch/x86/platform/efi/efi.c
+++ linux-x86/arch/x86/platform/efi/efi.c
@@ -943,6 +943,11 @@ static void __init __efi_enter_virtual_m
 		return;
 	}
 
+	if (efi_enabled(EFI_DBG)) {
+		pr_info("EFI runtime memory map:\n");
+		efi_print_memmap();
+	}
+
 	BUG_ON(!efi.systab);
 
 	if (efi_setup_page_tables(pa, 1 << pg_shift)) {
