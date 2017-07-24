From: Brijesh Singh <brijesh.singh@amd.com>
Subject: [RFC Part1 PATCH v3 03/17] x86/mm: Secure Encrypted Virtualization (SEV) support
Date: Mon, 24 Jul 2017 14:07:43 -0500
Message-ID: <20170724190757.11278-4-brijesh.singh@amd.com>
References: <20170724190757.11278-1-brijesh.singh@amd.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170724190757.11278-1-brijesh.singh@amd.com>
Sender: kvm-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, x86@kernel.org, linux-efi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@suse.de>, Andy Lutomirski <luto@kernel.org>, Tony Luck <tony.luck@intel.com>, Piotr Luc <piotr.luc@intel.com>, Tom Lendacky <thomas.lendacky@amd.com>, Fenghua Yu <fenghua.yu@intel.com>, Lu Baolu <baolu.lu@linux.intel.com>, Reza Arbab <arbab@linux.vnet.ibm.com>, David Howells <dhowells@redhat.com>, Matt Fleming <matt@codeblueprint.co.uk>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Laura Abbott <labbott@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Andrew Morton <akpm@linux-foundation.org>, Eric Biederman <ebiederm@xmission.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>Paul Mackerras <p>
List-Id: linux-efi@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

Provide support for Secure Encyrpted Virtualization (SEV). This initial
support defines a flag that is used by the kernel to determine if it is
running with SEV active.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/include/asm/mem_encrypt.h | 2 ++
 arch/x86/mm/mem_encrypt.c          | 3 +++
 include/linux/mem_encrypt.h        | 8 +++++++-
 3 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/mem_encrypt.h b/arch/x86/include/asm/mem_encrypt.h
index 8e618fc..9274ec7 100644
--- a/arch/x86/include/asm/mem_encrypt.h
+++ b/arch/x86/include/asm/mem_encrypt.h
@@ -22,6 +22,7 @@
 #ifdef CONFIG_AMD_MEM_ENCRYPT
 
 extern unsigned long sme_me_mask;
+extern unsigned int sev_enabled;
 
 void sme_encrypt_execute(unsigned long encrypted_kernel_vaddr,
 			 unsigned long decrypted_kernel_vaddr,
@@ -50,6 +51,7 @@ void swiotlb_set_mem_attributes(void *vaddr, unsigned long size);
 #else	/* !CONFIG_AMD_MEM_ENCRYPT */
 
 #define sme_me_mask	0UL
+#define sev_enabled	0
 
 static inline void __init sme_early_encrypt(resource_size_t paddr,
 					    unsigned long size) { }
diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
index 0fbd092..1e4643e 100644
--- a/arch/x86/mm/mem_encrypt.c
+++ b/arch/x86/mm/mem_encrypt.c
@@ -40,6 +40,9 @@ static char sme_cmdline_off[] __initdata = "off";
 unsigned long sme_me_mask __section(.data) = 0;
 EXPORT_SYMBOL_GPL(sme_me_mask);
 
+unsigned int sev_enabled __section(.data) = 0;
+EXPORT_SYMBOL_GPL(sev_enabled);
+
 /* Buffer used for early in-place encryption by BSP, no locking needed */
 static char sme_early_buffer[PAGE_SIZE] __aligned(PAGE_SIZE);
 
diff --git a/include/linux/mem_encrypt.h b/include/linux/mem_encrypt.h
index 1255f09..ea0831a 100644
--- a/include/linux/mem_encrypt.h
+++ b/include/linux/mem_encrypt.h
@@ -22,12 +22,18 @@
 #else	/* !CONFIG_ARCH_HAS_MEM_ENCRYPT */
 
 #define sme_me_mask	0UL
+#define sev_enabled	0
 
 #endif	/* CONFIG_ARCH_HAS_MEM_ENCRYPT */
 
 static inline bool sme_active(void)
 {
-	return !!sme_me_mask;
+	return (sme_me_mask && !sev_enabled);
+}
+
+static inline bool sev_active(void)
+{
+	return (sme_me_mask && sev_enabled);
 }
 
 static inline unsigned long sme_get_me_mask(void)
-- 
2.9.4
