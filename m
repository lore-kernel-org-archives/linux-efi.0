From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: Re: [PATCH] acpi: bgrt: parse BGRT to obtain BMP address before it
 gets clobbered
Date: Tue, 22 Jan 2019 18:56:52 +0000
Message-ID: <20190122185652.GC13206@e107981-ln.cambridge.arm.com>
References: <20190122150616.850-1-ard.biesheuvel@linaro.org>
 <20190122173222.GB11720@e107981-ln.cambridge.arm.com>
 <CAKv+Gu9-tDRbmt+T3or9pMs78-pU-9BpKorhB60N_=Bxo78A1g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu9-tDRbmt+T3or9pMs78-pU-9BpKorhB60N_=Bxo78A1g@mail.gmail.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-efi <linux-efi@vger.kernel.org>, Graeme Gregory <graeme.gregory@linaro.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Leif Lindholm <leif.lindholm@linaro.org>, Al Stone <astone@redhat.com>, ACPI Devel Maling List <linux-acpi@vger.kernel.org>, Peter Jones <pjones@redhat.com>, "Hsiung, Harry L" <harry.l.hsiung@intel.com>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, Len Brown <lenb@kernel.org>
List-Id: linux-efi@vger.kernel.org

On Tue, Jan 22, 2019 at 07:07:30PM +0100, Ard Biesheuvel wrote:
> On Tue, 22 Jan 2019 at 18:32, Lorenzo Pieralisi
> <lorenzo.pieralisi@arm.com> wrote:
> >
> > On Tue, Jan 22, 2019 at 04:06:16PM +0100, Ard Biesheuvel wrote:
> > > The bitmap left in the framebuffer by the firmware is described by an
> > > ACPI table called "BGRT", which describes the size, pixel format and
> > > the address of a BMP image in memory. While the BGRT ACPI table is
> > > guaranteed to reside in a "ACPI reclaim" memory region, which is
> > > never touched by Linux. The BMP image, however, typically resides
> > > in EFI Boot Services Memory, which may have been overwritten by the
> > > time the BGRT discovery routine runs.
> > >
> > > So instead, drop the handling from the ACPI init code, and call the
> > > BGRT parsing code immediately after going over the EFI configuration
> > > table array, at which time no memory has been touched yet except for
> > > the .data/.bss regions covered by the static kernel image.
> > >
> > > Unfortunately, this involves a non-trivial amount of ACPI entry
> > > point and root table parsing, but we cannot rely on the normal
> > > ACPI infrastructure yet this early in the boot.
> > >
> > > Also note that we cannot take the 'acpi_disabled' global variable
> > > into account, since it may not have assumed the correct value yet
> > > (on arm64, the default value is '1' which is overridden to '0' if
> > > no DT description has been made available by the firmware)
> > >
> > > Cc: Peter Jones <pjones@redhat.com>
> > > Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> >
> > Technically this is a fix, right ?
> >
> 
> I would argue that it is a hack to work around a deficiency in the
> ACPI spec, i.e., that the BGRT table but not the image are passed in
> ACPI reclaim memory.

I assume there are designs out there that this patch is fixing (I
understand it is hackish but there is not much else you can do,
especially so with firmware already in the field), I was wondering
if we want to update older kernels too.

Cheers,
Lorenzo
