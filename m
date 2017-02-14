From: Thomas Garnier <thgarnie@google.com>
Subject: [PATCH v3 4/4] KVM: VMX: Simplify segment_base
Date: Tue, 14 Feb 2017 11:42:59 -0800
Message-ID: <20170214194259.75960-4-thgarnie@google.com>
References: <20170214194259.75960-1-thgarnie@google.com>
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <20170214194259.75960-1-thgarnie@google.com>
Sender: linux-pm-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, Thomas Garnier <thgarnie@google.com>, Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@suse.de>, Paul Gortmaker <paul.gortmaker@windriver.com>, Andy Lutomirski <luto@amacapital.net>, "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Jiri Kosina <jikos@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Juergen Gross <jgross@suse.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, linux-pm@vger.kernel.org, linux-efi@vger.kernel.org, xen-devel@lists.xenproject.org, lguest@lists.ozlabs.org, kvm@vger.kernel.org, kernel-hardening@lists.openwall.com
List-Id: linux-efi@vger.kernel.org

The KVM segment_base function is confusing. This patch replaces integers
with appropriate flags, simplify constructs and add comments.

Signed-off-by: Thomas Garnier <thgarnie@google.com>
---
Based on next-20170213
---
 arch/x86/kvm/vmx.c | 26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 99167f20bc34..edb8326108dd 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -2062,25 +2062,35 @@ static unsigned long segment_base(u16 selector)
 	struct desc_struct *d;
 	unsigned long table_base;
 	unsigned long v;
+	u32 high32;
 
-	if (!(selector & ~3))
+	if (!(selector & ~SEGMENT_RPL_MASK))
 		return 0;
 
-	table_base = get_current_gdt_rw_vaddr();
-
-	if (selector & 4) {           /* from ldt */
+	/* LDT selector */
+	if ((selector & SEGMENT_TI_MASK) == SEGMENT_LDT) {
 		u16 ldt_selector = kvm_read_ldt();
 
-		if (!(ldt_selector & ~3))
+		if (!(ldt_selector & ~SEGMENT_RPL_MASK))
 			return 0;
 
 		table_base = segment_base(ldt_selector);
+	} else {
+		table_base = get_current_gdt_rw_vaddr();
 	}
-	d = (struct desc_struct *)(table_base + (selector & ~7));
+
+	d = (struct desc_struct *)table_base + (selector >> 3);
 	v = get_desc_base(d);
 #ifdef CONFIG_X86_64
-       if (d->s == 0 && (d->type == 2 || d->type == 9 || d->type == 11))
-               v |= ((unsigned long)((struct ldttss_desc64 *)d)->base3) << 32;
+	/*
+	 * Extend the virtual address if we have a system descriptor entry for
+	 * LDT or TSS (available or busy).
+	 */
+	if (d->s == 0 && (d->type == DESC_LDT || d->type == DESC_TSS ||
+			  d->type == 11/*Busy TSS */)) {
+		high32 = ((struct ldttss_desc64 *)d)->base3;
+		v |= (u64)high32 << 32;
+	}
 #endif
 	return v;
 }
-- 
2.11.0.483.g087da7b7c-goog

