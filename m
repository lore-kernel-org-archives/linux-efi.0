From: Brijesh Singh <brijesh.singh-5C7GfCeVMHo@public.gmane.org>
Subject: [RFC Part1 PATCH v3 06/17] x86/mm: Use encrypted access of boot related data with SEV
Date: Mon, 24 Jul 2017 14:07:46 -0500
Message-ID: <20170724190757.11278-7-brijesh.singh@amd.com>
References: <20170724190757.11278-1-brijesh.singh@amd.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170724190757.11278-1-brijesh.singh-5C7GfCeVMHo@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxppc-dev-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Piotr Luc <piotr.luc-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>, Fenghua Yu <fenghua.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Lu Baolu <baolu.lu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Reza Arbab <arbab-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "Kirill A . Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Laura Abbott <labbott-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Eric Biederman <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>Paul Mackerras <p>
List-Id: linux-efi@vger.kernel.org

From: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>

When Secure Encrypted Virtualization (SEV) is active, boot data (such as
EFI related data, setup data) is encrypted and needs to be accessed as
such when mapped. Update the architecture override in early_memremap to
keep the encryption attribute when mapping this data.

Signed-off-by: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
Signed-off-by: Brijesh Singh <brijesh.singh-5C7GfCeVMHo@public.gmane.org>
---
 arch/x86/mm/ioremap.c | 44 ++++++++++++++++++++++++++++++++------------
 1 file changed, 32 insertions(+), 12 deletions(-)

diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 34f0e18..c0be7cf 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -422,6 +422,9 @@ void unxlate_dev_mem_ptr(phys_addr_t phys, void *addr)
  * areas should be mapped decrypted. And since the encryption key can
  * change across reboots, persistent memory should also be mapped
  * decrypted.
+ *
+ * If SEV is active, that implies that BIOS/UEFI also ran encrypted so
+ * only persistent memory should be mapped decrypted.
  */
 static bool memremap_should_map_decrypted(resource_size_t phys_addr,
 					  unsigned long size)
@@ -458,6 +461,11 @@ static bool memremap_should_map_decrypted(resource_size_t phys_addr,
 	case E820_TYPE_ACPI:
 	case E820_TYPE_NVS:
 	case E820_TYPE_UNUSABLE:
+		/* For SEV, these areas are encrypted */
+		if (sev_active())
+			break;
+		/* Fallthrough */
+
 	case E820_TYPE_PRAM:
 		return true;
 	default:
@@ -581,7 +589,7 @@ static bool __init early_memremap_is_setup_data(resource_size_t phys_addr,
 bool arch_memremap_can_ram_remap(resource_size_t phys_addr, unsigned long size,
 				 unsigned long flags)
 {
-	if (!sme_active())
+	if (!sme_active() && !sev_active())
 		return true;
 
 	if (flags & MEMREMAP_ENC)
@@ -590,10 +598,15 @@ bool arch_memremap_can_ram_remap(resource_size_t phys_addr, unsigned long size,
 	if (flags & MEMREMAP_DEC)
 		return false;
 
-	if (memremap_is_setup_data(phys_addr, size) ||
-	    memremap_is_efi_data(phys_addr, size) ||
-	    memremap_should_map_decrypted(phys_addr, size))
-		return false;
+	if (sme_active()) {
+		if (memremap_is_setup_data(phys_addr, size) ||
+		    memremap_is_efi_data(phys_addr, size) ||
+		    memremap_should_map_decrypted(phys_addr, size))
+			return false;
+	} else if (sev_active()) {
+		if (memremap_should_map_decrypted(phys_addr, size))
+			return false;
+	}
 
 	return true;
 }
@@ -608,15 +621,22 @@ pgprot_t __init early_memremap_pgprot_adjust(resource_size_t phys_addr,
 					     unsigned long size,
 					     pgprot_t prot)
 {
-	if (!sme_active())
+	if (!sme_active() && !sev_active())
 		return prot;
 
-	if (early_memremap_is_setup_data(phys_addr, size) ||
-	    memremap_is_efi_data(phys_addr, size) ||
-	    memremap_should_map_decrypted(phys_addr, size))
-		prot = pgprot_decrypted(prot);
-	else
-		prot = pgprot_encrypted(prot);
+	if (sme_active()) {
+		if (early_memremap_is_setup_data(phys_addr, size) ||
+		    memremap_is_efi_data(phys_addr, size) ||
+		    memremap_should_map_decrypted(phys_addr, size))
+			prot = pgprot_decrypted(prot);
+		else
+			prot = pgprot_encrypted(prot);
+	} else if (sev_active()) {
+		if (memremap_should_map_decrypted(phys_addr, size))
+			prot = pgprot_decrypted(prot);
+		else
+			prot = pgprot_encrypted(prot);
+	}
 
 	return prot;
 }
-- 
2.9.4
