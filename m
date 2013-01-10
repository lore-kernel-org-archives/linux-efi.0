From: David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: [PATCH 4/6] x86, efi: Add loadflags for EFI handover support in 32-bit and 64-bit mode
Date: Thu, 10 Jan 2013 18:04:26 +0000
Message-ID: <1357841068-6582-4-git-send-email-dwmw2@infradead.org>
References: <1357841068-6582-1-git-send-email-dwmw2@infradead.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1357841068-6582-1-git-send-email-dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

From: David Woodhouse <David.Woodhouse-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

As it is, the bootloader has no idea whether the kernel's EFI boot stub
is 32-bit or 64-bit. If it gets it wrong, we'll get bizarre crashes; it
won't even get the *entry* point right because of the weird implicit
added 0x200 for the 64-bit entry points.

This patch adds flags to indicate support for 32-bit vs. 64-bit mode.

In future, it would be possible to support both in the same kernel. We
can't make EFI runtime calls to 32-bit EFI from a 64-bit kernel, or
vice versa, but with the old entry point it used to at least *boot*, and
the EFI handover protocol ought to retain that functionality.

As an added bonus, stop setting handover_offset when CONFIG_EFI_STUB
isn't even set, and asking the bootloader to jump to where we *would*
have placed the entry point.

Signed-off-by: David Woodhouse <David.Woodhouse-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 Documentation/x86/boot.txt | 45 ++++++++++++++++++++++++++++++++++++++-------
 arch/x86/boot/header.S     |  6 ++++--
 2 files changed, 42 insertions(+), 9 deletions(-)

diff --git a/Documentation/x86/boot.txt b/Documentation/x86/boot.txt
index 406d82d..0841b21 100644
--- a/Documentation/x86/boot.txt
+++ b/Documentation/x86/boot.txt
@@ -401,6 +401,14 @@ Protocol:	2.00+
 	- If 0, the protected-mode code is loaded at 0x10000.
 	- If 1, the protected-mode code is loaded at 0x100000.
 
+  Bit 1 (read):	EFI_STUB_32
+	- If 0, the EFI handover protocol is not supported in 32-bit mode.
+	- If 1, the EFI handover protocol is supported in 32-bit mode.
+
+  Bit 2 (read):	EFI_STUB_64
+	- If 0, the EFI handover protocol is not supported in 64-bit mode.
+	- If 1, the EFI handover protocol is supported in 64-bit mode.
+
   Bit 5 (write): QUIET_FLAG
 	- If 0, print early messages.
 	- If 1, suppress early messages.
@@ -702,12 +710,15 @@ Field name:	handover_offset
 Type:		read
 Offset/size:	0x264/4
 
-  This field is the offset from the beginning of the kernel image to
-  the EFI handover protocol entry point. Boot loaders using the EFI
-  handover protocol to boot the kernel should jump to this offset.
-
-  See EFI HANDOVER PROTOCOL below for more details.
+  This field indicates the location of the EFI handover protocol entry
+  point. See EFI HANDOVER PROTOCOL below for more details.
 
+  NOTE: For 32-bit support, this field contains the offset from the
+  beginning of the kernel image as one might expect. For 64-bit support,
+  for historical reasons 0x200 must be added to the value of this field.
+  For example, if the value of the handover_offset field is 0x30, the
+  64-bit EFI entry point is actually 0x230 bytes into the kernel code.
+  Do not ask why.
 
 **** THE IMAGE CHECKSUM
 
@@ -1034,8 +1045,23 @@ address of the struct boot_params; %ebp, %edi and %ebx must be zero.
 This protocol allows boot loaders to defer initialisation to the EFI
 boot stub. The boot loader is required to load the kernel/initrd(s)
 from the boot media and jump to the EFI handover protocol entry point
-which is hdr->handover_offset bytes from the beginning of
-startup_{32,64}.
+which is indicated by the hdr->handover_offset field.
+
+The appropriate (32-bit or 64-bit) EFI boot stub must be called according
+to the version of EFI running on the system. A kernel may support either,
+both, or neither entry point. The bootloader should check the EFI_STUB_32
+or EFI_STUB_64 flag in the load_flags field as appropriate. If the entry
+point appropriate for the system's implementation of EFI is not supported
+by the kernel, then the bootloader should invoke the 'legacy' entry point
+as normal.
+
+If invoking the 32-bit entry point, it is found at the offset indicated
+by the handover_offset field of the setup header, and obviously must be
+invoked with the CPU in 32-bit mode.
+
+If invoking the 64-bit entry point, it is found at an offset 0x200 greater
+than the value of the handover_offset field, and the CPU must be in 64-bit
+mode.
 
 The function prototype for the handover entry point looks like this,
 
@@ -1055,3 +1081,8 @@ The boot loader *must* fill out the following fields in bp,
     o hdr.ramdisk_size  (if applicable)
 
 All other fields should be zero.
+
+Note that the efi_main() entry point uses Linux/ELF calling conventions,
+not EFI calling conventions. So for x86_64, 'handle' is in %rdi, 'table'
+in %rsi and 'bp' in %rdx. For i386, the ABI is the same: the arguments
+(and return address) are on the stack.
diff --git a/arch/x86/boot/header.S b/arch/x86/boot/header.S
index 8c132a6..318264e 100644
--- a/arch/x86/boot/header.S
+++ b/arch/x86/boot/header.S
@@ -303,7 +303,8 @@ CAN_USE_HEAP	= 0x80			# If set, the loader also has set
 					# space behind setup.S can be used for
 					# heap purposes.
 					# Only the loader knows what is free
-		.byte	LOADED_HIGH
+EFIFLAGS = IS_ENABLED(CONFIG_EFI_STUB) << (1 + IS_ENABLED(CONFIG_X86_64))
+		.byte	LOADED_HIGH + EFIFLAGS
 
 setup_move_size: .word  0x8000		# size to move, when setup is not
 					# loaded at 0x90000. We will move setup
@@ -397,7 +398,8 @@ pref_address:		.quad LOAD_PHYSICAL_ADDR	# preferred load addr
 #define INIT_SIZE VO_INIT_SIZE
 #endif
 init_size:		.long INIT_SIZE		# kernel initialization size
-handover_offset:	.long 0x30		# offset to the handover
+handover_offset:	.long 0x30 * IS_ENABLED(CONFIG_EFI_STUB)
+						# offset to the handover
 						# protocol entry point
 
 # End of setup header #####################################################
-- 
1.8.0.1
