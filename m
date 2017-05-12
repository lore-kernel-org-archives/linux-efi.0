From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH V15 06/11] acpi: apei: handle SEA notification type for
 ARMv8
Date: Fri, 12 May 2017 17:45:16 +0100
Message-ID: <5915E69C.5090201@arm.com>
References: <1492556723-9189-1-git-send-email-tbaicar@codeaurora.org> <1492556723-9189-7-git-send-email-tbaicar@codeaurora.org> <5910AAB8.8070703@arm.com> <9e26f779-5eae-2558-6045-10c1afde9bf2@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <9e26f779-5eae-2558-6045-10c1afde9bf2@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Baicar, Tyler" <tbaicar@codeaurora.org>
Cc: christoffer.dall@linaro.org, marc.zyngier@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, rjw@rjwysocki.net, lenb@kernel.org, matt@codeblueprint.co.uk, robert.moore@intel.com, lv.zheng@intel.com, nkaje@codeaurora.org, zjzhang@codeaurora.org, mark.rutland@arm.com, akpm@linux-foundation.org, eun.taik.lee@samsung.com, sandeepa.s.prabhu@gmail.com, labbott@redhat.com, shijie.huang@arm.com, rruigrok@codeaurora.org, paul.gortmaker@windriver.com, tn@semihalf.com, fu.wei@linaro.org, rostedt@goodmis.org, bristot@redhat.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, linux-efi@vger.kernel.org, devel@acpica.org, Suzuki.Po
List-Id: linux-efi@vger.kernel.org

Hi Tyler,

On 08/05/17 20:59, Baicar, Tyler wrote:
> On 5/8/2017 11:28 AM, James Morse wrote:
>> I was tidying up the masking/unmasking in entry.S, something I wasn't aware of
>> that leads to a bug:
>> entry.S will unmask interrupts for instruction/data aborts that came from a
>> context with interrupts enabled. This makes sense for get_user() and friends...
>> For do_sea() we pull nmi_enter() as this can interrupt interrupts-masked code,
>> such as APEI, but if we end up in here with interrupts unmasked we can take an
>> IRQ from this 'NMI' context, which will inherit the in_nmi() and could lead to
>> the deadlock we were originally trying to avoid.
>>
>> Teaching entry.S to spot external aborts is messy. I think the two choices are
>> to either mask interrupts when calling nmi_enter() (as these things should be
>> mutually exclusive), or to conditionally call nmi_enter() based on
>> interrupts_enabled(regs). I prefer the second one as it matches the notify_sea()
>> while interruptible that happens when KVM takes one of these.

Thinking about this some more: the KVM case is different as we know it was a
guest that triggered the external abort. Nothing the host kernel does is likely
to trigger either the same error or a related one.

But I can't think of a way this would trip twice on the host... yes your
suggestion looks fine.

(When we add SError/SEI support too we will need to change it as SEA may
interrupt SEI, and nmi_enter() has a BUG_ON(in_nmi()), so this nesting will need
explicitly checking.)


Thanks,

James
