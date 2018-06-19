From: Juergen Gross <jgross@suse.com>
Subject: Re: [PATCH v5 0/3] extern inline native_save_fl for paravirt
Date: Tue, 19 Jun 2018 17:03:26 +0200
Message-ID: <6a36db0d-e790-48d6-183a-263c355531b6@suse.com>
References: <20180613210518.113983-1-ndesaulniers@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <20180613210518.113983-1-ndesaulniers@google.com>
Content-Language: de-DE
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: Nick Desaulniers <ndesaulniers@google.com>, akpm@linux-foundation.org, hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de
Cc: kstewart@linuxfoundation.org, andrea.parri@amarulasolutions.com, linux-efi@vger.kernel.org, brijesh.singh@amd.com, jan.kiszka@siemens.com, will.deacon@arm.com, jarkko.sakkinen@linux.intel.com, linux-kernel@vger.kernel.org, yamada.masahiro@socionext.com, manojgupta@google.com, akataria@vmware.com, tweek@google.com, mawilcox@microsoft.com, x86@kernel.org, ghackmann@google.com, mka@chromium.org, geert@linux-m68k.org, rientjes@google.com, aryabinin@virtuozzo.com, thomas.lendacky@amd.com, arnd@arndb.de, linux-kbuild@vger.kernel.org, keescook@google.com, rostedt@goodmis.org, acme@redhat.com, caoj.fnst@cn.fujitsu.com, jpoimboe@redhat.com, sedat.dilek@gmail.com, boris.ostrovsky@oracle.com, virtualization@lists.linux-foundation.org, michal.lkml@markovi.net, tstellar@redhat.com, gregkh@linuxfoundation.org, ard.biesheuvel@linaro.org, astrachan@google.com, mjg59@google.com, pombre
List-Id: linux-efi@vger.kernel.org

On 13/06/18 23:05, Nick Desaulniers wrote:
> paravirt depends on a custom calling convention (callee saved), but
> expects this from a static inline function that it then forces to be
> outlined. This is problematic because different compilers or flags can
> then add a stack guard that violates the calling conventions.
> 
> Uses extern inline with the out-of-line definition in assembly to
> prevent compilers from adding stack guards to the outlined version.
> 
> Other parts of the codebase overwrite KBUILD_CFLAGS, which is *extremely
> problematic* for extern inline, as the sematics are completely the
> opposite depending on what C standard is used.
> http://blahg.josefsipek.net/?p=529
> 
> Changes since v4:
>   Take Arnd's and hpa's suggestions properly feature detect gnu_inline
>   attribute to support gcc 4.1.
> 
> Changes since v3:
>   Take Joe's suggestion to hoist __inline__ and __inline out of
>   conditional block.
> 
> Changes since v2:
>   Take hpa's _ASM_ARG patch into the set in order to simplify cross
>   32b/64b x86 assembly and rebase my final patch to use it.  Apply
>   Sedat's typo fix to commit message and sign off on it. Take Joe's
>   suggestion to simplify __inline__ and __inline. Add Arnd to list of
>   folks who made helpful suggestions.
> 
> Changes since v1:
>   Prefer gnu_inline function attribute instead of explicitly setting C
>   standard compiler flag in problematic Makefiles. We should instead
>   carefully evaluate if those Makefiles should be overwriting
>   KBUILD_CFLAGS at all. Dropped the previous first two patches and added
>   a new first patch.
> 
> H. Peter Anvin (1):
>   x86/asm: add _ASM_ARG* constants for argument registers to <asm/asm.h>
> 
> Nick Desaulniers (2):
>   compiler-gcc.h: add gnu_inline to all inline declarations
>   x86: paravirt: make native_save_fl extern inline
> 
>  arch/x86/include/asm/asm.h      | 59 +++++++++++++++++++++++++++++++++
>  arch/x86/include/asm/irqflags.h |  2 +-
>  arch/x86/kernel/Makefile        |  1 +
>  arch/x86/kernel/irqflags.S      | 26 +++++++++++++++
>  include/linux/compiler-gcc.h    | 29 ++++++++++++----
>  5 files changed, 109 insertions(+), 8 deletions(-)
>  create mode 100644 arch/x86/kernel/irqflags.S
> 

For the series:

Acked-by: Juergen Gross <jgross@suse.com>


Juergen
