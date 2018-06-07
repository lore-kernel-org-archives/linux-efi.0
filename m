From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: Do Qualcomm drivers use DMA buffers for
 request_firmware_into_buf()?
Date: Thu, 7 Jun 2018 18:23:01 +0200
Message-ID: <CAKv+Gu8+Fq7BD4XD-YCyXzZh0mg6Z2k-0styj0cw6_uZfaqy4Q@mail.gmail.com>
References: <20180423211143.GZ14440@wotan.suse.de>
 <71e6a45a-398d-b7a4-dab0-8b9936683226@redhat.com>
 <1524586021.3364.20.camel@linux.vnet.ibm.com>
 <20180424234219.GX14440@wotan.suse.de>
 <1524632409.3371.48.camel@linux.vnet.ibm.com>
 <20180425175557.GY14440@wotan.suse.de>
 <CAB0TPYGnCu+anWHBGvkaigxD--8uHQaQJ2c62kegJ7mTqvkmnA@mail.gmail.com>
 <20180508153805.GC27853@wotan.suse.de> <20180601192346.GQ4511@wotan.suse.de>
 <20180606203257.GH4511@wotan.suse.de> <20180607161847.GN510@tuxbook-pro>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20180607161847.GN510@tuxbook-pro>
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
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Matt Fleming <matt@codeblueprint.co.uk>, Will Deacon <will.deacon@arm.com>, Michal Hocko <mhocko@kernel.org>, David Howells <dhowells@redhat.com>, David Brown <david.brown@linaro.org>, Peter Jones <pjones@redhat.com>, "Luis R. Rodriguez" <mcgrof@kernel.org>, "H . Peter Anvin" <hpa@zytor.com>, "open list:ANDROID DRIVERS" <devel@driverdev.osuosl.org>, Nicolas Broeking <nbroeking@me.com>, Jonathan Corbet <corbet@lwn.net>, the arch/x86 maintainers <x86@kernel.org>, Arve Hj?nnev?g <arve@android.com>, Ingo Molnar <mingo@redhat.com>, Kalle Valo <kvalo@codeaurora.org>, Andy Gross <andy.gross@linaro.org>, Darren Hart <dvhart@infradead.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Arend Van Spriel <arend.vanspriel@broadcom.com>, Todd Kjos <tkjos@android.com>, Kees Cook <keescook@chromium.org>, linux-efi <linux-efi@vger.kernel.org>, Rik
List-Id: linux-efi@vger.kernel.org

On 7 June 2018 at 18:18, Bjorn Andersson <bjorn.andersson@linaro.org> wrote:
> On Wed 06 Jun 13:32 PDT 2018, Luis R. Rodriguez wrote:
>
>> On Fri, Jun 01, 2018 at 09:23:46PM +0200, Luis R. Rodriguez wrote:
>> > On Tue, May 08, 2018 at 03:38:05PM +0000, Luis R. Rodriguez wrote:
>> > > On Fri, May 04, 2018 at 12:44:37PM -0700, Martijn Coenen wrote:
>> > > >
>> > > > I think the Qualcomm folks owning this (Andy, David, Bjorn, already
>> > > > cc'd here) are better suited to answer that question.
>> > >
>> > > Andy, David, Bjorn?
>> >
>> > Andy, David, Bjorn?
>>
>> A month now with no answer...
>>
>
> The patch at the top of this thread doesn't interest me and you didn't
> bother sending your question To me.
>
> As a matter of fact I'm confused to what the actual question is.
>

The actual question is whether it is really required that the firmware
is loaded by the kernel into a buffer that is already mapped for DMA
at that point, and thus accessible by the device.

To me, it is not entirely clear what the nature is of the firmware
that we are talking about, since it seems to be getting passed to the
secure world as well?

In any case, the preferred model in terms of validation/sig checking is

1) allocate a CPU accessible buffer

2) request the firmware into it (which may include a sig check under the hood)

3) map the buffer for DMA to the device so it can load the firmware.

4) kick off the DMA transfer.

The use of dma_alloc_coherent() for this purpose seems unnecessary,
given that the DMA transfer is not bidirectional. Would it be possible
to replace it with something like the above sequence?

-- 
Ard.



>> Perhaps someone who has this hardware can find out empirically for us, as
>> follows (mm folks is this right?):
>>
>> page = virt_to_page(address);
>> if (!page)
>>    fail closed...
>> if (page_zone(page) == ZONE_DMA || page_zone(page) == ZONE_DMA32)
>>       this is a DMA buffer
>> else
>>       not DMA!
>>
>
> Where do you want to put this?
>
>> Note that when request_firmware_into_buf() was being reviewed Mimi had asked back
>> in 2016 [0] that if a DMA buffer was going to be used READING_FIRMWARE_DMA should be
>> used otherwise READING_FIRMWARE_PREALLOC_BUFFER was fine.
>>
>> If it is a DMA buffer *now*, why / how did this change?
>>
>
> From what I can see [0] says is to use READING_FIRMWARE_PREALLOC_BUFFER
> regardless of where the memory comes from.
>
> Regards,
> Bjorn
>
>> [0] https://patchwork.kernel.org/patch/9074611/
>>
>>   Luis
