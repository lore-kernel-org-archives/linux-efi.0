From: Nick Desaulniers <ndesaulniers@google.com>
Subject: [PATCH v5 0/3] extern inline native_save_fl for paravirt
Date: Wed, 13 Jun 2018 14:05:15 -0700
Message-ID: <20180613210518.113983-1-ndesaulniers@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: akpm@linux-foundation.org, hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, virtualization@lists.linux-foundation.org, astrachan@google.com, manojgupta@google.com, ghackmann@google.com, sedat.dilek@gmail.com, tstellar@redhat.com, keescook@google.com, yamada.masahiro@socionext.com, michal.lkml@markovi.net, linux-kbuild@vger.kernel.org, geert@linux-m68k.org, will.deacon@arm.com, mawilcox@microsoft.com, arnd@arndb.de, rientjes@google.com, acme@redhat.com, pombredanne@nexb.com, aryabinin@virtuozzo.com, kstewart@linuxfoundation.org, boris.ostrovsky@oracle.com, jan.kiszka@siemens.com, rostedt@goodmis.org, kirill.shutemov@linux.intel.com, ard.biesheuvel@linaro.org, akataria@vmware.com, brijesh.singh@amd.com, caoj.fnst@cn.fujitsu.com, gregkh@linuxfoundation.org, jarkko.sakkinen@linux.intel.co
List-Id: linux-efi@vger.kernel.org

paravirt depends on a custom calling convention (callee saved), but
expects this from a static inline function that it then forces to be
outlined. This is problematic because different compilers or flags can
then add a stack guard that violates the calling conventions.

Uses extern inline with the out-of-line definition in assembly to
prevent compilers from adding stack guards to the outlined version.

Other parts of the codebase overwrite KBUILD_CFLAGS, which is *extremely
problematic* for extern inline, as the sematics are completely the
opposite depending on what C standard is used.
http://blahg.josefsipek.net/?p=529

Changes since v4:
  Take Arnd's and hpa's suggestions properly feature detect gnu_inline
  attribute to support gcc 4.1.

Changes since v3:
  Take Joe's suggestion to hoist __inline__ and __inline out of
  conditional block.

Changes since v2:
  Take hpa's _ASM_ARG patch into the set in order to simplify cross
  32b/64b x86 assembly and rebase my final patch to use it.  Apply
  Sedat's typo fix to commit message and sign off on it. Take Joe's
  suggestion to simplify __inline__ and __inline. Add Arnd to list of
  folks who made helpful suggestions.

Changes since v1:
  Prefer gnu_inline function attribute instead of explicitly setting C
  standard compiler flag in problematic Makefiles. We should instead
  carefully evaluate if those Makefiles should be overwriting
  KBUILD_CFLAGS at all. Dropped the previous first two patches and added
  a new first patch.

H. Peter Anvin (1):
  x86/asm: add _ASM_ARG* constants for argument registers to <asm/asm.h>

Nick Desaulniers (2):
  compiler-gcc.h: add gnu_inline to all inline declarations
  x86: paravirt: make native_save_fl extern inline

 arch/x86/include/asm/asm.h      | 59 +++++++++++++++++++++++++++++++++
 arch/x86/include/asm/irqflags.h |  2 +-
 arch/x86/kernel/Makefile        |  1 +
 arch/x86/kernel/irqflags.S      | 26 +++++++++++++++
 include/linux/compiler-gcc.h    | 29 ++++++++++++----
 5 files changed, 109 insertions(+), 8 deletions(-)
 create mode 100644 arch/x86/kernel/irqflags.S

-- 
2.18.0.rc1.244.gcf134e6275-goog
