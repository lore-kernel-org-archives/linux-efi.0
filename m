From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH v2 1/2] compiler-gcc.h: add gnu_inline to all inline
 declarations
Date: Tue, 05 Jun 2018 10:23:40 -0700
Message-ID: <202492204c2d5bd5ca27307cbca5e44673b739ed.camel@perches.com>
References: <20180605170532.170361-1-ndesaulniers@google.com>
         <20180605170532.170361-2-ndesaulniers@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180605170532.170361-2-ndesaulniers@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nick Desaulniers <ndesaulniers@google.com>, akpm@linux-foundation.org, ard.biesheuvel@linaro.org, aryabinin@virtuozzo.com, akataria@vmware.com, boris.ostrovsky@oracle.com, brijesh.singh@amd.com, caoj.fnst@cn.fujitsu.com, gregkh@linuxfoundation.org, hpa@zytor.com, jan.kiszka@siemens.com, jarkko.sakkinen@linux.intel.com, jgross@suse.com, jpoimboe@redhat.com, kirill.shutemov@linux.intel.com, mingo@redhat.com, mjg59@google.com, mka@chromium.org, pombredanne@nexb.com, rostedt@goodmis.org, tglx@linutronix.de, thomas.lendacky@amd.com, tweek@google.com
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, virtualization@lists.linux-foundation.org, astrachan@google.com, manojgupta@google.com, ghackmann@google.com, sedat.dilek@gmail.com, tstellar@redhat.com, keescook@google.com, yamada.masahiro@socionext.com, michal.lkml@markovi.net, linux-kbuild@vger.kernel.org, geert@linux-m68k.org, will.deacon@arm.com, mawilcox@microsoft.com, arnd@arndb.de, rientjes@google.com
List-Id: linux-efi@vger.kernel.org

On Tue, 2018-06-05 at 10:05 -0700, Nick Desaulniers wrote:
> Functions marked extern inline do not emit an externally visible
> function when the gnu89 C standard is used. Some KBUILD Makefiles
> overwrite KBUILD_CFLAGS. This is an issue for GCC 5.1+ users as without
> an explicit C standard specified, the default is gnu11. Since c99, the
> semantics of extern inline have changed such that an externally visible
> function is always emitted. This can lead to multiple definition errors
> of extern inline functions at link time of compilation units whose build
> files have removed an explicit C standard compiler flag for users of GCC
> 5.1+ or Clang.
[]
> diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
[]
> @@ -72,17 +72,24 @@
>   * -Wunused-function.  This turns out to avoid the need for complex #ifdef
>   * directives.  Suppress the warning in clang as well by using "unused"
>   * function attribute, which is redundant but not harmful for gcc.
> + * Prefer gnu_inline, so that extern inline functions do not emit an
> + * externally visible function. This makes extern inline behave as per gnu89
> + * semantics rather than c99. This prevents multiple symbol definition errors
> + * of extern inline functions at link time.
>   */
>  #if !defined(CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING) ||		\
>      !defined(CONFIG_OPTIMIZE_INLINING) || (__GNUC__ < 4)
> -#define inline inline		__attribute__((always_inline,unused)) notrace
> -#define __inline__ __inline__	__attribute__((always_inline,unused)) notrace
> -#define __inline __inline	__attribute__((always_inline,unused)) notrace
> +#define inline \
> +	inline __attribute__((always_inline, unused, gnu_inline)) notrace
> +#define __inline__ \
> +	__inline__ __attribute__((always_inline, unused, gnu_inline)) notrace
> +#define __inline \
> +	__inline __attribute__((always_inline, unused, gnu_inline)) notrace

Perhaps these are simpler as

#define __inline__	inline
#define __inline	inline

>  #else
>  /* A lot of inline functions can cause havoc with function tracing */
> -#define inline inline		__attribute__((unused)) notrace
> -#define __inline__ __inline__	__attribute__((unused)) notrace
> -#define __inline __inline	__attribute__((unused)) notrace
> +#define inline inline		__attribute__((unused, gnu_inline)) notrace
> +#define __inline__ __inline__	__attribute__((unused, gnu_inline)) notrace
> +#define __inline __inline	__attribute__((unused, gnu_inline)) notrace
>  #endif

And only set once along with:

>  #define __always_inline	inline __attribute__((always_inline))

And perhaps this __always_inline should be updated
with gnu_inline as well
