From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] efi: arm/arm64: allow SetVirtualAddressMap() to be omitted
Date: Wed, 30 Jan 2019 19:29:14 +0100
Message-ID: <CAKv+Gu8Ay67aJtkq8z+tu915xXZ82=wbsXbD+_W+SJz-MdD7+Q@mail.gmail.com>
References: <20190126102207.29488-1-ard.biesheuvel@linaro.org>
 <20190130181948.GC18558@fuggles.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20190130181948.GC18558@fuggles.cambridge.arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Will Deacon <will.deacon@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>, linux-efi <linux-efi@vger.kernel.org>, Heinrich Schuchardt <xypron.glpk@gmx.de>, Alexander Graf <agraf@suse.de>, Leif Lindholm <leif.lindholm@linaro.org>, AKASHI Takahiro <takahiro.akashi@linaro.org>, James Morse <james.morse@arm.com>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
List-Id: linux-efi@vger.kernel.org

On Wed, 30 Jan 2019 at 19:19, Will Deacon <will.deacon@arm.com> wrote:
>
> Hi Ard,
>

Hi Will,

> On Sat, Jan 26, 2019 at 11:22:07AM +0100, Ard Biesheuvel wrote:
> > The UEFI spec revision 2.7 errata A section 8.4 has the following to
> > say about the virtual memory runtime services:
> >
> >   "This section contains function definitions for the virtual memory
> >   support that may be optionally used by an operating system at runtime.
> >   If an operating system chooses to make EFI runtime service calls in a
> >   virtual addressing mode instead of the flat physical mode, then the
> >   operating system must use the services in this section to switch the
> >   EFI runtime services from flat physical addressing to virtual
> >   addressing."
>
> I should probably go RTFM, but what does UEFI say about the attributes of
> "flat physical addressing"? The wording above implies to me that it should
> act as though the stage-1 MMU is disabled because it's described as an
> alternative to virtual addressing.
>

No. Flat physical addressing applies to the translation, not to the
memory attributes. The UEFI spec is pretty detailed when it comes to
how the MMU should be configured and which memory attributes should be
used while running in the firmware, and while running under the OS,
and that is orthogonal.

> If we move in a direction where we avoid calling SetVirtualAddressMap() by
> default on arm64, isn't there a real threat that this firmware call will no
> longer be validated? Do we need to worry about that?
>

Yes. From a validation pov, it is useful to have both options, since
optional functionality should work as specified, but it should also be
truly optional, and with this change, we can at least validate that.

Whether this will ever become the default or not is something we can
debate at a later date.

> Finally, Bjorn said that SDM850 is unbootable without this change. Why is
> that?
>

sdm835 and sdm850 are used in Windows on ARM laptops, and Windows
behaves differently in this regard. The main issue is that the virtual
mapping that Windows installs (which is a kernel mapping) is already
active when it makes the call to SetVirtualAddressMap(), which means
drivers can get away with accessing both the old and the new mapping
in the context of that call. On Linux, the new VA mapping is not
mapped yet, and so the code crashes.

Another problem is that the PE/COFF relocation processing requires
that the code sections are mapped read-write after ExitBootServices(),
and the QC firmware is relying on Windows to clear the r/o
permissions, rather than clear the r/o bits itself.
