From: Borislav Petkov <bp@suse.de>
Subject: Re: [RFC Part1 PATCH v3 13/17] x86/io: Unroll string I/O when SEV is
 active
Date: Fri, 15 Sep 2017 14:24:30 +0200
Message-ID: <20170915122430.pnroy6vsg53warel@pd.tnic>
References: <20170724190757.11278-1-brijesh.singh@amd.com>
 <20170724190757.11278-14-brijesh.singh@amd.com>
 <063D6719AE5E284EB5DD2968C1650D6DD003FB85@AcuExch.aculab.com>
 <CAK8P3a3h7JpmkW7W=HwqAuWWmro=ngj6HSeiiML_=T82x-FtZQ@mail.gmail.com>
 <ed6d4ce7-97a6-f664-d7d7-4ff48bc6f06a@amd.com>
 <201707261927.v6QJR228008075@mail.zytor.com>
 <589d65a4-eb09-bae9-e8b4-a2d78ca6b509@amd.com>
 <20170822165248.rkbluikdgduu7ucy@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170822165248.rkbluikdgduu7ucy@pd.tnic>
Sender: linux-kernel-owner@vger.kernel.org
To: Brijesh Singh <brijesh.singh@amd.com>, Tom Lendacky <thomas.lendacky@amd.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>, David Laight <David.Laight@aculab.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Fenghua Yu <fenghua.yu@intel.com>, Matt Fleming <matt@codeblueprint.co.uk>, David Howells <dhowells@redhat.com>, Paul Mackerras <paulus@samba.org>, Christoph Lameter <cl@linux.com>, Jonathan Corbet <corbet@lwn.net>, Radim =?utf-8?Q?Krcm=C3=A1r?= <rkrcmar@redhat.com>, Piotr Luc <piotr.luc@intel.com>, Ingo Molnar <mingo@redhat.com>, Dave Airlie <airlied@redhat.com>, Kees Cook <keescook@chr>
List-Id: linux-efi@vger.kernel.org

On Tue, Aug 22, 2017 at 06:52:48PM +0200, Borislav Petkov wrote:
> As always, the devil is in the detail.

Ok, actually we can make this much simpler by using a static key. A
conceptual patch below - I only need to fix that crazy include hell I'm
stepping into with this.

In any case, we were talking about having a static branch already so
this fits the whole strategy.

---
diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
index d174b1c4a99e..e45369158632 100644
--- a/arch/x86/mm/mem_encrypt.c
+++ b/arch/x86/mm/mem_encrypt.c
@@ -45,6 +45,8 @@ EXPORT_SYMBOL_GPL(sme_me_mask);
 unsigned int sev_enabled __section(.data) = 0;
 EXPORT_SYMBOL_GPL(sev_enabled);
 
+DEFINE_STATIC_KEY_FALSE(__sev);
+
 /* Buffer used for early in-place encryption by BSP, no locking needed */
 static char sme_early_buffer[PAGE_SIZE] __aligned(PAGE_SIZE);
 
@@ -790,6 +792,7 @@ void __init __nostackprotector sme_enable(struct boot_params *bp)
 		/* SEV state cannot be controlled by a command line option */
 		sme_me_mask = me_mask;
 		sev_enabled = 1;
+		static_branch_enable(&__sev);
 		return;
 	}
 
diff --git a/include/linux/mem_encrypt.h b/include/linux/mem_encrypt.h
index ea0831a8dbe2..f3ab965a3d6a 100644
--- a/include/linux/mem_encrypt.h
+++ b/include/linux/mem_encrypt.h
@@ -13,6 +13,8 @@
 #ifndef __MEM_ENCRYPT_H__
 #define __MEM_ENCRYPT_H__
 
+#include <linux/jump_label.h>
+
 #ifndef __ASSEMBLY__
 
 #ifdef CONFIG_ARCH_HAS_MEM_ENCRYPT
@@ -26,6 +28,8 @@
 
 #endif	/* CONFIG_ARCH_HAS_MEM_ENCRYPT */
 
+extern struct static_key_false __sev;
+
 static inline bool sme_active(void)
 {
 	return (sme_me_mask && !sev_enabled);
@@ -33,7 +37,7 @@ static inline bool sme_active(void)
 
 static inline bool sev_active(void)
 {
-	return (sme_me_mask && sev_enabled);
+	return static_branch_unlikely(&__sev);
 }
 
 static inline unsigned long sme_get_me_mask(void)

-- 
Regards/Gruss,
    Boris.

SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
-- 
