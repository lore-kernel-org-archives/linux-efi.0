From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v6 3/3] x86: paravirt: make native_save_fl extern inline
Date: Fri, 22 Jun 2018 04:24:02 +0200
Message-ID: <20180622022402.GA24194@gmail.com>
References: <20180621162324.36656-1-ndesaulniers@google.com>
	<20180621162324.36656-4-ndesaulniers@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <20180621162324.36656-4-ndesaulniers@google.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: Nick Desaulniers <ndesaulniers@google.com>
Cc: kstewart@linuxfoundation.org, andrea.parri@amarulasolutions.com, linux-efi@vger.kernel.org, brijesh.singh@amd.com, jan.kiszka@siemens.com, jpoimboe@redhat.com, will.deacon@arm.com, jarkko.sakkinen@linux.intel.com, virtualization@lists.linux-foundation.org, yamada.masahiro@socionext.com, manojgupta@google.com, hpa@zytor.com, boris.ostrovsky@oracle.com, tweek@google.com, mawilcox@microsoft.com, x86@kernel.org, akataria@vmware.com, ghackmann@google.com, mingo@redhat.com, astrachan@google.com, rientjes@google.com, geert@linux-m68k.org, thomas.lendacky@amd.com, arnd@arndb.de, linux-kbuild@vger.kernel.org, pombredanne@nexb.com, rostedt@goodmis.org, acme@redhat.com, caoj.fnst@cn.fujitsu.com, aryabinin@virtuozzo.com, sedat.dilek@gmail.com, tglx@linutronix.de, jgross@suse.com, michal.lkml@markovi.net, tstellar@redhat.com, gregkh@linuxfoundation.org, mka@chromium.org, ard.bieshe
List-Id: linux-efi@vger.kernel.org


* Nick Desaulniers <ndesaulniers@google.com> wrote:

> native_save_fl() is marked static inline, but by using it as
> a function pointer in arch/x86/kernel/paravirt.c, it MUST be outlined.

> --- a/arch/x86/include/asm/irqflags.h
> +++ b/arch/x86/include/asm/irqflags.h
> @@ -13,7 +13,7 @@
>   * Interrupt control:
>   */
>  
> -static inline unsigned long native_save_fl(void)
> +extern inline unsigned long native_save_fl(void)
>  {
>  	unsigned long flags;
>  

What's the code generation effect of this on say a defconfig kernel vmlinux with 
paravirt enabled?

Thanks,

	Ingo
