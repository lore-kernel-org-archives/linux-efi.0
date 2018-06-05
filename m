From: Nick Desaulniers <ndesaulniers@google.com>
Subject: [PATCH v2 0/2] extern inline native_save_fl for paravirt
Date: Tue,  5 Jun 2018 10:05:30 -0700
Message-ID: <20180605170532.170361-1-ndesaulniers@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: akpm@linux-foundation.org, ard.biesheuvel@linaro.org, aryabinin@virtuozzo.com, akataria@vmware.com, boris.ostrovsky@oracle.com, brijesh.singh@amd.com, caoj.fnst@cn.fujitsu.com, gregkh@linuxfoundation.org, hpa@zytor.com, jan.kiszka@siemens.com, jarkko.sakkinen@linux.intel.com, jgross@suse.com, jpoimboe@redhat.com, kirill.shutemov@linux.intel.com, mingo@redhat.com, mjg59@google.com, mka@chromium.org, ndesaulniers@google.com, pombredanne@nexb.com, rostedt@goodmis.org, tglx@linutronix.de, thomas.lendacky@amd.com, tweek@google.com
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, virtualization@lists.linux-foundation.org, astrachan@google.com, manojgupta@google.com, ghackmann@google.com, sedat.dilek@gmail.com, tstellar@redhat.com, keescook@google.com, yamada.masahiro@socionext.com, michal.lkml@markovi.net, linux-kbuild@vger.kernel.org, geert@linux-m68k.org, will.deacon@arm.com, mawilcox@microsoft.com, arnd@arndb.de, rientjes@google.com
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

Changes since v2:
  Prefer gnu_inline function attribute instead of explicitly setting C
  standard compiler flag in problematic Makefiles. We should instead
  carefully evaluate if those Makefiles should be overwriting
  KBUILD_CFLAGS at all. Dropped the previous first two patches and added
  a new first patch.

Nick Desaulniers (2):
  compiler-gcc.h: add gnu_inline to all inline declarations
  x86: paravirt: make native_save_fl extern inline

 arch/x86/include/asm/irqflags.h |  2 +-
 arch/x86/kernel/Makefile        |  1 +
 arch/x86/kernel/irqflags.S      | 26 ++++++++++++++++++++++++++
 include/linux/compiler-gcc.h    | 19 +++++++++++++------
 4 files changed, 41 insertions(+), 7 deletions(-)
 create mode 100644 arch/x86/kernel/irqflags.S

-- 
2.17.1.1185.g55be947832-goog
