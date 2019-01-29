From: "Rafael J. Wysocki" <rafael@kernel.org>
Subject: Re: [PATCH] acpi: bgrt: parse BGRT to obtain BMP address before it
 gets clobbered
Date: Tue, 29 Jan 2019 16:09:11 +0100
Message-ID: <CAJZ5v0jcrP1KnKO3cNfz07UmMtita0xFzS67=_v9BVhJZiBP0A@mail.gmail.com>
References: <20190122150616.850-1-ard.biesheuvel@linaro.org>
 <CAKv+Gu9Ya45KONSiTh1Nj=WEoiwJqqfhOJf6-PxhyHtOoBeiKw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <CAKv+Gu9Ya45KONSiTh1Nj=WEoiwJqqfhOJf6-PxhyHtOoBeiKw@mail.gmail.com>
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
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, Graeme Gregory <graeme.gregory@linaro.org>, Peter Jones <pjones@redhat.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Leif Lindholm <leif.lindholm@linaro.org>, Al Stone <astone@redhat.com>, ACPI Devel Maling List <linux-acpi@vger.kernel.org>, linux-efi <linux-efi@vger.kernel.org>, "Hsiung,
 Harry L" <harry.l.hsiung@intel.com>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, Len Brown <lenb@kernel.org>
List-Id: linux-efi@vger.kernel.org

On Tue, Jan 29, 2019 at 3:36 PM Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
>
> On Tue, 22 Jan 2019 at 16:06, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> >
> > The bitmap left in the framebuffer by the firmware is described by an
> > ACPI table called "BGRT", which describes the size, pixel format and
> > the address of a BMP image in memory. While the BGRT ACPI table is
> > guaranteed to reside in a "ACPI reclaim" memory region, which is
> > never touched by Linux. The BMP image, however, typically resides
> > in EFI Boot Services Memory, which may have been overwritten by the
> > time the BGRT discovery routine runs.
> >
> > So instead, drop the handling from the ACPI init code, and call the
> > BGRT parsing code immediately after going over the EFI configuration
> > table array, at which time no memory has been touched yet except for
> > the .data/.bss regions covered by the static kernel image.
> >
> > Unfortunately, this involves a non-trivial amount of ACPI entry
> > point and root table parsing, but we cannot rely on the normal
> > ACPI infrastructure yet this early in the boot.
> >
> > Also note that we cannot take the 'acpi_disabled' global variable
> > into account, since it may not have assumed the correct value yet
> > (on arm64, the default value is '1' which is overridden to '0' if
> > no DT description has been made available by the firmware)
> >
> > Cc: Peter Jones <pjones@redhat.com>
> > Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > ---
> >  arch/arm64/kernel/acpi.c        |  2 -
> >  arch/x86/kernel/acpi/boot.c     |  2 -
> >  drivers/acpi/bgrt.c             |  6 --
> >  drivers/firmware/efi/efi-bgrt.c | 80 ++++++++++++++++++--
> >  drivers/firmware/efi/efi.c      | 13 ++++
> >  include/linux/efi-bgrt.h        |  4 +-
> >  6 files changed, 89 insertions(+), 18 deletions(-)
> >
>
> Rafael, Len,
>
> Do you mind if i take this via the EFI tree (after addressing
> Lorenzo's comments)

Not at all, please take it.

Thanks!
