From: Sedat Dilek <sedat.dilek@gmail.com>
Subject: Re: [PATCH v2 1/2] compiler-gcc.h: add gnu_inline to all inline declarations
Date: Wed, 6 Jun 2018 10:05:45 +0200
Message-ID: <CA+icZUXEpe954z0TSbhSJPdFCfOqsBtpO9mPZBcJ2HWubSo_zQ@mail.gmail.com>
References: <20180605170532.170361-1-ndesaulniers@google.com>
 <20180605170532.170361-2-ndesaulniers@google.com> <202492204c2d5bd5ca27307cbca5e44673b739ed.camel@perches.com>
 <5ad1876557235a089a50e6ed6c558a7dcb0da714.camel@perches.com>
Reply-To: sedat.dilek@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5ad1876557235a089a50e6ed6c558a7dcb0da714.camel@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Joe Perches <joe@perches.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>, akpm@linux-foundation.org, ard.biesheuvel@linaro.org, aryabinin@virtuozzo.com, akataria@vmware.com, boris.ostrovsky@oracle.com, brijesh.singh@amd.com, caoj.fnst@cn.fujitsu.com, gregkh@linuxfoundation.org, hpa@zytor.com, jan.kiszka@siemens.com, jarkko.sakkinen@linux.intel.com, jgross@suse.com, jpoimboe@redhat.com, kirill.shutemov@linux.intel.com, mingo@redhat.com, mjg59@google.com, mka@chromium.org, pombredanne@nexb.com, rostedt@goodmis.org, tglx@linutronix.de, thomas.lendacky@amd.com, tweek@google.com, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, virtualization@lists.linux-foundation.org, astrachan@google.com, manojgupta@google.com, ghackmann@google.com, tstellar@redhat.com, keescook@google.com
List-Id: linux-efi@vger.kernel.org

Hi,

when discovering 'gnu_inline', I found ...

$ git grep -w  __FORTIFY_INLINE
include/linux/string.h:#define __FORTIFY_INLINE extern __always_inline
__attribute__((gnu_inline))
include/linux/string.h:__FORTIFY_INLINE char *strncpy(char *p, const
char *q, __kernel_size_t size)
include/linux/string.h:__FORTIFY_INLINE char *strcat(char *p, const char *q)
include/linux/string.h:__FORTIFY_INLINE __kernel_size_t strlen(const char *p)
include/linux/string.h:__FORTIFY_INLINE __kernel_size_t strnlen(const
char *p, __kernel_size_t maxlen)
include/linux/string.h:__FORTIFY_INLINE size_t strlcpy(char *p, const
char *q, size_t size)
include/linux/string.h:__FORTIFY_INLINE char *strncat(char *p, const
char *q, __kernel_size_t count)
include/linux/string.h:__FORTIFY_INLINE void *memset(void *p, int c,
__kernel_size_t size)
include/linux/string.h:__FORTIFY_INLINE void *memcpy(void *p, const
void *q, __kernel_size_t size)
include/linux/string.h:__FORTIFY_INLINE void *memmove(void *p, const
void *q, __kernel_size_t size)
include/linux/string.h:__FORTIFY_INLINE void *memscan(void *p, int c,
__kernel_size_t size)
include/linux/string.h:__FORTIFY_INLINE int memcmp(const void *p,
const void *q, __kernel_size_t size)
include/linux/string.h:__FORTIFY_INLINE void *memchr(const void *p,
int c, __kernel_size_t size)
include/linux/string.h:__FORTIFY_INLINE void *memchr_inv(const void
*p, int c, size_t size)
include/linux/string.h:__FORTIFY_INLINE void *kmemdup(const void *p,
size_t size, gfp_t gfp)
include/linux/string.h:__FORTIFY_INLINE char *strcpy(char *p, const char *q)

After the inline changes suggested by Joe this can be adapted?

Beyond this, a general question: Can someone explain why all these
inline defines are in compiler-gcc.h (as there exists compiler.h and
compiler-clang.h)?

Thanks.

Regards,
- Sedat -
