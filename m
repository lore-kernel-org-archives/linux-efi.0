From: Brijesh Singh <brijesh.singh-5C7GfCeVMHo@public.gmane.org>
Subject: [RFC Part1 PATCH v3 01/17] Documentation/x86: Add AMD Secure Encrypted Virtualization (SEV) descrption
Date: Mon, 24 Jul 2017 14:07:41 -0500
Message-ID: <20170724190757.11278-2-brijesh.singh@amd.com>
References: <20170724190757.11278-1-brijesh.singh@amd.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170724190757.11278-1-brijesh.singh-5C7GfCeVMHo@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxppc-dev-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Piotr Luc <piotr.luc-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>, Fenghua Yu <fenghua.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Lu Baolu <baolu.lu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Reza Arbab <arbab-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "Kirill A . Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Laura Abbott <labbott-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Eric Biederman <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>Paul Mackerras <p>
List-Id: linux-efi@vger.kernel.org

Update amd-memory-encryption document describing the AMD Secure Encrypted
Virtualization (SEV) feature.

Signed-off-by: Brijesh Singh <brijesh.singh-5C7GfCeVMHo@public.gmane.org>
---
 Documentation/x86/amd-memory-encryption.txt | 29 ++++++++++++++++++++++++++---
 1 file changed, 26 insertions(+), 3 deletions(-)

diff --git a/Documentation/x86/amd-memory-encryption.txt b/Documentation/x86/amd-memory-encryption.txt
index f512ab7..747df07 100644
--- a/Documentation/x86/amd-memory-encryption.txt
+++ b/Documentation/x86/amd-memory-encryption.txt
@@ -1,4 +1,5 @@
-Secure Memory Encryption (SME) is a feature found on AMD processors.
+Secure Memory Encryption (SME) and Secure Encrypted Virtualization (SEV) are
+features found on AMD processors.
 
 SME provides the ability to mark individual pages of memory as encrypted using
 the standard x86 page tables.  A page that is marked encrypted will be
@@ -6,6 +7,12 @@ automatically decrypted when read from DRAM and encrypted when written to
 DRAM.  SME can therefore be used to protect the contents of DRAM from physical
 attacks on the system.
 
+SEV enables running encrypted virtual machine (VMs) in which the code and data
+of the virtual machine are secured so that decrypted version is available only
+within the VM itself. SEV guest VMs have concept of private and shared memory.
+Private memory is encrypted with the guest-specific key, while shared memory
+may be encrypted with hypervisor key.
+
 A page is encrypted when a page table entry has the encryption bit set (see
 below on how to determine its position).  The encryption bit can also be
 specified in the cr3 register, allowing the PGD table to be encrypted. Each
@@ -19,11 +26,20 @@ so that the PGD is encrypted, but not set the encryption bit in the PGD entry
 for a PUD which results in the PUD pointed to by that entry to not be
 encrypted.
 
-Support for SME can be determined through the CPUID instruction. The CPUID
-function 0x8000001f reports information related to SME:
+When SEV is enabled, certain type of memory (namely insruction pages and guest
+page tables) are always treated as private. Due to security reasons all DMA
+operations inside the guest must be performed on shared memory. Since the
+memory encryption bit is only controllable by the guest OS when it is operating
+in 64-bit or 32-bit PAE mode, in all other modes the SEV hardware forces memory
+encryption bit to 1.
+
+Support for SME and SEV can be determined through the CPUID instruction. The
+CPUID function 0x8000001f reports information related to SME:
 
 	0x8000001f[eax]:
 		Bit[0] indicates support for SME
+	0x800001f[eax]:
+		Bit[1] indicates support for SEV
 	0x8000001f[ebx]:
 		Bits[5:0]  pagetable bit number used to activate memory
 			   encryption
@@ -39,6 +55,13 @@ determine if SME is enabled and/or to enable memory encryption:
 		Bit[23]   0 = memory encryption features are disabled
 			  1 = memory encryption features are enabled
 
+If SEV is supported, MSR 0xc0010131 (MSR_F17H_SEV) can be used to determine if
+SEV is active:
+
+	0xc0010131:
+		Bit[0]	  0 = memory encryption is not active
+			  1 = memory encryption is active
+
 Linux relies on BIOS to set this bit if BIOS has determined that the reduction
 in the physical address space as a result of enabling memory encryption (see
 CPUID information above) will not conflict with the address space resource
-- 
2.9.4
