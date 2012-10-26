From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: [PATCH 06/20] x86, efi: 1:1 pagetable mapping for virtual EFI calls
Date: Fri, 26 Oct 2012 08:51:49 +0100
Message-ID: <1351237923-10313-7-git-send-email-matt@console-pimps.org>
References: <1351237923-10313-1-git-send-email-matt@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1351237923-10313-1-git-send-email-matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Andy Whitcroft <apw-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Jan Beulich <JBeulich-IBi9RG/b67k@public.gmane.org>, Chun-Yi Lee <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, =?UTF-8?q?J=C3=A9r=C3=B4meCarretero?= <cJ-ko-WRw03QTAyf3sq35pWSNszA@public.gmane.org>, Vasco Dias <rafa.vasco-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

=46rom: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Some firmware still needs a 1:1 (virt->phys) mapping even after we've
called SetVirtualAddressMap(). So install the mapping alongside our
existing kernel mapping whenever we make EFI calls in virtual mode.

This bug was discovered on ASUS machines where the firmware
implementation of GetTime() accesses the RTC device via physical
addresses, even though that's bogus per the UEFI spec since we've
informed the firmware via SetVirtualAddressMap() that the boottime
memory map is no longer valid.

This bug seems to be present in a lot of consumer devices, so there's
not a lot we can do about this spec violation apart from workaround
it.

Cc: J=C3=A9r=C3=B4meCarretero <cJ-ko-WRw03QTAyf3sq35pWSNszA@public.gmane.org>
Cc: Vasco Dias <rafa.vasco-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Acked-by: Jan Beulich <jbeulich-IBi9RG/b67k@public.gmane.org>
Signed-off-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 arch/x86/include/asm/efi.h     | 28 +++++++++++++++++++++-------
 arch/x86/platform/efi/efi_64.c | 15 +++++++++++++++
 2 files changed, 36 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index c9dcc18..ae3bf3b 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -69,23 +69,37 @@ extern u64 efi_call6(void *fp, u64 arg1, u64 arg2, =
u64 arg3,
 	efi_call6((void *)(f), (u64)(a1), (u64)(a2), (u64)(a3),		\
 		  (u64)(a4), (u64)(a5), (u64)(a6))
=20
+extern unsigned long efi_call_virt_prelog(void);
+extern void efi_call_virt_epilog(unsigned long);
+
+#define efi_callx(x, func, ...)					\
+	({							\
+		efi_status_t __status;				\
+		unsigned long __pgd;				\
+								\
+		__pgd =3D efi_call_virt_prelog();			\
+		__status =3D efi_call##x(func, __VA_ARGS__);	\
+		efi_call_virt_epilog(__pgd);			\
+		__status;					\
+	})
+
 #define efi_call_virt0(f)				\
-	efi_call0((void *)(efi.systab->runtime->f))
+	efi_callx(0, (void *)(efi.systab->runtime->f))
 #define efi_call_virt1(f, a1)					\
-	efi_call1((void *)(efi.systab->runtime->f), (u64)(a1))
+	efi_callx(1, (void *)(efi.systab->runtime->f), (u64)(a1))
 #define efi_call_virt2(f, a1, a2)					\
-	efi_call2((void *)(efi.systab->runtime->f), (u64)(a1), (u64)(a2))
+	efi_callx(2, (void *)(efi.systab->runtime->f), (u64)(a1), (u64)(a2))
 #define efi_call_virt3(f, a1, a2, a3)					\
-	efi_call3((void *)(efi.systab->runtime->f), (u64)(a1), (u64)(a2), \
+	efi_callx(3, (void *)(efi.systab->runtime->f), (u64)(a1), (u64)(a2), =
\
 		  (u64)(a3))
 #define efi_call_virt4(f, a1, a2, a3, a4)				\
-	efi_call4((void *)(efi.systab->runtime->f), (u64)(a1), (u64)(a2), \
+	efi_callx(4, (void *)(efi.systab->runtime->f), (u64)(a1), (u64)(a2), =
\
 		  (u64)(a3), (u64)(a4))
 #define efi_call_virt5(f, a1, a2, a3, a4, a5)				\
-	efi_call5((void *)(efi.systab->runtime->f), (u64)(a1), (u64)(a2), \
+	efi_callx(5, (void *)(efi.systab->runtime->f), (u64)(a1), (u64)(a2), =
\
 		  (u64)(a3), (u64)(a4), (u64)(a5))
 #define efi_call_virt6(f, a1, a2, a3, a4, a5, a6)			\
-	efi_call6((void *)(efi.systab->runtime->f), (u64)(a1), (u64)(a2), \
+	efi_callx(6, (void *)(efi.systab->runtime->f), (u64)(a1), (u64)(a2), =
\
 		  (u64)(a3), (u64)(a4), (u64)(a5), (u64)(a6))
=20
 extern void __iomem *efi_ioremap(unsigned long addr, unsigned long siz=
e,
diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi=
_64.c
index ac3aa54..ddb0174 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -58,6 +58,21 @@ static void __init early_code_mapping_set_exec(int e=
xecutable)
 	}
 }
=20
+unsigned long efi_call_virt_prelog(void)
+{
+	unsigned long saved;
+
+	saved =3D read_cr3();
+	write_cr3(real_mode_header->trampoline_pgd);
+
+	return saved;
+}
+
+void efi_call_virt_epilog(unsigned long saved)
+{
+	write_cr3(saved);
+}
+
 void __init efi_call_phys_prelog(void)
 {
 	unsigned long vaddress;
--=20
1.7.11.7
