From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 2/4] efi/x86: move efi bgrt init code to early init code
Date: Tue, 17 Jan 2017 17:00:03 +0000
Message-ID: <CAKv+Gu_dsVPQ663-UvUGhBy3e2yyZcznV+FQi9qpvbhJ726yng@mail.gmail.com>
References: <20170112094118.815108042@redhat.com> <20170112094214.909117564@redhat.com>
 <CAKv+Gu-U3JxbhYPpmm9synQXeqe11gFwntGVBTHsmmiPenQNmw@mail.gmail.com>
 <20170112213354.GC2709@dhcp-128-65.nay.redhat.com> <CACi5LpOJT8K1cn_aOAZi-4-0Z_TyLg-hUnvioBq_AwnFwGihag@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CACi5LpOJT8K1cn_aOAZi-4-0Z_TyLg-hUnvioBq_AwnFwGihag@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bhupesh Sharma <bhsharma@redhat.com>
Cc: Dave Young <dyoung@redhat.com>, Matt Fleming <matt@codeblueprint.co.uk>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, Nicolai Stange <nicstange@gmail.com>, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "hpa@zytor.com" <hpa@zytor.com>, Dan Williams <dan.j.williams@intel.com>, =?UTF-8?Q?Mika_Penttil=C3=A4?= <mika.penttila@nextfour.com>
List-Id: linux-efi@vger.kernel.org

On 16 January 2017 at 15:15, Bhupesh Sharma <bhsharma@redhat.com> wrote:
> Thanks Dave.
>
> On Fri, Jan 13, 2017 at 3:03 AM, Dave Young <dyoung@redhat.com> wrote:
>> On 01/12/17 at 04:20pm, Ard Biesheuvel wrote:
>>> On 12 January 2017 at 09:41, Dave Young <dyoung@redhat.com> wrote:
>>> > Before invoking the arch specific handler, efi_mem_reserve() reserves
>>> > the given memory region through memblock.
>>> >
>>> > efi_bgrt_init will call efi_mem_reserve after mm_init(), at that time
>>> > memblock is dead and it should not be used any more.
>>> >
>>> > efi bgrt code depend on acpi intialization to get the bgrt acpi table,
>>> > moving bgrt parsing to acpi early boot code can make sure efi_mem_reserve
>>> > in efi bgrt code still use memblock safely.
>>> >
>>> > Signed-off-by: Dave Young <dyoung@redhat.com>
>>>
>>> I know this is probably out of scope for you, but since we're moving
>>> things around, any chance we could do so in a manner that will enable
>>> BGRT support for arm64/ACPI? Happy to test/collaborate on this.
>>>
>>
>> I'm happy to do so, Bhupesh Sharma <bhsharma@redhat.com> said he had
>> some investigation on that already, I would like to ask him to help on that.
>>
>> Already cced him..
>
>
> Hi Ard,
>
> I have started working on an implementation where most of the BGRT
> code which exists inside 'arch/x86/platform/efi-bgrt.c' can be reused
> for ARM/ARM64.
>
> I am testing a RFC approach for the same using Qemu for AARCH64. I
> have sent out a patch to enable BGRT support in ArmVirtPkg (see [1])
>
> I have one question regarding the placement of the early bgrt handling
> code so that it can be reused on both arm/arm64 and x86:
>
> - Should I consider moving the current code from
> arch/x86/platform/efi-bgrt.c to outside arch/x86 so that it can be
> used by both the ARCHs or should I reuse the existing x86 stuff in a
> ARM specific way - no mem_remap for e.g. in a find inside arch/arm -
> say efi-arm-bgrt.c
>

-ENOPARSE

Please first move the code from x86 to a generic location
(drivers/firmware/efi or drivers/acpi), and make sure that it still
works as expected.
Then you can modify the code so that it works for arm64 as well as
x86, in a separate patch.

Thanks,
Ard.

> Suggestions?
>
>
> [1] https://lists.01.org/pipermail/edk2-devel/2017-January/006588.html
>
> Regards,
> Bhupesh
