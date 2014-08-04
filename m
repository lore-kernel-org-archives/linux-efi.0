From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: [PATCH v2] x86/efi: Fix 3DNow optimization build failure in EFI stub
Date: Tue,  5 Aug 2014 00:12:19 +0100
Message-ID: <1407193939-27813-1-git-send-email-matt@console-pimps.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Building a 32-bit kernel with CONFIG_X86_USE_3DNOW and CONFIG_EFI_STUB
leads to the following build error,

  drivers/firmware/efi/libstub/lib.a(efi-stub-helper.o): In function `efi_relocate_kernel':
  efi-stub-helper.c:(.text+0xda5): undefined reference to `_mmx_memcpy'

This is due to the fact that the EFI boot stub pulls in the 3DNow
optimized versions of the memcpy() prototype from
arch/x86/include/asm/string_32.h, even though the _mmx_memcpy()
implementation isn't available in the EFI stub.

For now, predicate CONFIG_EFI_STUB on !CONFIG_X86_USE_3DNOW. This is
most definitely a temporary fix. A complete solution will involve
selectively including kernel headers/symbols into the early-boot
execution environment of the EFI boot stub, i.e. something analogous to
the way that the _SETUP symbol is used.

Previous attempts have been made to fix this kind of problem, though
none seem to have ever been merged,

  http://lkml.kernel.org/r/20120329104822.GA17233-eWLsEhkZJs/kLsZ8J5Uweg@public.gmane.org

Clearly, this problem has been around for a long time.

Reported-by: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: H. Peter Anvin <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Signed-off-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

---

v2: Only disallow CONFIG_X86_USE_3DNOW for EFI_STUB, not for the EFI
runtime services.
 
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 801ed36c2e49..7ea8aaaab7fc 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1536,7 +1536,7 @@ config EFI
 
 config EFI_STUB
        bool "EFI stub support"
-       depends on EFI
+       depends on EFI && !X86_USE_3DNOW
        ---help---
           This kernel feature allows a bzImage to be loaded directly
 	  by EFI firmware without the use of a bootloader.
-- 
1.9.0
