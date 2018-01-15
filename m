From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.14 090/118] x86/pti: Unbreak EFI old_memmap
Date: Mon, 15 Jan 2018 13:35:17 +0100
Message-ID: <20180115123420.778955978@linuxfoundation.org>
References: <20180115123415.325497625@linuxfoundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180115123415.325497625@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, Dimitri Sivanich <sivanich@hpe.com>, Jiri Kosina <jkosina@suse.cz>, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Dave Hansen <dave.hansen@linux.intel.com>, Andrea Arcangeli <aarcange@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Linus Torvalds <torvalds@linux-foundation.org>, Matt Fleming <matt@codeblueprint.co.uk>, Peter Zijlstra <peterz@infradead.org>, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

4.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Kosina <jkosina@suse.cz>

commit de53c3786a3ce162a1c815d0c04c766c23ec9c0a upstream.

EFI_OLD_MEMMAP's efi_call_phys_prolog() calls set_pgd() with swapper PGD that
has PAGE_USER set, which makes PTI set NX on it, and therefore EFI can't
execute it's code.

Fix that by forcefully clearing _PAGE_NX from the PGD (this can't be done
by the pgprot API).

_PAGE_NX will be automatically reintroduced in efi_call_phys_epilog(), as
_set_pgd() will again notice that this is _PAGE_USER, and set _PAGE_NX on
it.

Tested-by: Dimitri Sivanich <sivanich@hpe.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-efi@vger.kernel.org
Link: http://lkml.kernel.org/r/nycvar.YFH.7.76.1801052215460.11852@cbobk.fhfr.pm
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/platform/efi/efi_64.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -134,7 +134,9 @@ pgd_t * __init efi_call_phys_prolog(void
 				pud[j] = *pud_offset(p4d_k, vaddr);
 			}
 		}
+		pgd_offset_k(pgd * PGDIR_SIZE)->pgd &= ~_PAGE_NX;
 	}
+
 out:
 	__flush_tlb_all();
 
