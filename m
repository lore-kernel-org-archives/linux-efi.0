From: hpa@zytor.com
Subject: Re: [PATCH v2 1/2] compiler-gcc.h: add gnu_inline to all inline
	declarations
Date: Wed, 06 Jun 2018 09:39:25 -0700
Message-ID: <5C97550D-BEF4-4069-9373-F7543E3878FB@zytor.com>
References: <20180605170532.170361-1-ndesaulniers@google.com>
	<20180605170532.170361-2-ndesaulniers@google.com>
	<202492204c2d5bd5ca27307cbca5e44673b739ed.camel@perches.com>
	<5ad1876557235a089a50e6ed6c558a7dcb0da714.camel@perches.com>
	<CA+icZUXEpe954z0TSbhSJPdFCfOqsBtpO9mPZBcJ2HWubSo_zQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <CA+icZUXEpe954z0TSbhSJPdFCfOqsBtpO9mPZBcJ2HWubSo_zQ@mail.gmail.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: sedat.dilek@gmail.comSedat Dilek <sedat.dilek@gmail.com>, Joe Perches <joe@perches.com>
Cc: linux-efi@vger.kernel.org, brijesh.singh@amd.com, boris.ostrovsky@oracle.com, jan.kiszka@siemens.com, will.deacon@arm.com, jarkko.sakkinen@linux.intel.com, virtualization@lists.linux-foundation.org, yamada.masahiro@socionext.com, manojgupta@google.com, akataria@vmware.com, tweek@google.com, mawilcox@microsoft.com, x86@kernel.org, ghackmann@google.com, mka@chromium.org, geert@linux-m68k.org, rientjes@google.com, aryabinin@virtuozzo.com, thomas.lendacky@amd.com, Arnd Bergmann <arnd@arndb.de>, linux-kbuild@vger.kernel.org, keescook@google.com, rostedt@goodmis.org, caoj.fnst@cn.fujitsu.com, michal.lkml@markovi.net, jpoimboe@redhat.com, tglx@linutronix.de, mingo@redhat.com, jgross@suse.com, astrachan@google.com, ard.biesheuvel@linaro.org, gregkh@linuxfoundation.org, tstellar@redhat.com, Nick Desaulniers <ndesaulniers@google.com>, linux-kernel@vger.kernel.org, mjg59@google.
List-Id: linux-efi@vger.kernel.org

On June 6, 2018 1:05:45 AM PDT, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>Hi,
>
>when discovering 'gnu_inline', I found ...
>
>$ git grep -w  __FORTIFY_INLINE
>include/linux/string.h:#define __FORTIFY_INLINE extern __always_inline
>__attribute__((gnu_inline))
>include/linux/string.h:__FORTIFY_INLINE char *strncpy(char *p, const
>char *q, __kernel_size_t size)
>include/linux/string.h:__FORTIFY_INLINE char *strcat(char *p, const
>char *q)
>include/linux/string.h:__FORTIFY_INLINE __kernel_size_t strlen(const
>char *p)
>include/linux/string.h:__FORTIFY_INLINE __kernel_size_t strnlen(const
>char *p, __kernel_size_t maxlen)
>include/linux/string.h:__FORTIFY_INLINE size_t strlcpy(char *p, const
>char *q, size_t size)
>include/linux/string.h:__FORTIFY_INLINE char *strncat(char *p, const
>char *q, __kernel_size_t count)
>include/linux/string.h:__FORTIFY_INLINE void *memset(void *p, int c,
>__kernel_size_t size)
>include/linux/string.h:__FORTIFY_INLINE void *memcpy(void *p, const
>void *q, __kernel_size_t size)
>include/linux/string.h:__FORTIFY_INLINE void *memmove(void *p, const
>void *q, __kernel_size_t size)
>include/linux/string.h:__FORTIFY_INLINE void *memscan(void *p, int c,
>__kernel_size_t size)
>include/linux/string.h:__FORTIFY_INLINE int memcmp(const void *p,
>const void *q, __kernel_size_t size)
>include/linux/string.h:__FORTIFY_INLINE void *memchr(const void *p,
>int c, __kernel_size_t size)
>include/linux/string.h:__FORTIFY_INLINE void *memchr_inv(const void
>*p, int c, size_t size)
>include/linux/string.h:__FORTIFY_INLINE void *kmemdup(const void *p,
>size_t size, gfp_t gfp)
>include/linux/string.h:__FORTIFY_INLINE char *strcpy(char *p, const
>char *q)
>
>After the inline changes suggested by Joe this can be adapted?
>
>Beyond this, a general question: Can someone explain why all these
>inline defines are in compiler-gcc.h (as there exists compiler.h and
>compiler-clang.h)?
>
>Thanks.
>
>Regards,
>- Sedat -

Because gcc itself also supports both GNU89-style and C99-style inlines, but the kernel was built with the former, and it is not necessarily a trivial modification, except for "static inline" which is the same for both.

The other option is to pass -fgnu89-inline on the command line, which is supported by both gcc and clang. The two methods are fully equivalent.
-- 
Sent from my Android device with K-9 Mail. Please excuse my brevity.
