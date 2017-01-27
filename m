From: Jiri Kosina <jikos@kernel.org>
Subject: [PATCH v2] x86/efi: always map first physical page into EFI
 pagetables
Date: Fri, 27 Jan 2017 16:39:59 +0100 (CET)
Message-ID: <alpine.LSU.2.20.1701271638240.25515@cbobk.fhfr.pm>
References: <alpine.LSU.2.20.1701252048550.25515@cbobk.fhfr.pm> <alpine.LSU.2.20.1701252130410.25515@cbobk.fhfr.pm> <20170127151248.GF31613@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170127151248.GF31613@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Waiman Long <waiman.long@hpe.com>, Borislav Petkov <bp@suse.de>, Laura Abbott <labbott@redhat.com>, Vojtech Pavlik <vojtech@ucw.cz>, Hanka Pavlikova <hanka@ucw.cz>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

From: Jiri Kosina <jkosina@suse.cz>

Commit 129766708 ("x86/efi: Only map RAM into EFI page tables if in 
mixed-mode") stopped creating 1:1 mapping for all RAM in case of running 
in native 64bit mode.

It turns out though that there are 64bit EFI implementations in the wild 
(this particular problem has been reported on Lenovo Yoga 710-11IKB) which 
still make use of first physical page for their own private use even 
though they explicitly mark it EFI_CONVENTIONAL_MEMORY in the memory map.

In case there is no mapping for this particular frame in EFI pagetables, 
as soon as firmware tries to make use of it, triple fault occurs and the 
system reboots (in case of Yoga 710-11IKB this is very early during boot).

Fix that by always mapping the first page of physical memory into EFI 
pagetables. We're on a safe side, as trim_bios_range() will reserve the 
first page and isolate it away from memory allocators anyway.

Note: just reverting 129766708 is not enough on v4.9-rc1+ to fix the 
regression on affected hardware, as commit ab72a27da ("x86/efi: 
Consolidate region mapping logic") later made the first physical frame not 
to be mapped anyway.

Fixes: 129766708 ("x86/efi: Only map RAM into EFI page tables if in mixed-mode")
Cc: stable@kernel.org # v4.8+
Cc: Waiman Long <waiman.long@hpe.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: Laura Abbott <labbott@redhat.com>
Cc: Vojtech Pavlik <vojtech@ucw.cz>
Reported-by: Hanka Pavlikova <hanka@ucw.cz>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---

v1 -> v2: be more explicit in commit message and in code comments
          regarding the BIOS actually marking the page in its memory
	  map as EFI_CONVENTIONAL_MEMORY

	  add a comment regarding trim_bios_range() isolating away the
	  firstpage from allocators anyway

 arch/x86/platform/efi/efi_64.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index 319148bd4b05..79c21cac1133 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -269,6 +269,22 @@ int __init efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages)
 	efi_scratch.use_pgd = true;
 
 	/*
+	 * Certain firmware versions are way too sentimential and still believe
+	 * they are exclusive and unquestionable owners of first physical page
+	 * even though they explicitly mark it as EFI_CONVENTIONAL_MEMORY
+	 * (but then write-access it later during SetVirtualAddressMap()).
+	 *
+	 * Create 1:1 mapping for this page to avoid triple faults during early
+	 * boot with such firmware. We're on a safe side, as trim_bios_range()
+	 * will reserve the first page and isolate it away from memory
+	 * allocators anyway.
+	 */
+	if (kernel_map_pages_in_pgd(pgd, 0x0, 0x0, 1, _PAGE_RW)) {
+		pr_err("Failed to create 1:1 mapping of first page\n");
+		return 1;
+	}
+
+	/*
 	 * When making calls to the firmware everything needs to be 1:1
 	 * mapped and addressable with 32-bit pointers. Map the kernel
 	 * text and allocate a new stack because we can't rely on the
-- 
Jiri Kosina
SUSE Labs
