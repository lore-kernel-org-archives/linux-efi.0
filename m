From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: 91f606a8fa ("x86/mm: Replace compile-time checks for 5-level
 .."): BUG: kernel reboot-without-warning in boot stage
Date: Tue, 27 Feb 2018 11:21:42 +0300
Message-ID: <20180227082142.7qxtlcx3hkb22abn@node.shutemov.name>
References: <5a94243e.XdjEw/cR1zAcoW8q%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5a94243e.XdjEw/cR1zAcoW8q%fengguang.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: kernel test robot <fengguang.wu@intel.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, LKP <lkp@01.org>, linux-pm@vger.kernel.org, linux-efi@vger.kernel.org, kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, wfg@linux.intel.com
List-Id: linux-efi@vger.kernel.org

On Mon, Feb 26, 2018 at 11:14:06PM +0800, kernel test robot wrote:
> Greetings,
> 
> 0day kernel testing robot got the below dmesg and the first bad commit is
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86/mm
> 
> commit 91f606a8fa68264224cbc76888fa8649cdbe9990
> Author:     Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> AuthorDate: Wed Feb 14 21:25:41 2018 +0300
> Commit:     Ingo Molnar <mingo@kernel.org>
> CommitDate: Fri Feb 16 10:48:49 2018 +0100
> 
>     x86/mm: Replace compile-time checks for 5-level paging with runtime-time checks
>     
>     This patch converts the of CONFIG_X86_5LEVEL check to runtime checks for
>     p4d folding.
>     
>     Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
>     Cc: Andy Lutomirski <luto@kernel.org>
>     Cc: Arjan van de Ven <arjan@linux.intel.com>
>     Cc: Borislav Petkov <bp@suse.de>
>     Cc: Dan Williams <dan.j.williams@intel.com>
>     Cc: Dave Hansen <dave.hansen@linux.intel.com>
>     Cc: David Woodhouse <dwmw2@infradead.org>
>     Cc: Josh Poimboeuf <jpoimboe@redhat.com>
>     Cc: Linus Torvalds <torvalds@linux-foundation.org>
>     Cc: Peter Zijlstra <peterz@infradead.org>
>     Cc: Thomas Gleixner <tglx@linutronix.de>
>     Cc: linux-mm@kvack.org
>     Link: http://lkml.kernel.org/r/20180214182542.69302-9-kirill.shutemov@linux.intel.com
>     Signed-off-by: Ingo Molnar <mingo@kernel.org>
> 
> 98219dda2a  x86/mm: Fold p4d page table layer at runtime
> 91f606a8fa  x86/mm: Replace compile-time checks for 5-level paging with runtime-time checks
> 1ea4fe8497  Merge branch 'x86/boot' into x86/mm, to unify branches
> 94991480c2  Merge branch 'x86/pti'
> f1753f6424  Add linux-next specific files for 20180226

Patch below should help. Please check.

diff --git a/arch/x86/include/asm/pgtable_64.h b/arch/x86/include/asm/pgtable_64.h
index 81dda8d1d0bd..163e01a0631d 100644
--- a/arch/x86/include/asm/pgtable_64.h
+++ b/arch/x86/include/asm/pgtable_64.h
@@ -224,9 +224,9 @@ static inline void native_set_p4d(p4d_t *p4dp, p4d_t p4d)
 		return;
 	}
 
-	pgd = native_make_pgd(p4d_val(p4d));
+	pgd = native_make_pgd(native_p4d_val(p4d));
 	pgd = pti_set_user_pgd((pgd_t *)p4dp, pgd);
-	*p4dp = native_make_p4d(pgd_val(pgd));
+	*p4dp = native_make_p4d(native_pgd_val(pgd));
 }
 
 static inline void native_p4d_clear(p4d_t *p4d)
-- 
 Kirill A. Shutemov
