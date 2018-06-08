From: Vlastimil Babka <vbabka@suse.cz>
Subject: Re: Do Qualcomm drivers use DMA buffers for
 request_firmware_into_buf()?
Date: Fri, 8 Jun 2018 08:41:28 +0200
Message-ID: <39e942b6-795c-b7c8-bf9d-16907ef40aea@suse.cz>
References: <1524586021.3364.20.camel@linux.vnet.ibm.com>
 <20180424234219.GX14440@wotan.suse.de>
 <1524632409.3371.48.camel@linux.vnet.ibm.com>
 <20180425175557.GY14440@wotan.suse.de>
 <CAB0TPYGnCu+anWHBGvkaigxD--8uHQaQJ2c62kegJ7mTqvkmnA@mail.gmail.com>
 <20180508153805.GC27853@wotan.suse.de> <20180601192346.GQ4511@wotan.suse.de>
 <20180606203257.GH4511@wotan.suse.de> <20180607161847.GN510@tuxbook-pro>
 <CAKv+Gu8+Fq7BD4XD-YCyXzZh0mg6Z2k-0styj0cw6_uZfaqy4Q@mail.gmail.com>
 <20180607163308.GA18834@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180607163308.GA18834@kroah.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Bjorn Andersson <bjorn.andersson@linaro.org>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, Matt Fleming <matt@codeblueprint.co.uk>, Will Deacon <will.deacon@arm.com>, Michal Hocko <mhocko@kernel.org>, David Howells <dhowells@redhat.com>, David Brown <david.brown@linaro.org>, Peter Jones <pjones@redhat.com>, "Luis R. Rodriguez" <mcgrof@kernel.org>, "H . Peter Anvin" <hpa@zytor.com>, "open list:ANDROID DRIVERS" <devel@driverdev.osuosl.org>, Nicolas Broeking <nbroeking@me.com>, Jonathan Corbet <corbet@lwn.net>, the arch/x86 maintainers <x86@kernel.org>, Arve Hj?nnev?g <arve@android.com>, Ingo Molnar <mingo@redhat.com>, Kalle Valo <kvalo@codeaurora.org>, Andy Gross <andy.gross@linaro.org>, Darren Hart <dvhart@infradead.org>Mimi Zohar <z>
List-Id: linux-efi@vger.kernel.org

On 06/07/2018 06:33 PM, Greg Kroah-Hartman wrote:
> On Thu, Jun 07, 2018 at 06:23:01PM +0200, Ard Biesheuvel wrote:
>> On 7 June 2018 at 18:18, Bjorn Andersson <bjorn.andersson@linaro.org> wrote:
>>> On Wed 06 Jun 13:32 PDT 2018, Luis R. Rodriguez wrote:
>>>
>>>> On Fri, Jun 01, 2018 at 09:23:46PM +0200, Luis R. Rodriguez wrote:
>>>>> On Tue, May 08, 2018 at 03:38:05PM +0000, Luis R. Rodriguez wrote:
>>>>>> On Fri, May 04, 2018 at 12:44:37PM -0700, Martijn Coenen wrote:
>>>>>>>
>>>>>>> I think the Qualcomm folks owning this (Andy, David, Bjorn, already
>>>>>>> cc'd here) are better suited to answer that question.
>>>>>>
>>>>>> Andy, David, Bjorn?
>>>>>
>>>>> Andy, David, Bjorn?
>>>>
>>>> A month now with no answer...
>>>>
>>>
>>> The patch at the top of this thread doesn't interest me and you didn't
>>> bother sending your question To me.
>>>
>>> As a matter of fact I'm confused to what the actual question is.
>>>
>>
>> The actual question is whether it is really required that the firmware
>> is loaded by the kernel into a buffer that is already mapped for DMA
>> at that point, and thus accessible by the device.
>>
>> To me, it is not entirely clear what the nature is of the firmware
>> that we are talking about, since it seems to be getting passed to the
>> secure world as well?
>>
>> In any case, the preferred model in terms of validation/sig checking is
>>
>> 1) allocate a CPU accessible buffer
>>
>> 2) request the firmware into it (which may include a sig check under the hood)
>>
>> 3) map the buffer for DMA to the device so it can load the firmware.
>>
>> 4) kick off the DMA transfer.
>>
>> The use of dma_alloc_coherent() for this purpose seems unnecessary,
>> given that the DMA transfer is not bidirectional. Would it be possible
>> to replace it with something like the above sequence?
> 
> Why not just use kmalloc, it will always return a DMAable buffer.

DMAble in what sense? For devices that can't handle physical addresses
above 16M you need to pass __GFP_DMA to get those, from ZONE_DMA.
Otherwise it can return anything from lowmem. That's for x86_64, some
other arches have different DMA zone.

> Is the problem that vmalloc() might not?

vmalloc() could only be used as an alternative if you used kvmalloc(),
otherwise kmalloc() won't give you anything from vmalloc

> We need to drop the whole DMA zone crud, it confuses everyone who sees
> it and was primarily for really really old systems.

Yeah that would be nice.

> greg k-h
> 
