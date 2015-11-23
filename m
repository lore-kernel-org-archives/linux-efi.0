From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [PATCH v3 6/6] Documentation/x86: Update EFI memory region description
Date: Mon, 23 Nov 2015 13:33:14 +0000
Message-ID: <1448285594-17617-7-git-send-email-matt@codeblueprint.co.uk>
References: <1448285594-17617-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1448285594-17617-1-git-send-email-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Toshi Kani <toshi.kani@hp.com>, Matt Fleming <matt@codeblueprint.co.uk>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>, Linus Torvalds <torvalds@linux-foundation.org>, Dave Jones <davej@codemonkey.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, Denys Vlasenko <dvlasenk@redhat.com>, Stephen Smalley <sds@tycho.nsa.gov>, Borislav Petkov <bp@suse.de>
List-Id: linux-efi@vger.kernel.org

Make it clear that the EFI page tables are only available during EFI
runtime calls since that subject has come up a fair numbers of times
in the past.

Additionally, add the EFI region start and end addresses to the table
so that it's possible to see at a glance where they fall in relation
to other regions.

Reviewed-by: Borislav Petkov <bp@suse.de>
Cc: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@codemonkey.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Denys Vlasenko <dvlasenk@redhat.com>,
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
---

Changes in v3:
 - Make it clear that we use a 64GB chunk of virtual address space,
   not the first 64Gb addresses.

 Documentation/x86/x86_64/mm.txt | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/Documentation/x86/x86_64/mm.txt b/Documentation/x86/x86_64/mm.txt
index 05712ac83e38..c518dce7da4d 100644
--- a/Documentation/x86/x86_64/mm.txt
+++ b/Documentation/x86/x86_64/mm.txt
@@ -16,6 +16,8 @@ ffffec0000000000 - fffffc0000000000 (=44 bits) kasan shadow memory (16TB)
 ... unused hole ...
 ffffff0000000000 - ffffff7fffffffff (=39 bits) %esp fixup stacks
 ... unused hole ...
+ffffffef00000000 - ffffffff00000000 (=64 GB) EFI region mapping space
+... unused hole ...
 ffffffff80000000 - ffffffffa0000000 (=512 MB)  kernel text mapping, from phys 0
 ffffffffa0000000 - ffffffffff5fffff (=1525 MB) module mapping space
 ffffffffff600000 - ffffffffffdfffff (=8 MB) vsyscalls
@@ -32,11 +34,9 @@ reference.
 Current X86-64 implementations only support 40 bits of address space,
 but we support up to 46 bits. This expands into MBZ space in the page tables.
 
-->trampoline_pgd:
-
-We map EFI runtime services in the aforementioned PGD in the virtual
-range of 64Gb (arbitrarily set, can be raised if needed)
-
-0xffffffef00000000 - 0xffffffff00000000
+We map EFI runtime services in the 'efi_pgd' PGD in a 64Gb large virtual
+memory window (this size is arbitrary, it can be raised later if needed).
+The mappings are not part of any other kernel PGD and are only available
+during EFI runtime calls.
 
 -Andi Kleen, Jul 2004
-- 
2.6.2
