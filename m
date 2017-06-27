From: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
Subject: [PATCH v8 RESEND 01/38] x86: Document AMD Secure Memory Encryption
	(SME)
Date: Tue, 27 Jun 2017 10:07:31 -0500
Message-ID: <20170627150731.17428.51715.stgit@tlendack-t1.amdoffice.net>
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

Create a Documentation entry to describe the AMD Secure Memory
Encryption (SME) feature and add documentation for the mem_encrypt=
kernel parameter.

Reviewed-by: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
Signed-off-by: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
---
 Documentation/admin-guide/kernel-parameters.txt |   11 ++++
 Documentation/x86/amd-memory-encryption.txt     |   68 +++++++++++++++++++++++
 2 files changed, 79 insertions(+)
 create mode 100644 Documentation/x86/amd-memory-encryption.txt

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 9b0b3de..51e03ee 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2197,6 +2197,17 @@
 			memory contents and reserves bad memory
 			regions that are detected.
 
+	mem_encrypt=	[X86-64] AMD Secure Memory Encryption (SME) control
+			Valid arguments: on, off
+			Default (depends on kernel configuration option):
+			  on  (CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT=y)
+			  off (CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT=n)
+			mem_encrypt=on:		Activate SME
+			mem_encrypt=off:	Do not activate SME
+
+			Refer to Documentation/x86/amd-memory-encryption.txt
+			for details on when memory encryption can be activated.
+
 	mem_sleep_default=	[SUSPEND] Default system suspend mode:
 			s2idle  - Suspend-To-Idle
 			shallow - Power-On Suspend or equivalent (if supported)
diff --git a/Documentation/x86/amd-memory-encryption.txt b/Documentation/x86/amd-memory-encryption.txt
new file mode 100644
index 0000000..f512ab7
--- /dev/null
+++ b/Documentation/x86/amd-memory-encryption.txt
@@ -0,0 +1,68 @@
+Secure Memory Encryption (SME) is a feature found on AMD processors.
+
+SME provides the ability to mark individual pages of memory as encrypted using
+the standard x86 page tables.  A page that is marked encrypted will be
+automatically decrypted when read from DRAM and encrypted when written to
+DRAM.  SME can therefore be used to protect the contents of DRAM from physical
+attacks on the system.
+
+A page is encrypted when a page table entry has the encryption bit set (see
+below on how to determine its position).  The encryption bit can also be
+specified in the cr3 register, allowing the PGD table to be encrypted. Each
+successive level of page tables can also be encrypted by setting the encryption
+bit in the page table entry that points to the next table. This allows the full
+page table hierarchy to be encrypted. Note, this means that just because the
+encryption bit is set in cr3, doesn't imply the full hierarchy is encyrpted.
+Each page table entry in the hierarchy needs to have the encryption bit set to
+achieve that. So, theoretically, you could have the encryption bit set in cr3
+so that the PGD is encrypted, but not set the encryption bit in the PGD entry
+for a PUD which results in the PUD pointed to by that entry to not be
+encrypted.
+
+Support for SME can be determined through the CPUID instruction. The CPUID
+function 0x8000001f reports information related to SME:
+
+	0x8000001f[eax]:
+		Bit[0] indicates support for SME
+	0x8000001f[ebx]:
+		Bits[5:0]  pagetable bit number used to activate memory
+			   encryption
+		Bits[11:6] reduction in physical address space, in bits, when
+			   memory encryption is enabled (this only affects
+			   system physical addresses, not guest physical
+			   addresses)
+
+If support for SME is present, MSR 0xc00100010 (MSR_K8_SYSCFG) can be used to
+determine if SME is enabled and/or to enable memory encryption:
+
+	0xc0010010:
+		Bit[23]   0 = memory encryption features are disabled
+			  1 = memory encryption features are enabled
+
+Linux relies on BIOS to set this bit if BIOS has determined that the reduction
+in the physical address space as a result of enabling memory encryption (see
+CPUID information above) will not conflict with the address space resource
+requirements for the system.  If this bit is not set upon Linux startup then
+Linux itself will not set it and memory encryption will not be possible.
+
+The state of SME in the Linux kernel can be documented as follows:
+	- Supported:
+	  The CPU supports SME (determined through CPUID instruction).
+
+	- Enabled:
+	  Supported and bit 23 of MSR_K8_SYSCFG is set.
+
+	- Active:
+	  Supported, Enabled and the Linux kernel is actively applying
+	  the encryption bit to page table entries (the SME mask in the
+	  kernel is non-zero).
+
+SME can also be enabled and activated in the BIOS. If SME is enabled and
+activated in the BIOS, then all memory accesses will be encrypted and it will
+not be necessary to activate the Linux memory encryption support.  If the BIOS
+merely enables SME (sets bit 23 of the MSR_K8_SYSCFG), then Linux can activate
+memory encryption by default (CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT=y) or
+by supplying mem_encrypt=on on the kernel command line.  However, if BIOS does
+not enable SME, then Linux will not be able to activate memory encryption, even
+if configured to do so by default or the mem_encrypt=on command line parameter
+is specified.
