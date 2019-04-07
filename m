From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] efi/arm: enable CP15 DMB instructions before cleaning the
 cache
Date: Sun, 7 Apr 2019 20:19:40 +0200
Message-ID: <CAKv+Gu-6n5YGq3AxpCvv-Zo-Fh01vyLoqMbqTPZn+k7MOFVnRw@mail.gmail.com>
References: <20190329182418.29592-1-ard.biesheuvel@linaro.org>
 <86y34w668n.wl-marc.zyngier@arm.com>
 <CAKv+Gu_3_nENwrp81r7=wWbbZ6hpdjewppbuy6domXoZe09ujg@mail.gmail.com>
 <86tvfj5t2g.wl-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <86tvfj5t2g.wl-marc.zyngier@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Leif Lindholm <leif.lindholm@linaro.org>, linux-efi <linux-efi@vger.kernel.org>, Steve McIntyre <steve.mcintyre@linaro.org>, Russell King <linux@armlinux.org.uk>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
List-Id: linux-efi@vger.kernel.org

On Sun, 31 Mar 2019 at 10:47, Marc Zyngier <marc.zyngier@arm.com> wrote:
>
> On Sat, 30 Mar 2019 13:10:58 +0000,
> Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> >
> > On Sat, 30 Mar 2019 at 10:50, Marc Zyngier <marc.zyngier@arm.com> wrote:
> > >
> > > Hi Ard,
> > >
> > > On Fri, 29 Mar 2019 18:24:18 +0000,
> > > Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> > > >
> > > > The EFI stub is entered with the caches and MMU enabled by the
> > > > firmware, and once the stub is ready to hand over to the decompressor,
> > > > we clean and disable the caches.
> > > >
> > > > The cache clean routines use CP15 barrier instructions, which can be
> > > > disabled via SCTLR. Normally, when using the provided cache handling
> > > > routines to enable the caches and MMU, this bit is enabled as well.
> > > > However, but since we entered the stub with the caches already enabled,
> > > > this routine is not executed before we call the cache clean routines,
> > > > resulting in undefined instruction exceptions if the firmware never
> > > > enabled this bit.
> > > >
> > > > So set the bit explicitly in the EFI entry code.
> > > >
> > > > Cc: Marc Zyngier <marc.zyngier@arm.com>
> > > > Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > > > ---
> > > >  arch/arm/boot/compressed/head.S | 10 ++++++++++
> > > >  1 file changed, 10 insertions(+)
> > > >
> > > > diff --git a/arch/arm/boot/compressed/head.S b/arch/arm/boot/compressed/head.S
> > > > index 6c7ccb428c07..62a49356fca3 100644
> > > > --- a/arch/arm/boot/compressed/head.S
> > > > +++ b/arch/arm/boot/compressed/head.S
> > > > @@ -1438,6 +1438,16 @@ ENTRY(efi_stub_entry)
> > > >
> > > >               @ Preserve return value of efi_entry() in r4
> > > >               mov     r4, r0
> > > > +
> > > > +             @ our cache maintenance code relies on CP15 barrier instructions
> > > > +             @ but since we arrived here with the MMU and caches configured
> > > > +             @ by UEFI, we must ensure that the use of those instructions is
> > > > +             @ enabled in the SCTLR register, since we never executed our own
> > > > +             @ cache enable routine, which is normally in charge of this.
> > > > +             mrc     p15, 0, r1, c1, c0, 0   @ read SCTLR
> > > > +             orr     r1, r1, #(1 << 5)       @ CP15 barrier instructions
> > > > +             mcr     p15, 0, r1, c1, c0, 0   @ write SCTLR
> > > > +
> > >
> > > To be on the safe side, you could add an isb here. I'm pretty sure it
> > > is immaterial on any ARMv7 core, but hey, I'm paranoid.
> > >
> >
> > Well, this is actually triggering now under KVM, so I wonder if this
> > is a regression of some kind on the host side. But the EFI stub
> > shouldn't use CP15 barriers without enabling them, so we need this
> > patch in any case.
>
> My remark was only about the lack of an ISB instruction after the
> write to SCTLR, and you're perfectly right to enable CP15BEN.
>

Actually, the CP15 ISB is not usable here, and using the v7 ISB breaks
v6. Would reading back SCTLR suffice?

> But there is something fishy. Looking at the KVM/arm64 code,
> SCTLR_EL1.CP15BEN resets to 1. If the barrier undefs in the stubs,
> something must have cleared it (or the reset code is busted...).
>
> I've dumped SCTLR from a guest running EFI (using GDB), and I do see
> SCTLR.CP15EN being set...
>

Yeah. I won't be able to dig into this for a while, but in the mean
time, I'd like to get a guest fix in in any case.
