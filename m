From: Nick Desaulniers <ndesaulniers@google.com>
Subject: [PATCH 0/3] extern inline native_save_fl for paravirt
Date: Fri,  1 Jun 2018 09:55:47 -0700
Message-ID: <20180601165550.90053-1-ndesaulniers@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: akpm@linux-foundation.org, ard.biesheuvel@linaro.org, aryabinin@virtuozzo.com, akataria@vmware.com, boris.ostrovsky@oracle.com, brijesh.singh@amd.com, caoj.fnst@cn.fujitsu.com, gregkh@linuxfoundation.org, hpa@zytor.com, jan.kiszka@siemens.com, jarkko.sakkinen@linux.intel.com, jgross@suse.com, jpoimboe@redhat.com, kirill.shutemov@linux.intel.com, mingo@redhat.com, mjg59@google.com, mka@chromium.org, ndesaulniers@google.com, pombredanne@nexb.com, rostedt@goodmis.org, tglx@linutronix.de, thomas.lendacky@amd.com, tweek@google.com
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, virtualization@lists.linux-foundation.org
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

Nick Desaulniers (3):
  efi: use -std=gnu89 for proper extern inline semantics
  x86/build: use -std=gnu89 for proper extern inline semantics
  x86: paravirt: make native_save_fl extern inline

 arch/x86/boot/compressed/Makefile     |  2 +-
 arch/x86/include/asm/irqflags.h       |  2 +-
 arch/x86/kernel/Makefile              |  1 +
 arch/x86/kernel/irqflags.S            | 26 ++++++++++++++++++++++++++
 drivers/firmware/efi/libstub/Makefile |  2 +-
 5 files changed, 30 insertions(+), 3 deletions(-)
 create mode 100644 arch/x86/kernel/irqflags.S

-- 
2.17.0.921.gf22659ad46-goog
