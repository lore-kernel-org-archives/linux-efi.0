From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] acpi: bgrt: parse BGRT to obtain BMP address before it
 gets clobbered
Date: Sat, 9 Feb 2019 14:41:24 +0100
Message-ID: <CAKv+Gu921D2v0RyuR=rXKKyL6M48MhPJq0b1uM97+4CJPw_Rww@mail.gmail.com>
References: <20190122150616.850-1-ard.biesheuvel@linaro.org>
 <20190123053141.GA7376@dhcp-128-65.nay.redhat.com>
 <CAKv+Gu9yVSfxfy37Z3xt-Ft70VtNs4YYQfcAvMB2qEdSLHhruw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <CAKv+Gu9yVSfxfy37Z3xt-Ft70VtNs4YYQfcAvMB2qEdSLHhruw@mail.gmail.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Dave Young <dyoung@redhat.com>, "Kinney,
 Michael D" <michael.d.kinney@intel.com>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, Graeme Gregory <graeme.gregory@linaro.org>, Peter Jones <pjones@redhat.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Leif Lindholm <leif.lindholm@linaro.org>, Al Stone <astone@redhat.com>, ACPI Devel Maling List <linux-acpi@vger.kernel.org>, linux-efi <linux-efi@vger.kernel.org>, "Hsiung,
 Harry L" <harry.l.hsiung@intel.com>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, Len Brown <lenb@kernel.org>
List-Id: linux-efi@vger.kernel.org

(+ Mike)

On Wed, 23 Jan 2019 at 10:44, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>
> On Wed, 23 Jan 2019 at 06:31, Dave Young <dyoung@redhat.com> wrote:
> >
> > Hi,
> >
> > On 01/22/19 at 04:06pm, Ard Biesheuvel wrote:
> > > The bitmap left in the framebuffer by the firmware is described by an
> > > ACPI table called "BGRT", which describes the size, pixel format and
> > > the address of a BMP image in memory. While the BGRT ACPI table is
> > > guaranteed to reside in a "ACPI reclaim" memory region, which is
> > > never touched by Linux. The BMP image, however, typically resides
> > > in EFI Boot Services Memory, which may have been overwritten by the
> > > time the BGRT discovery routine runs.
> >
> > I vaguely remember boot service memory is reserved on X86,  so this
> > is an issue of arm only?
> >
>
> No both ARM and x86 are affected. Harry and/or Peter should be able to
> comment on the details.
>

OK, so ARM is definitely affected, but after having had to revert this
patch since it breaks x86, I am looking into more detail and I have
trouble figuring *why* this would fail on x86 since, as Dave points
out, the x86 Linux kernel does not release boot services data regions
for general allocation until much later.

Mike (or Peter), do you happen to have a Linux boot log of the case
where the BGRT is being corrupted?
