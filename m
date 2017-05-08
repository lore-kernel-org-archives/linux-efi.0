From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v3 1/3] arm64: kvm: support kvmtool to detect RAS extension
 feature
Date: Mon, 08 May 2017 18:31:09 +0100
Message-ID: <5910AB5D.8060105@arm.com>
References: <CAMj-D2BS7UHLC3DGM5i7fSRsqDKHmLYg79UV7sT6yHGFy5aYfw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <CAMj-D2BS7UHLC3DGM5i7fSRsqDKHmLYg79UV7sT6yHGFy5aYfw@mail.gmail.com>
Sender: linux-acpi-owner@vger.kernel.org
To: gengdongjiu <gengdj.1984@gmail.com>
Cc: Tyler Baicar <tbaicar@codeaurora.org>, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, pbonzini@redhat.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, rjw@rjwysocki.net, Len Brown <lenb@kernel.org>, matt@codeblueprint.co.uk, robert.moore@intel.com, lv.zheng@intel.com, nkaje@codeaurora.org, zjzhang@codeaurora.org, mark.rutland@arm.com, akpm@linux-foundation.org, eun.taik.lee@samsung.com, Sandeepa Prabhu <sandeepa.s.prabhu@gmail.com>, labbott@redhat.com, shijie.huang@arm.com, rruigrok@codeaurora.org, paul.gortmaker@windriver.com, tn@semihalf.com, Fu Wei <fu.wei@linaro.org>, rostedt@goodmis.org, bristot@redhat.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kern
List-Id: linux-efi@vger.kernel.org

Hi gengdongjiu,

On 04/05/17 18:20, gengdongjiu wrote:
>> On 30/04/17 06:37, Dongjiu Geng wrote:
>>> Handle kvmtool's detection for RAS extension, because sometimes
>>> the APP needs to know the CPU's capacity
>>
>>> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
>>> index d9e9697..1004039 100644
>>> --- a/arch/arm64/kvm/reset.c
>>> +++ b/arch/arm64/kvm/reset.c
>>> @@ -64,6 +64,14 @@ static bool cpu_has_32bit_el1(void)
>>>   return !!(pfr0 & 0x20);
>>>  }
>>>
>>> +static bool kvm_arm_support_ras_extension(void)
>>> +{
>>> + u64 pfr0;
>>> +
>>> + pfr0 = read_system_reg(SYS_ID_AA64PFR0_EL1);
>>> + return !!(pfr0 & 0x10000000);
>>> +}
>>
>> Why are we telling user-space that the CPU has RAS extensions? EL0 can't do
>> anything with this and the guest EL1 can detect it from the id registers.
>>
>>
>> Are you using this to decide whether or not to generate a HEST for the guest?
> 
> James, yes, it is.  my current user-space qemu EL0 patches indeed will
> check the RAS  extensions.
> if has the RAS extensions. for SEA, userspace qemu will generate the
> CPER and inject the SEA to guest;
> for SEI,  userspace qemu sets the virtual SEI with the specified
> Syndrome(set the HCR_EL2.VSE and vsesr_el2 );
> if not have RAS extensions, Qemu does nothing

But you can use APEI in a guest on CPUs without the RAS extensions: the host may
signal memory errors to Qemu for any number of reasons, user-space shouldn't
care how it knows. Examples are PCI-AER, any APEI event notified by polling or
one of the flavours of irq.

I would expect Qemu to generate a HEST based on its abilities, i.e. if it
supports any mechanism of notifying the guest about errors. Choosing the
mechanism then depends on the type of error.

Ideally the Qemu code for HEST/GHES/CPER generation code using some of the irqs
and polling could be shared with x86, as these should be possible using common
KVM APIs.


>> If Qemu/kvmtool supports handling memory-failure notifications from signals you
>> should always generate a HEST. The GHES notification method could be anything
>> Qemu can deliver to the guest using the KVM APIs. Notifications from Qemu to the
>> guest don't depend on the RAS extensions. KVM has APIs for IRQ and SEA (you can
>> use KVM_SET_ONE_REG).
> 
> I will consider your suggestion to  always generate a CPER instead of

(generate a HEST, CPER are the runtime records. There are too many acronyms in
this space!)

> relying on the RAS extensions, thanks


Thanks,

James

