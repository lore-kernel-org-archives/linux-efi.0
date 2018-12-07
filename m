From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [RESEND PATCH] efi: let kmemleak ignore false positives
Date: Fri, 7 Dec 2018 13:45:28 +0100
Message-ID: <CAKv+Gu-m-5ippngFrxm=ueLS=ziGmhvfrd2Uo2Hido+WjKo1Ag@mail.gmail.com>
References: <1543517152-23969-1-git-send-email-cai@gmx.us> <20181206161633.36292-1-cai@gmx.us>
 <20181206175958.GS54495@arrakis.emea.arm.com> <CAKv+Gu97MU5kU878gF=KBLxQ5GjZatAbJ-LVdKv-QMgdPh3kZQ@mail.gmail.com>
 <1544119499.12945.48.camel@gmx.us> <CAKv+Gu9ugNxoST=cc9utWNtoYFdPng0FgNfV-Mw0UWyJiKqOLw@mail.gmail.com>
 <trinity-73766f32-cf87-4bcd-a655-9eaa40b9ee9c-1544185959983@msvc-mesg-gmx023>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <trinity-73766f32-cf87-4bcd-a655-9eaa40b9ee9c-1544185959983@msvc-mesg-gmx023>
Sender: linux-kernel-owner@vger.kernel.org
To: Qian Cai <cai@gmx.us>
Cc: Andrew Morton <akpm@linux-foundation.org>, Marc Zyngier <marc.zyngier@arm.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-efi <linux-efi@vger.kernel.org>, Catalin Marinas <catalin.marinas@arm.com>
List-Id: linux-efi@vger.kernel.org

On Fri, 7 Dec 2018 at 13:32, Qian Cai <cai@gmx.us> wrote:
>
>
> On 12/7/18 at 6:28 AM, Ard Biesheuvel wrote:
>
> > On Thu, 6 Dec 2018 at 19:05, Qian Cai <cai@gmx.us> wrote:
> > >
> > > On Thu, 2018-12-06 at 19:01 +0100, Ard Biesheuvel wrote:
> > > > On Thu, 6 Dec 2018 at 19:00, Catalin Marinas <catalin.marinas@arm.c=
om> wrote:
> > > > >
> > > > > On Thu, Dec 06, 2018 at 11:16:33AM -0500, Qian Cai wrote:
> > > > > > unreferenced object 0xffff8096c1acf580 (size 128):
> > > > > >   comm "swapper/63", pid 0, jiffies 4294937418 (age 1201.230s)
> > > > > >   hex dump (first 32 bytes):
> > > > > >     80 87 b5 c1 96 00 00 00 00 00 cc c2 16 00 00 00  ..........=
......
> > > > > >     00 00 01 00 00 00 00 00 6b 6b 6b 6b 6b 6b 6b 6b  ........kk=
kkkkkk
> > > > > >   backtrace:
> > > > > >     [<000000001d2549ba>] kmem_cache_alloc_trace+0x430/0x500
> > > > > >     [<0000000093a6dfab>] efi_mem_reserve_persistent+0x50/0xf8
> > > > > >     [<000000000a730828>] its_cpu_init_lpis+0x394/0x4b8
> > > > > >     [<00000000edf04e07>] its_cpu_init+0x104/0x150
> > > > > >     [<000000004d0342c5>] gic_starting_cpu+0x34/0x40
> > > > > >     [<000000005d9da772>] cpuhp_invoke_callback+0x228/0x1d68
> > > > > >     [<0000000061eace9b>] notify_cpu_starting+0xc0/0x118
> > > > > >     [<0000000048bc2dc5>] secondary_start_kernel+0x23c/0x3b0
> > > > > >     [<0000000015137d6a>] 0xffffffffffffffff
> > > > > >
> > > > > > efi_mem_reserve_persistent+0x50/0xf8:
> > > > > > kmalloc at include/linux/slab.h:546
> > > > > > (inlined by) efi_mem_reserve_persistent at drivers/firmware/efi=
/efi.c:979
> > > > > >
> > > > > > This line,
> > > > > >
> > > > > > rsv =3D kmalloc(sizeof(*rsv), GFP_ATOMIC);
> > > > > >
> > > > > > Kmemleak has a known limitation that can only track pointers in=
 the kernel
> > > > > > virtual space. Hence, it will report false positives due to "rs=
v" will
> > > > > > only
> > > > > > reference to other physical addresses,
> > > > > >
> > > > > > rsv->next =3D efi_memreserve_root->next;
> > > > > > efi_memreserve_root->next =3D __pa(rsv);
> > > > > >
> > > > > > Signed-off-by: Qian Cai <cai@gmx.us>
> > > > >
> > > > > Acked-by: Catalin Marinas <catalin.marinas@arm.com>\
> > > >
> > > > I don't see the patch and I wasn't cc'ed
> > >
> > > That is strange. Please see,
> > >
> > > https://lore.kernel.org/lkml/1543517152-23969-1-git-send-email-cai@gm=
x.us/
> >
> > OK, I found it in my spam folder, apologies for that.
> >
> > This kmalloc() will be replaced in the next merge window by a call to
> > __get_free_page(). Does kmemleak still require the kmemleak_ignore()
> > for that case? Or is it only for kmalloc()?
>
> Looks like kmemleak won=E2=80=99t be able to track page
> allocation, so it should be fine then without
> kmemleak_ignore().

OK, thanks Qian

I will take the patch for v4.20 and remove the kmemleak_ignore() again for =
v4.21
