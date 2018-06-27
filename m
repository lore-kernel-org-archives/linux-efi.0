From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: Do Qualcomm drivers use DMA buffers for
 request_firmware_into_buf()?
Date: Thu, 28 Jun 2018 01:33:31 +0200
Message-ID: <20180627233331.GC21242@wotan.suse.de>
References: <20180601192346.GQ4511@wotan.suse.de>
 <20180606203257.GH4511@wotan.suse.de>
 <20180607161847.GN510@tuxbook-pro>
 <CAKv+Gu8+Fq7BD4XD-YCyXzZh0mg6Z2k-0styj0cw6_uZfaqy4Q@mail.gmail.com>
 <20180607163308.GA18834@kroah.com>
 <20180607182117.GR510@tuxbook-pro>
 <CAKv+Gu9yfa=dP-5Fzv8-E6O23zPJXJqquTAt6gCqYyt3OowkvA@mail.gmail.com>
 <20180626000808.GE1860@tuxbook-pro>
 <20180627180059.GA21242@wotan.suse.de>
 <CAKv+Gu-CZpr_tBs_+xz2uGAXcO5k5nKnfeqiD0qtH1AAfgU8+w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu-CZpr_tBs_+xz2uGAXcO5k5nKnfeqiD0qtH1AAfgU8+w@mail.gmail.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-efi <linux-efi@vger.kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Will Deacon <will.deacon@arm.com>, Bjorn Andersson <bjorn.andersson@linaro.org>, David Howells <dhowells@redhat.com>, David Brown <david.brown@linaro.org>, Peter Jones <pjones@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, "open list:ANDROID DRIVERS" <devel@driverdev.osuosl.org>, linux-security-module <linux-security-module@vger.kernel.org>, Nicolas Broeking <nbroeking@me.com>, Jonathan Corbet <corbet@lwn.net>, the arch/x86 maintainers <x86@kernel.org>, "Luis R. Rodriguez" <mcgrof@kernel.org>, Ingo Molnar <mingo@redhat.com>, Vlastimil Babka <vbabka@suse.cz>, Andy Gross <andy.gross@linaro.org>, Darren Hart <dvhart@infradead.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>, platform-driver-x86@vger.kernel.org, Arend Van Spriel <arend.vanspriel@broadcom.com>, Todd Kjos <tkjos@android.com>, Kees
List-Id: linux-efi@vger.kernel.org

On Thu, Jun 28, 2018 at 12:21:47AM +0200, Ard Biesheuvel wrote:
> On 27 June 2018 at 20:00, Luis R. Rodriguez <mcgrof@kernel.org> wrote:
> > On Mon, Jun 25, 2018 at 05:08:08PM -0700, Bjorn Andersson wrote:
> >> On Thu 07 Jun 11:42 PDT 2018, Ard Biesheuvel wrote:
> >>
> >> > On 7 June 2018 at 20:21, Bjorn Andersson <bjorn.andersson@linaro.org> wrote:
> >> > > On Thu 07 Jun 09:33 PDT 2018, Greg Kroah-Hartman wrote:
> >> [..]
> >> > >>
> >> > >> Why not just use kmalloc, it will always return a DMAable buffer.
> >> > >>
> >> > >
> >> > > For the buffers being targeted by request_firmware_into_buf() the
> >> > > problem is that some of them has requirements of physical placement and
> >> > > they are all too big for kmalloc() (i.e. tens of mb).
> >> > >
> >> > >
> >> > > For the dma_alloc_coherent() buffer that was mentioned earlier, which is
> >> > > not related to the firmware loading, it's not used because the buffer is
> >> > > passed to secure world, which temporarily locks Linux out from the
> >> > > memory region. Traditionally this region was kmalloc'ed downstream, but
> >> > > due to speculative access violations this code moved to use the DMA
> >> > > streaming API, although there's no actual DMA going on.
> >> > >
> >> >
> >> > OK, so you are relying on the fact that dma_alloc_coherent() gives you
> >> > a device mapping (because the qcom_scm device is described as non
> >> > cache coherent), but this sounds risky to me. The linear alias of that
> >> > memory will still be mapped cacheable, and could potentially still be
> >> > accessed speculatively AFAIK.
> >> >
> >>
> >> Yes and we are aware of the risk of having the linear alias present, but
> >> have yet to find a suitable way to handle this.
> >>
> >> The proposed mechanism was to use reserved-memory and memremap() the
> >> region while it should be available in Linux,
> >
> > That's still IO memory, and so it would be up to the specific device if
> > or not it could access the memory before a full write is done.
> >
> 
> The risk here is about having aliases with mismatched attributes,
> which may result in loss of coherency and corrupt your data.

That risk is a perhaps a practical risk.

> This is
> not about the risk of loading a file with an invalid signature

This is a theoretical risk LSMs wish to determine and based on information
assess what to do.

> And what do you mean by 'IO memory'? Bus masters that are not behind
> an IOMMU can access all of the kernel's memory all of the time,
> regardless of whether and how it chooses to use it. So from a security
> perspective, there is no distinction, and you can only distinguish
> between before and after informing the device where it can find the
> firmware buffer in memory.

I mean that using memremap() or ioremap() will is designed to give
hardware access to memory for IO purposes, and how writes occur
will vary, and as such we cannot give LSMs guarantees over that
the firmware API will finish a write and that the data provided
really is correct.

> So given that we are dealing here with other masters that can change
> all of your memory behind your back, including the actual code you are
> running that implements the signature check, 

LSMs have the option to trust the kernel, its about context and letting LSMs
decide. They have the right to not trust IO devices to a memory segment, as it
could break guarantees the kernel is making, so this is not about trust or
not, its about *information* and letting LSMs choose.

> I wonder if there is a
> point to obsessing about this use case from a validation point of
> view. The higher privilege level protects itself by doing its own
> signature check, and doing the same at a lower privilege level seems
> redundant to me.

Its up to LSMs to implement the policy.

> >> but while this would work
> >> for some cases (e.g. memory regions for semi-static firmware executed by
> >> co-processors) it doesn't handle the scenarios where the memory-need is
> >> dynamic.
> >>
> >> So suggestions are very welcome on how to better handle this.
> >
> > I *believe* Vlastimil's seems to suggest kvmalloc(), but note that if getting the
> > memory to be contiguous fails, it would fallback to a non-contiguous (vmalloc)
> > allocation.

I gave this some though and this obviously is just as good as trying to just use
kmalloc() as that is what is desired, the issue however *ensuring* that the allocation
will succeed. The only thing that I can think of there is somehow hinting upon boot
to reserve a special allocation for later use. If not at boot, perhaps a hint to
eventually give back the desired contigious allocation, but its beyond me if any
of this is in fact possible.

  Luis
