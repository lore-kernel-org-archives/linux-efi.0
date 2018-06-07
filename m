From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: Do Qualcomm drivers use DMA buffers for
 request_firmware_into_buf()?
Date: Thu, 7 Jun 2018 20:42:47 +0200
Message-ID: <CAKv+Gu9yfa=dP-5Fzv8-E6O23zPJXJqquTAt6gCqYyt3OowkvA@mail.gmail.com>
References: <20180424234219.GX14440@wotan.suse.de>
 <1524632409.3371.48.camel@linux.vnet.ibm.com>
 <20180425175557.GY14440@wotan.suse.de>
 <CAB0TPYGnCu+anWHBGvkaigxD--8uHQaQJ2c62kegJ7mTqvkmnA@mail.gmail.com>
 <20180508153805.GC27853@wotan.suse.de> <20180601192346.GQ4511@wotan.suse.de>
 <20180606203257.GH4511@wotan.suse.de> <20180607161847.GN510@tuxbook-pro>
 <CAKv+Gu8+Fq7BD4XD-YCyXzZh0mg6Z2k-0styj0cw6_uZfaqy4Q@mail.gmail.com>
 <20180607163308.GA18834@kroah.com> <20180607182117.GR510@tuxbook-pro>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20180607182117.GR510@tuxbook-pro>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: linux-efi <linux-efi@vger.kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Will Deacon <will.deacon@arm.com>, Michal Hocko <mhocko@kernel.org>, David Howells <dhowells@redhat.com>, David Brown <david.brown@linaro.org>, Peter Jones <pjones@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, "open list:ANDROID DRIVERS" <devel@driverdev.osuosl.org>, linux-security-module <linux-security-module@vger.kernel.org>, Nicolas Broeking <nbroeking@me.com>, Jonathan Corbet <corbet@lwn.net>, the arch/x86 maintainers <x86@kernel.org>, "Luis R. Rodriguez" <mcgrof@kernel.org>, Ingo Molnar <mingo@redhat.com>, Vlastimil Babka <vbabka@suse.cz>, Andy Gross <andy.gross@linaro.org>, Darren Hart <dvhart@infradead.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Arend Van Spriel <arend.vanspriel@broadcom.com>, Todd Kjos <tkjos@android.com>, Kees Cook <keescook@chromium.org>, Rik van Riel <riel@surr>
List-Id: linux-efi@vger.kernel.org

On 7 June 2018 at 20:21, Bjorn Andersson <bjorn.andersson@linaro.org> wrote:
> On Thu 07 Jun 09:33 PDT 2018, Greg Kroah-Hartman wrote:
>
>> On Thu, Jun 07, 2018 at 06:23:01PM +0200, Ard Biesheuvel wrote:
>> > On 7 June 2018 at 18:18, Bjorn Andersson <bjorn.andersson@linaro.org> wrote:
>> > > On Wed 06 Jun 13:32 PDT 2018, Luis R. Rodriguez wrote:
>> > >
>> > >> On Fri, Jun 01, 2018 at 09:23:46PM +0200, Luis R. Rodriguez wrote:
>> > >> > On Tue, May 08, 2018 at 03:38:05PM +0000, Luis R. Rodriguez wrote:
>> > >> > > On Fri, May 04, 2018 at 12:44:37PM -0700, Martijn Coenen wrote:
>> > >> > > >
>> > >> > > > I think the Qualcomm folks owning this (Andy, David, Bjorn, already
>> > >> > > > cc'd here) are better suited to answer that question.
>> > >> > >
>> > >> > > Andy, David, Bjorn?
>> > >> >
>> > >> > Andy, David, Bjorn?
>> > >>
>> > >> A month now with no answer...
>> > >>
>> > >
>> > > The patch at the top of this thread doesn't interest me and you didn't
>> > > bother sending your question To me.
>> > >
>> > > As a matter of fact I'm confused to what the actual question is.
>> > >
>> >
>> > The actual question is whether it is really required that the firmware
>> > is loaded by the kernel into a buffer that is already mapped for DMA
>> > at that point, and thus accessible by the device.
>> >
>> > To me, it is not entirely clear what the nature is of the firmware
>> > that we are talking about, since it seems to be getting passed to the
>> > secure world as well?
>> >
>> > In any case, the preferred model in terms of validation/sig checking is
>> >
>> > 1) allocate a CPU accessible buffer
>> >
>> > 2) request the firmware into it (which may include a sig check under the hood)
>> >
>> > 3) map the buffer for DMA to the device so it can load the firmware.
>> >
>> > 4) kick off the DMA transfer.
>> >
>> > The use of dma_alloc_coherent() for this purpose seems unnecessary,
>> > given that the DMA transfer is not bidirectional. Would it be possible
>> > to replace it with something like the above sequence?
>>
>> Why not just use kmalloc, it will always return a DMAable buffer.
>>
>
> For the buffers being targeted by request_firmware_into_buf() the
> problem is that some of them has requirements of physical placement and
> they are all too big for kmalloc() (i.e. tens of mb).
>
>
> For the dma_alloc_coherent() buffer that was mentioned earlier, which is
> not related to the firmware loading, it's not used because the buffer is
> passed to secure world, which temporarily locks Linux out from the
> memory region. Traditionally this region was kmalloc'ed downstream, but
> due to speculative access violations this code moved to use the DMA
> streaming API, although there's no actual DMA going on.
>

OK, so you are relying on the fact that dma_alloc_coherent() gives you
a device mapping (because the qcom_scm device is described as non
cache coherent), but this sounds risky to me. The linear alias of that
memory will still be mapped cacheable, and could potentially still be
accessed speculatively AFAIK.

> For this a way to allocate a chunk of physical memory dynamically and
> then unmapping and remapping it dynamically in Linux sounds like a
> solution, instead of (ab)using the DMA API. This could also serve as
> basis for the firmware memory, where firmware is position independent -
> in which case this would be passed to request_firmware_into_buf().
>
