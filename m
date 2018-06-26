From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v6 3/3] x86: paravirt: make native_save_fl extern inline
Date: Tue, 26 Jun 2018 09:13:25 +0200
Message-ID: <20180626071325.GA25751@gmail.com>
References: <20180621162324.36656-1-ndesaulniers@google.com>
	<20180621162324.36656-4-ndesaulniers@google.com>
	<20180622022402.GA24194@gmail.com>
	<CAKwvOdn5gnB5cK=cy6weKyxAn4SNEdZTT_MtT_D_nHRG5EDZ4g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <CAKwvOdn5gnB5cK=cy6weKyxAn4SNEdZTT_MtT_D_nHRG5EDZ4g@mail.gmail.com>
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
Cc: Kate Stewart <kstewart@linuxfoundation.org>, andrea.parri@amarulasolutions.com, linux-efi@vger.kernel.org, brijesh.singh@amd.com, "J. Kiszka" <jan.kiszka@siemens.com>, Josh Poimboeuf <jpoimboe@redhat.com>, Will Deacon <will.deacon@arm.com>, jarkko.sakkinen@linux.intel.com, virtualization@lists.linux-foundation.org, Masahiro Yamada <yamada.masahiro@socionext.com>, Manoj Gupta <manojgupta@google.com>, hpa@zytor.com, boris.ostrovsky@oracle.com, Thiebaud Weksteen <tweek@google.com>, mawilcox@microsoft.com, x86@kernel.org, akataria@vmware.com, Greg Hackmann <ghackmann@google.com>, mingo@redhat.com, Alistair Strachan <astrachan@google.com>, David Rientjes <rientjes@google.com>, geert@linux-m68k.org, thomas.lendacky@amd.com, Arnd Bergmann <arnd@arndb.de>, Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, Philippe Ombredanne <pombredanne@nexb.com>, rostedt@goodmis.org
List-Id: linux-efi@vger.kernel.org


* Nick Desaulniers <ndesaulniers@google.com> wrote:

> On Thu, Jun 21, 2018 at 7:24 PM Ingo Molnar <mingo@kernel.org> wrote:
> > * Nick Desaulniers <ndesaulniers@google.com> wrote:
> >
> > > native_save_fl() is marked static inline, but by using it as
> > > a function pointer in arch/x86/kernel/paravirt.c, it MUST be outlined.
> >
> > > --- a/arch/x86/include/asm/irqflags.h
> > > +++ b/arch/x86/include/asm/irqflags.h
> > > @@ -13,7 +13,7 @@
> > >   * Interrupt control:
> > >   */
> > >
> > > -static inline unsigned long native_save_fl(void)
> > > +extern inline unsigned long native_save_fl(void)
> > >  {
> > >       unsigned long flags;
> > >
> >
> > What's the code generation effect of this on say a defconfig kernel vmlinux with
> > paravirt enabled?
> 
> Starting with this patch set applied:
> $ make CC=gcc-8 -j46
> $ objdump -d vmlinux | grep native_save_fl --context=3
> ffffffff81059140 <native_save_fl>:
> ffffffff81059140: 9c                    pushfq
> ffffffff81059141: 58                    pop    %rax
> ffffffff81059142: c3                    retq
> $ git checkout HEAD~3
> $ make CC=gcc-8 -j46
> $ objdump -d vmlinux | grep native_save_fl --context=3
> ffffffff81079410 <native_save_fl>:
> ffffffff81079410: 9c                    pushfq
> ffffffff81079411: 58                    pop    %rax
> ffffffff81079412: c3                    retq
> 
> Mainly, this is to prevent the compiler from adding a stack protector
> to the outlined version, as the stack protector clobbers %rcx, but
> paravirt expects %rcx to be preserved. More info can be found:
> https://lkml.org/lkml/2018/5/24/1242--

Ok!

Acked-by: Ingo Molnar <mingo@kernel.org>

What's the planned upstreaming route for these patches/fixes?

Thanks,

	Ingo
