From: <wang.yi59@zte.com.cn>
Subject: =?UTF-8?B?UmU6IFtQQVRDSF0geDg2OiBmaXggLVdtaXNzaW5nLXByb3RvdHlwZXMgd2FybmluZw==?=
Date: Thu, 22 Nov 2018 19:04:59 +0800 (CST)
Message-ID: <201811221904598072830@zte.com.cn>
References: <20181122084815.GA84118@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="=====_001_next====="
Return-path: <jailhouse-dev+bncBAABBYU23LPQKGQEQEW6A2I@googlegroups.com>
Sender: jailhouse-dev@googlegroups.com
In-Reply-To: <20181122084815.GA84118@gmail.com>
References: 1542852249-19820-1-git-send-email-wang.yi59@zte.com.cn,20181122084815.GA84118@gmail.com
List-Post: <https://groups.google.com/group/jailhouse-dev/post>, <mailto:jailhouse-dev@googlegroups.com>
List-Help: <https://groups.google.com/support/>, <mailto:jailhouse-dev+help@googlegroups.com>
List-Archive: <https://groups.google.com/group/jailhouse-dev
List-Subscribe: <https://groups.google.com/group/jailhouse-dev/subscribe>, <mailto:jailhouse-dev+subscribe@googlegroups.com>
List-Unsubscribe: <mailto:googlegroups-manage+175645748590+unsubscribe@googlegroups.com>,
 <https://groups.google.com/group/jailhouse-dev/subscribe>
To: mingo@kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com, x86@kernel.org, linux-kernel@vger.kernel.org, ard.biesheuvel@linaro.org, linux-efi@vger.kernel.org, pbonzini@redhat.com, rkrcmar@redhat.com, kvm@vger.kernel.org, jgross@suse.com, akataria@vmware.com, virtualization@lists.linux-foundation.org, m.mizuma@jp.fujitsu.com, peterz@infradead.org, prarit@redhat.com, douly.fnst@cn.fujitsu.com, dwmw@amazon.co.uk, luto@kernel.org, pasha.tatashin@oracle.com, rajvi.jingar@intel.com, zhe.he@windriver.com, akpm@linux-foundation.org, dyoung@redhat.com, takahiro.akashi@linaro.org, ebiederm@xmission.com, bhe@redhat.com, ivan.gorinov@intel.com, robh@kernel.org, andy.shevchenko@gmail.com, frank.rowand@sony.com, jan.kiszka@
List-Id: linux-efi@vger.kernel.org



--=====_001_next=====
Content-Type: multipart/alternative;
	boundary="=====_003_next====="


--=====_003_next=====
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Ingo,

> * Yi Wang <wang.yi59@zte.com.cn> wrote:
>
> > We may get -Wmissing-prototypes warnings when building
> > kernel with W=3D1, it's better to fix them as global function
> > signature can be changed and caller who use the old unchanged
> > prototypes will be hosed.
> >
> > This patch fixes most of -Wmissing-prototypes warnings which
> > are in the root directory of arch/x86/kernel, not including
> > the subdirectories.
> >
> > These are the warnings fixed in this patch:
> > arch/x86/kernel/signal.c:865:17: warning: no previous prototype for =E2=
=80=98sys32_x32_rt_sigreturn=E2=80=99 [-Wmissing-prototypes]

......

> >  include/linux/ftrace.h             | 3 +++
> >  include/linux/kexec.h              | 1 +
> >  include/linux/of_fdt.h             | 1 +
> >  include/linux/ptrace.h             | 1 +
> >  24 files changed, 55 insertions(+), 3 deletions(-)
>
> Breaks 32-bit compilation:
>
> ../arch/x86/include/asm/setup.h: Assembler messages:
> ../arch/x86/include/asm/setup.h:30: Error: no such instruction: `unsigned=
 long __startup_64(unsigned long physaddr,struct boot_params *bp)'
>
> I'll skip the setup.h bits - let's hope that's the only bug.

Sorry for the inconvenience, though I have checked carefully :-)

How do you produce this error? I tested this way but did not reproduce
that error:
# make allmodconfig
# make -j8

Thanks for your time again!


---
Best wishes
Yi Wang

--=20
You received this message because you are subscribed to the Google Groups "=
Jailhouse" group.
To unsubscribe from this group and stop receiving emails from it, send an e=
mail to jailhouse-dev+unsubscribe@googlegroups.com.
For more options, visit https://groups.google.com/d/optout.

--=====_003_next=====--

--=====_001_next=====--
