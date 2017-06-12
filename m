From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.9 034/119] efi: Dont issue error message when booted under Xen
Date: Mon, 12 Jun 2017 17:24:56 +0200
Message-ID: <20170612152558.830902210@linuxfoundation.org>
References: <20170612152556.601664278@linuxfoundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20170612152556.601664278@linuxfoundation.org>
Sender: stable-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, Juergen Gross <jgross@suse.com>, Matt Fleming <matt@codeblueprint.co.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>
List-Id: linux-efi@vger.kernel.org

4.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Juergen Gross <jgross@suse.com>

commit 1ea34adb87c969b89dfd83f1905a79161e9ada26 upstream.

When booted as Xen dom0 there won't be an EFI memmap allocated. Avoid
issuing an error message in this case:

  [    0.144079] efi: Failed to allocate new EFI memmap

Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-efi@vger.kernel.org
Link: http://lkml.kernel.org/r/20170526113652.21339-2-matt@codeblueprint.co.uk
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/platform/efi/quirks.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/x86/platform/efi/quirks.c
+++ b/arch/x86/platform/efi/quirks.c
@@ -358,6 +358,9 @@ void __init efi_free_boot_services(void)
 		free_bootmem_late(start, size);
 	}
 
+	if (!num_entries)
+		return;
+
 	new_size = efi.memmap.desc_size * num_entries;
 	new_phys = efi_memmap_alloc(num_entries);
 	if (!new_phys) {
