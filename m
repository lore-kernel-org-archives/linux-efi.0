From: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
Subject: [PATCH v8 RESEND 11/38] x86/mm: Add SME support for read_cr3_pa()
Date: Tue, 27 Jun 2017 10:09:14 -0500
Message-ID: <20170627150914.17428.14700.stgit@tlendack-t1.amdoffice.net>
References: <20170627150718.17428.81813.stgit@tlendack-t1.amdoffice.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20170627150718.17428.81813.stgit-qCXWGYdRb2BnqfbPTmsdiZQ+2ll4COg0XqFh9Ls21Oc@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kasan-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Cc: Brijesh Singh <brijesh.singh-5C7GfCeVMHo@public.gmane.org>, Toshimitsu Kani <toshi.kani-ZPxbGqLxI0U@public.gmane.org>, "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Alexander Potapenko <glider-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Boris Ostrovsky <boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Radim =?utf-8?b?S3LEjW3DocWZ?= <rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Larry Woodman <lwoodman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Juergen Gross <jgross-IBi9RG/b67k@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

The cr3 register entry can contain the SME encryption mask that indicates
the PGD is encrypted.  The encryption mask should not be used when
creating a virtual address from the cr3 register, so remove the SME
encryption mask in the read_cr3_pa() function.

During early boot SME will need to use a native version of read_cr3_pa(),
so create native_read_cr3_pa().

Reviewed-by: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
Signed-off-by: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
---
 arch/x86/include/asm/processor-flags.h |    5 +++--
 arch/x86/include/asm/processor.h       |    5 +++++
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/processor-flags.h b/arch/x86/include/asm/processor-flags.h
index 79aa2f9..f5d3e50 100644
--- a/arch/x86/include/asm/processor-flags.h
+++ b/arch/x86/include/asm/processor-flags.h
@@ -2,6 +2,7 @@
 #define _ASM_X86_PROCESSOR_FLAGS_H
 
 #include <uapi/asm/processor-flags.h>
+#include <linux/mem_encrypt.h>
 
 #ifdef CONFIG_VM86
 #define X86_VM_MASK	X86_EFLAGS_VM
@@ -32,8 +33,8 @@
  * CR3_ADDR_MASK is the mask used by read_cr3_pa().
  */
 #ifdef CONFIG_X86_64
-/* Mask off the address space ID bits. */
-#define CR3_ADDR_MASK 0x7FFFFFFFFFFFF000ull
+/* Mask off the address space ID and SME encryption bits. */
+#define CR3_ADDR_MASK __sme_clr(0x7FFFFFFFFFFFF000ull)
 #define CR3_PCID_MASK 0xFFFull
 #else
 /*
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 8010c97..ab878bd 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -240,6 +240,11 @@ static inline unsigned long read_cr3_pa(void)
 	return __read_cr3() & CR3_ADDR_MASK;
 }
 
+static inline unsigned long native_read_cr3_pa(void)
+{
+	return __native_read_cr3() & CR3_ADDR_MASK;
+}
+
 static inline void load_cr3(pgd_t *pgdir)
 {
 	write_cr3(__sme_pa(pgdir));
