From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 2/4] efi/arm: defer persistent reservations until after
 paging_init()
Date: Tue, 6 Nov 2018 21:06:56 +0100
Message-ID: <CAKv+Gu_r38Bk_SZW-5qvtM7cmQ4-09dcFwNz29AyMceucdhadQ@mail.gmail.com>
References: <20181106113732.16351-1-ard.biesheuvel@linaro.org>
 <20181106113732.16351-3-ard.biesheuvel@linaro.org>
 <CAKv+Gu8OsFb7a5UTovN1yBXtSSY=ZtUBYUvNa_bPmcZGknNYQA@mail.gmail.com>
 <20181106190817.GN30658@n2100.armlinux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20181106190817.GN30658@n2100.armlinux.org.uk>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Russell King - ARM Linux <linux@armlinux.org.uk>
Cc: Mark Rutland <mark.rutland@arm.com>, linux-efi <linux-efi@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, Bhupesh Sharma <bhsharma@redhat.com>, Will Deacon <will.deacon@arm.com>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
List-Id: linux-efi@vger.kernel.org

On 6 November 2018 at 20:08, Russell King - ARM Linux
<linux@armlinux.org.uk> wrote:
> On Tue, Nov 06, 2018 at 08:02:58PM +0100, Ard Biesheuvel wrote:
>> On 6 November 2018 at 12:37, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>> > The new memory EFI reservation feature we introduced to allow memory
>> > reservations to persist across kexec may trigger an unbounded number
>> > of calls to memblock_reserve(). The memblock subsystem can deal with
>> > this fine, but not before memblock resizing is enabled, which we can
>> > only do after paging_init(), when the memory we reallocate the array
>> > into is actually mapped.
>> >
>> > So break out the memreserve table processing into a separate function
>> > and call if after paging_init() on both arm64 and ARM.
>> >
>> > Cc: Russell King <linux@armlinux.org.uk>
>> > Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>>
>> Russell,
>>
>> If you are ok with this patch, may I have your ack please? I would
>> like to send it out before the end of the week.
>
> You're not going to get a quick answer to this, because it needs me to
> investigate what the effect of this change actually is by code review.
> I can't guarantee when I'll get around to that.
>

Fair enough.

I will drop the ARM hunk for now then, and we'll fix ARM when you have
more time.

Thanks,
