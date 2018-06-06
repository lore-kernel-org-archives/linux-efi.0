From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: Do Qualcomm drivers use DMA buffers for
 request_firmware_into_buf()?
Date: Thu, 7 Jun 2018 00:29:29 +0200
Message-ID: <20180606222929.GK4511@wotan.suse.de>
References: <71e6a45a-398d-b7a4-dab0-8b9936683226@redhat.com>
 <1524586021.3364.20.camel@linux.vnet.ibm.com>
 <20180424234219.GX14440@wotan.suse.de>
 <1524632409.3371.48.camel@linux.vnet.ibm.com>
 <20180425175557.GY14440@wotan.suse.de>
 <CAB0TPYGnCu+anWHBGvkaigxD--8uHQaQJ2c62kegJ7mTqvkmnA@mail.gmail.com>
 <20180508153805.GC27853@wotan.suse.de>
 <20180601192346.GQ4511@wotan.suse.de>
 <20180606203257.GH4511@wotan.suse.de>
 <CAKv+Gu9+rLxoocCGkB7tRi03jkyPoQ5tX5bTN9C6A4iFj20mgQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu9+rLxoocCGkB7tRi03jkyPoQ5tX5bTN9C6A4iFj20mgQ@mail.gmail.com>
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
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Matt Fleming <matt@codeblueprint.co.uk>, Will Deacon <will.deacon@arm.com>, Michal Hocko <mhocko@kernel.org>, David Howells <dhowells@redhat.com>, David Brown <david.brown@linaro.org>, Peter Jones <pjones@redhat.com>, "Luis R. Rodriguez" <mcgrof@kernel.org>, "H . Peter Anvin" <hpa@zytor.com>, "open list:ANDROID DRIVERS" <devel@driverdev.osuosl.org>, Nicolas Broeking <nbroeking@me.com>, Jonathan Corbet <corbet@lwn.net>, the arch/x86 maintainers <x86@kernel.org>, Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>, Ingo Molnar <mingo@redhat.com>, Kalle Valo <kvalo@codeaurora.org>, Andy Gross <andy.gross@linaro.org>, Darren Hart <dvhart@infradead.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>, platform-driver-x86@vger.kernel.org, Arend Van Spriel <arend.vanspriel@broadcom.com>, Todd Kjos <tkjos@android.com>, Kees Cook <keescook@ch>
List-Id: linux-efi@vger.kernel.org

On Wed, Jun 06, 2018 at 10:41:07PM +0200, Ard Biesheuvel wrote:
> On 6 June 2018 at 22:32, Luis R. Rodriguez <mcgrof@kernel.org> wrote:
> > On Fri, Jun 01, 2018 at 09:23:46PM +0200, Luis R. Rodriguez wrote:
> >> On Tue, May 08, 2018 at 03:38:05PM +0000, Luis R. Rodriguez wrote:
> >> > On Fri, May 04, 2018 at 12:44:37PM -0700, Martijn Coenen wrote:
> >> > >
> >> > > I think the Qualcomm folks owning this (Andy, David, Bjorn, already
> >> > > cc'd here) are better suited to answer that question.
> >> >
> >> > Andy, David, Bjorn?
> >>
> >> Andy, David, Bjorn?
> >
> > A month now with no answer...
> >
> > Perhaps someone who has this hardware can find out empirically for us, as
> > follows (mm folks is this right?):
> >
> > page = virt_to_page(address);
> > if (!page)
> >    fail closed...
> > if (page_zone(page) == ZONE_DMA || page_zone(page) == ZONE_DMA32)
> >         this is a DMA buffer
> > else
> >         not DMA!
> >
> 
> As I replied in the other thread, this code makes no sense.

OK thanks. If we can't figure it out in code we will have no option
but to expect the worst, specially considering the silence.

> In general, any address covered by the kernel direct mapping can be
> passed to the streaming DMA api and be mapped for device read xor
> device write.

Right, thanks for the details -- on the other thread [0] you've clarified
that with streaming DMA API the CPU *should not* use the buffer and so
*should *be "safe", however that's still a judgement and design call.

[0] https://lkml.kernel.org/r/20180606220605.GJ4511@wotan.suse.de

> Only DMA mappings that will be accessed randomly by the
> device and the CPU at the same time require the use of
> dma_alloc_coherent(), so it can take special precautions (e.g, create
> an uncached mapping if DMA is non cache coherent)

Right and the qcom drivers *does not* use the streaming DMA API, it uses
use dma_alloc_coherent() which explicitly allows the CPU to *immediately*
have access the buffer. We have no control over the CPU and have no ways
to vet that the data we give is complete and correct.

> The DMA zone thing is primarily about reserving low memory ranges for
> DMA because some hardware may not have sufficient address lines wired
> up to access all of DRAM.

Right.

The point to all this is that it is up to LSMs to decide and trust something,
and in this case, even with the streaming DMA API in mind, it is up to LSMs
to decide. In this case we have only *one* user of request_firmware_into_buf()
and code inspection is finding that very likely the dma_alloc_coherent() calls
on the path is actually using this same coherent DMA buffer for firmware.

> > Note that when request_firmware_into_buf() was being reviewed Mimi had asked back
> > in 2016 [0] that if a DMA buffer was going to be used READING_FIRMWARE_DMA should be
> > used otherwise READING_FIRMWARE_PREALLOC_BUFFER was fine.
> >
> > If it is a DMA buffer *now*, why / how did this change?
> >
> > [0] https://patchwork.kernel.org/patch/9074611/

So it is *specially* very odd and disappointing that even though Mimi
*specifically* asked a long time ago that if a DMA buffer would be used it
should be annotated as such with READING_FIRMWARE_DMA, why the annotation
continued forward with READING_FIRMWARE_PREALLOC_BUFFER instead.

Just as Mimi asked for READING_FIRMWARE_DMA it would seem we could reasonably also
ask now or READING_FIRMWARE_DMA_COHERENT and READING_FIRMWARE_DMA_STREAM and some
LSMs will just reject these calls. We don't need READING_FIRMWARE_DMA_STREAM now
as request_firmware_into_buf() users are using dma_alloc_coherent() so we are
trying to determine if request_firmware_into_buf() should pass:

	READING_FIRMWARE_DMA_COHERENT

Given no one is providing a clear answer, and we cannot easily describe the
buffer at run time we'll just move forward with READING_FIRMWARE_DMA_COHERENT.

  Luis
