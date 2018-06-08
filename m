From: Sedat Dilek <sedat.dilek@gmail.com>
Subject: Re: [PATCH v2 1/2] compiler-gcc.h: add gnu_inline to all inline declarations
Date: Fri, 8 Jun 2018 16:34:50 +0200
Message-ID: <CA+icZUUz1Zb1e0LbeccY-3=HY02txe4BiNwhN0vqW_RkQpfLCw@mail.gmail.com>
References: <20180605170532.170361-1-ndesaulniers@google.com>
 <20180605170532.170361-2-ndesaulniers@google.com> <202492204c2d5bd5ca27307cbca5e44673b739ed.camel@perches.com>
 <5ad1876557235a089a50e6ed6c558a7dcb0da714.camel@perches.com>
 <CA+icZUXEpe954z0TSbhSJPdFCfOqsBtpO9mPZBcJ2HWubSo_zQ@mail.gmail.com> <5C97550D-BEF4-4069-9373-F7543E3878FB@zytor.com>
Reply-To: sedat.dilek@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5C97550D-BEF4-4069-9373-F7543E3878FB@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
To: hpa@zytor.com
Cc: Joe Perches <joe@perches.com>, Nick Desaulniers <ndesaulniers@google.com>, akpm@linux-foundation.org, ard.biesheuvel@linaro.org, aryabinin@virtuozzo.com, akataria@vmware.com, boris.ostrovsky@oracle.com, brijesh.singh@amd.com, caoj.fnst@cn.fujitsu.com, gregkh@linuxfoundation.org, jan.kiszka@siemens.com, jarkko.sakkinen@linux.intel.com, jgross@suse.com, jpoimboe@redhat.com, kirill.shutemov@linux.intel.com, mingo@redhat.com, mjg59@google.com, mka@chromium.org, pombredanne@nexb.com, rostedt@goodmis.org, tglx@linutronix.de, thomas.lendacky@amd.com, tweek@google.com, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, virtualization@lists.linux-foundation.org, astrachan@google.com, manojgupta@google.com, ghackmann@google.com, tstellar@redhat.com, kees
List-Id: linux-efi@vger.kernel.org

On Wed, Jun 6, 2018 at 6:39 PM,  <hpa@zytor.com> wrote:
...
>>Beyond this, a general question: Can someone explain why all these
>>inline defines are in compiler-gcc.h (as there exists compiler.h and
>>compiler-clang.h)?
>>
>>Thanks.
>>
>>Regards,
>>- Sedat -
>
> Because gcc itself also supports both GNU89-style and C99-style inlines, but the kernel was built with the former, and it is not necessarily a trivial modification, except for "static inline" which is the same for both.
>
> The other option is to pass -fgnu89-inline on the command line, which is supported by both gcc and clang. The two methods are fully equivalent.
>

We have...

$ ls include/linux/compiler*
include/linux/compiler-clang.h  include/linux/compiler-gcc.h
include/linux/compiler.h  include/linux/compiler-intel.h
include/linux/compiler_types.h

include/linux/compiler_types.h says...

#ifdef __GNUC__
#include <linux/compiler-gcc.h>
#endif
...
/* Intel compiler defines __GNUC__. So we will overwrite implementations
 * coming from above header files here
 */
#ifdef __INTEL_COMPILER
# include <linux/compiler-intel.h>
#endif

/* Clang compiler defines __GNUC__. So we will overwrite implementations
 * coming from above header files here
 */
#ifdef __clang__
#include <linux/compiler-clang.h>
#endif

/*
 * Generic compiler-dependent macros required for kernel
 * build go below this comment. Actual compiler/compiler version
 * specific implementations come from the above header files
 */
...

include/linux/compiler-clang.h says...

#ifndef __LINUX_COMPILER_TYPES_H
#error "Please don't include <linux/compiler-clang.h> directly,
include <linux/compiler.h> instead."
#endif

So, compiler-clang.h uses defines etc. from compiler-gcc.h but might
overwrite it.
Correct?
I would have expected inline defines in compiler.h as I thought there
is the place for generic stuff.

Maybe you can clarify on the roles of especially compiler.h and
compiler_types.h.

Thanks.

- sed@ -
