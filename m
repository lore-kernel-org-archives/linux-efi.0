From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.14 34/95] efi: Avoid potential crashes, fix the struct efi_pci_io_protocol_32 definition for mixed mode
Date: Mon, 21 May 2018 23:11:24 +0200
Message-ID: <20180521210454.955873306@linuxfoundation.org>
References: <20180521210447.219380974@linuxfoundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180521210447.219380974@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Linus Torvalds <torvalds@linux-foundation.org>, Matt Fleming <matt@codeblueprint.co.uk>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>
List-Id: linux-efi@vger.kernel.org

4.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ard Biesheuvel <ard.biesheuvel@linaro.org>

commit 0b3225ab9407f557a8e20f23f37aa7236c10a9b1 upstream.

Mixed mode allows a kernel built for x86_64 to interact with 32-bit
EFI firmware, but requires us to define all struct definitions carefully
when it comes to pointer sizes.

'struct efi_pci_io_protocol_32' currently uses a 'void *' for the
'romimage' field, which will be interpreted as a 64-bit field
on such kernels, potentially resulting in bogus memory references
and subsequent crashes.

Tested-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: <stable@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-efi@vger.kernel.org
Link: http://lkml.kernel.org/r/20180504060003.19618-13-ard.biesheuvel@linaro.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/boot/compressed/eboot.c |    6 ++++--
 include/linux/efi.h              |    8 ++++----
 2 files changed, 8 insertions(+), 6 deletions(-)

--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -163,7 +163,8 @@ __setup_efi_pci32(efi_pci_io_protocol_32
 	if (status != EFI_SUCCESS)
 		goto free_struct;
 
-	memcpy(rom->romdata, pci->romimage, pci->romsize);
+	memcpy(rom->romdata, (void *)(unsigned long)pci->romimage,
+	       pci->romsize);
 	return status;
 
 free_struct:
@@ -269,7 +270,8 @@ __setup_efi_pci64(efi_pci_io_protocol_64
 	if (status != EFI_SUCCESS)
 		goto free_struct;
 
-	memcpy(rom->romdata, pci->romimage, pci->romsize);
+	memcpy(rom->romdata, (void *)(unsigned long)pci->romimage,
+	       pci->romsize);
 	return status;
 
 free_struct:
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -395,8 +395,8 @@ typedef struct {
 	u32 attributes;
 	u32 get_bar_attributes;
 	u32 set_bar_attributes;
-	uint64_t romsize;
-	void *romimage;
+	u64 romsize;
+	u32 romimage;
 } efi_pci_io_protocol_32;
 
 typedef struct {
@@ -415,8 +415,8 @@ typedef struct {
 	u64 attributes;
 	u64 get_bar_attributes;
 	u64 set_bar_attributes;
-	uint64_t romsize;
-	void *romimage;
+	u64 romsize;
+	u64 romimage;
 } efi_pci_io_protocol_64;
 
 typedef struct {
