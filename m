From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] x86: fix -Wmissing-prototypes warning
Date: Thu, 22 Nov 2018 12:14:58 +0100
Message-ID: <20181122111458.GA107823@gmail.com>
References: <20181122084815.GA84118@gmail.com>
 <201811221904598072830@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <jailhouse-dev+bncBD7LZ45K3ECBBOE73LPQKGQEFPLYRQQ@googlegroups.com>
Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Content-Disposition: inline
In-Reply-To: <201811221904598072830@zte.com.cn>
List-Post: <https://groups.google.com/group/jailhouse-dev/post>, <mailto:jailhouse-dev@googlegroups.com>
List-Help: <https://groups.google.com/support/>, <mailto:jailhouse-dev+help@googlegroups.com>
List-Archive: <https://groups.google.com/group/jailhouse-dev
List-Subscribe: <https://groups.google.com/group/jailhouse-dev/subscribe>, <mailto:jailhouse-dev+subscribe@googlegroups.com>
List-Unsubscribe: <mailto:googlegroups-manage+175645748590+unsubscribe@googlegroups.com>,
 <https://groups.google.com/group/jailhouse-dev/subscribe>
To: wang.yi59@zte.com.cn
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com, x86@kernel.org, linux-kernel@vger.kernel.org, ard.biesheuvel@linaro.org, linux-efi@vger.kernel.org, pbonzini@redhat.com, rkrcmar@redhat.com, kvm@vger.kernel.org, jgross@suse.com, akataria@vmware.com, virtualization@lists.linux-foundation.org, m.mizuma@jp.fujitsu.com, peterz@infradead.org, prarit@redhat.com, douly.fnst@cn.fujitsu.com, dwmw@amazon.co.uk, luto@kernel.org, pasha.tatashin@oracle.com, rajvi.jingar@intel.com, zhe.he@windriver.com, akpm@linux-foundation.org, dyoung@redhat.com, takahiro.akashi@linaro.org, ebiederm@xmission.com, bhe@redhat.com, ivan.gorinov@intel.com, robh@kernel.org, andy.shevchenko@gmail.com, frank.rowand@sony.com, jan.kiszka@siemens.com, jailhouse-dev@googlegroups.com, konrad.wilk@oracle.com, thomas.lendacky@amd.com, pravin.shedge4linux@gmail.com, namit@vmware.com, jroedel@sus
List-Id: linux-efi@vger.kernel.org


* wang.yi59@zte.com.cn <wang.yi59@zte.com.cn> wrote:

> Hi Ingo,
>=20
> > * Yi Wang <wang.yi59@zte.com.cn> wrote:
> >
> > > We may get -Wmissing-prototypes warnings when building
> > > kernel with W=3D1, it's better to fix them as global function
> > > signature can be changed and caller who use the old unchanged
> > > prototypes will be hosed.
> > >
> > > This patch fixes most of -Wmissing-prototypes warnings which
> > > are in the root directory of arch/x86/kernel, not including
> > > the subdirectories.
> > >
> > > These are the warnings fixed in this patch:
> > > arch/x86/kernel/signal.c:865:17: warning: no previous prototype for =
=E2=80=98sys32_x32_rt_sigreturn=E2=80=99 [-Wmissing-prototypes]
>=20
> ......
>=20
> > >  include/linux/ftrace.h             | 3 +++
> > >  include/linux/kexec.h              | 1 +
> > >  include/linux/of_fdt.h             | 1 +
> > >  include/linux/ptrace.h             | 1 +
> > >  24 files changed, 55 insertions(+), 3 deletions(-)
> >
> > Breaks 32-bit compilation:
> >
> > ../arch/x86/include/asm/setup.h: Assembler messages:
> > ../arch/x86/include/asm/setup.h:30: Error: no such instruction: `unsign=
ed long __startup_64(unsigned long physaddr,struct boot_params *bp)'
> >
> > I'll skip the setup.h bits - let's hope that's the only bug.
>=20
> Sorry for the inconvenience, though I have checked carefully :-)
>=20
> How do you produce this error? I tested this way but did not reproduce
> that error:
> # make allmodconfig
> # make -j8
>=20
> Thanks for your time again!

I don't remember the exact config, but you could try the 32-bit=20
allnoconfig and defconfig.

Note that the commands you used above will use the 64-bit kernel, not the=
=20
32-bit kernel.

Thanks,

	Ingo

--=20
You received this message because you are subscribed to the Google Groups "=
Jailhouse" group.
To unsubscribe from this group and stop receiving emails from it, send an e=
mail to jailhouse-dev+unsubscribe@googlegroups.com.
For more options, visit https://groups.google.com/d/optout.
