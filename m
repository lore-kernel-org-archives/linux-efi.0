From: hpa@zytor.com
Subject: Re: [PATCH 2/3] x86/build: use -std=gnu89 for proper extern inline semantics
Date: Fri, 01 Jun 2018 10:36:23 -0700
Message-ID: <A8FE8E99-A531-4E2D-B712-38354140D43D@zytor.com>
References: <20180601165550.90053-1-ndesaulniers@google.com> <20180601165550.90053-3-ndesaulniers@google.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180601165550.90053-3-ndesaulniers@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nick Desaulniers <ndesaulniers@google.com>, akpm@linux-foundation.org, ard.biesheuvel@linaro.org, aryabinin@virtuozzo.com, akataria@vmware.com, boris.ostrovsky@oracle.com, brijesh.singh@amd.com, caoj.fnst@cn.fujitsu.com, gregkh@linuxfoundation.org, jan.kiszka@siemens.com, jarkko.sakkinen@linux.intel.com, jgross@suse.com, jpoimboe@redhat.com, kirill.shutemov@linux.intel.com, mingo@redhat.com, mjg59@google.com, mka@chromium.orgndesaulniers@google.com, pombredanne@nexb.com, rostedt@goodmis.org, tglx@linutronix.de, thomas.lendacky@amd.com, tweek@google.com
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, virtualization@lists.linux-foundation.org
List-Id: linux-efi@vger.kernel.org

On June 1, 2018 9:55:49 AM PDT, Nick Desaulniers <ndesaulniers@google.com> wrote:
>The top level Makefile explicitly sets the C standard used in the
>kernel
>to gnu89. By overriding KBUILD_CFLAGS, the C standard used for this
>subdir is now implicit based on compiler and compiler version. GCC
>changes this implicit default from gnu89 to gnu11 in v5.1.
>
>This implies that depending on compiler version, parts of the kernel
>are
>being linked together from object files that were compiled with
>different C standard compiler flags.
>
>This is problematic for symbols declared as extern inline, as the
>semantics have switched since gnu89. See also:
>http://blahg.josefsipek.net/?p=529
>
>Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
>Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
>---
> arch/x86/boot/compressed/Makefile | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/arch/x86/boot/compressed/Makefile
>b/arch/x86/boot/compressed/Makefile
>index fa42f895fdde..1a04c7e9add1 100644
>--- a/arch/x86/boot/compressed/Makefile
>+++ b/arch/x86/boot/compressed/Makefile
>@@ -26,7 +26,7 @@ KCOV_INSTRUMENT		:= n
>targets := vmlinux vmlinux.bin vmlinux.bin.gz vmlinux.bin.bz2
>vmlinux.bin.lzma \
> 	vmlinux.bin.xz vmlinux.bin.lzo vmlinux.bin.lz4
> 
>-KBUILD_CFLAGS := -m$(BITS) -O2
>+KBUILD_CFLAGS := -m$(BITS) -O2 -std=gnu89
> KBUILD_CFLAGS += -fno-strict-aliasing $(call cc-option, -fPIE, -fPIC)
> KBUILD_CFLAGS += -DDISABLE_BRANCH_PROFILING
> cflags-$(CONFIG_X86_32) := -march=i386

-fgnu-inlines would be a better option.

We could also simply #define inline inline __attribute__((gnu_inline))
-- 
Sent from my Android device with K-9 Mail. Please excuse my brevity.
