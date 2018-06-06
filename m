From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: Do Qualcomm drivers use DMA buffers for
 request_firmware_into_buf()?
Date: Wed, 6 Jun 2018 22:41:07 +0200
Message-ID: <CAKv+Gu9+rLxoocCGkB7tRi03jkyPoQ5tX5bTN9C6A4iFj20mgQ@mail.gmail.com>
References: <20180408174014.21908-3-hdegoede@redhat.com>
 <20180423211143.GZ14440@wotan.suse.de>
 <71e6a45a-398d-b7a4-dab0-8b9936683226@redhat.com>
 <1524586021.3364.20.camel@linux.vnet.ibm.com>
 <20180424234219.GX14440@wotan.suse.de>
 <1524632409.3371.48.camel@linux.vnet.ibm.com>
 <20180425175557.GY14440@wotan.suse.de>
 <CAB0TPYGnCu+anWHBGvkaigxD--8uHQaQJ2c62kegJ7mTqvkmnA@mail.gmail.com>
 <20180508153805.GC27853@wotan.suse.de> <20180601192346.GQ4511@wotan.suse.de>
 <20180606203257.GH4511@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20180606203257.GH4511@wotan.suse.de>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Matt Fleming <matt@codeblueprint.co.uk>, Will Deacon <will.deacon@arm.com>, Michal Hocko <mhocko@kernel.org>, David Howells <dhowells@redhat.com>, David Brown <david.brown@linaro.org>, Peter Jones <pjones@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, "open list:ANDROID DRIVERS" <devel@driverdev.osuosl.org>, Nicolas Broeking <nbroeking@me.com>, Jonathan Corbet <corbet@lwn.net>, the arch/x86 maintainers <x86@kernel.org>, =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>, Ingo Molnar <mingo@redhat.com>, Kalle Valo <kvalo@codeaurora.org>, Andy Gross <andy.gross@linaro.org>, Darren Hart <dvhart@infradead.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>, platform-driver-x86@vger.kernel.org, Arend Van Spriel <arend.vanspriel@broadcom.com>, Todd Kjos <tkjos@android.com>, Kees Cook <keescook@chromium.org>, linux-efi <linux-efi@vger.>
List-Id: linux-efi@vger.kernel.org

On 6 June 2018 at 22:32, Luis R. Rodriguez <mcgrof@kernel.org> wrote:
> On Fri, Jun 01, 2018 at 09:23:46PM +0200, Luis R. Rodriguez wrote:
>> On Tue, May 08, 2018 at 03:38:05PM +0000, Luis R. Rodriguez wrote:
>> > On Fri, May 04, 2018 at 12:44:37PM -0700, Martijn Coenen wrote:
>> > >
>> > > I think the Qualcomm folks owning this (Andy, David, Bjorn, already
>> > > cc'd here) are better suited to answer that question.
>> >
>> > Andy, David, Bjorn?
>>
>> Andy, David, Bjorn?
>
> A month now with no answer...
>
> Perhaps someone who has this hardware can find out empirically for us, as
> follows (mm folks is this right?):
>
> page = virt_to_page(address);
> if (!page)
>    fail closed...
> if (page_zone(page) == ZONE_DMA || page_zone(page) == ZONE_DMA32)
>         this is a DMA buffer
> else
>         not DMA!
>

As I replied in the other thread, this code makes no sense.

In general, any address covered by the kernel direct mapping can be
passed to the streaming DMA api and be mapped for device read xor
device write. Only DMA mappings that will be accessed randomly by the
device and the CPU at the same time require the use of
dma_alloc_coherent(), so it can take special precautions (e.g, create
an uncached mapping if DMA is non cache coherent)

The DMA zone thing is primarily about reserving low memory ranges for
DMA because some hardware may not have sufficient address lines wired
up to access all of DRAM.

> Note that when request_firmware_into_buf() was being reviewed Mimi had asked back
> in 2016 [0] that if a DMA buffer was going to be used READING_FIRMWARE_DMA should be
> used otherwise READING_FIRMWARE_PREALLOC_BUFFER was fine.
>
> If it is a DMA buffer *now*, why / how did this change?
>
> [0] https://patchwork.kernel.org/patch/9074611/
>
>   Luis
