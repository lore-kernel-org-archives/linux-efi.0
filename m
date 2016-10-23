From: Hanjun Guo <guohanjun@huawei.com>
Subject: Re: [PATCH V3 05/10] acpi: apei: handle SEA notification type for
 ARMv8
Date: Sun, 23 Oct 2016 17:13:28 +0800
Message-ID: <580C7F38.4010301@huawei.com>
References: <1475875882-2604-1-git-send-email-tbaicar@codeaurora.org>
 <1475875882-2604-6-git-send-email-tbaicar@codeaurora.org>
 <496ddac3-a220-fd42-5ca1-3d0fb0238907@linaro.org>
 <1941586c-4c51-60d8-a77a-ad56fe5f3e3f@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <1941586c-4c51-60d8-a77a-ad56fe5f3e3f@codeaurora.org>
Sender: linux-acpi-owner@vger.kernel.org
To: "Abdulhamid, Harb" <harba@codeaurora.org>, Hanjun Guo <hanjun.guo@linaro.org>, Tyler Baicar <tbaicar@codeaurora.org>, christoffer.dall@linaro.org, marc.zyngier@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, rjw@rjwysocki.net, lenb@kernel.org, matt@codeblueprint.co.uk, robert.moore@intel.com, lv.zheng@intel.com, mark.rutland@arm.com, james.morse@arm.com, akpm@linux-foundation.org, sandeepa.s.prabhu@gmail.com, shijie.huang@arm.com, paul.gortmaker@windriver.com, tomasz.nowicki@linaro.org, fu.wei@linaro.org, rostedt@goodmis.org, bristot@redhat.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, Dkvm@vger.kernel.org, linux-kernel
Cc: Naveen Kaje <nkaje@codeaurora.org>, "Jonathan (Zhixiong) Zhang" <zjzhang@codeaurora.org>
List-Id: linux-efi@vger.kernel.org

Hi Harb,

On 2016/10/20 0:59, Abdulhamid, Harb wrote:
> On 10/18/2016 8:44 AM, Hanjun Guo wrote:
>> Hi Tyler,
>>
>> On 2016/10/8 5:31, Tyler Baicar wrote:
>>> ARM APEI extension proposal added SEA (Synchrounous External
>>> Abort) notification type for ARMv8.
>>> Add a new GHES error source handling function for SEA. If an error
>>> source's notification type is SEA, then this function can be registered
>>> into the SEA exception handler. That way GHES will parse and report
>>> SEA exceptions when they occur.
>> Does this SEA is replayed by the firmware (firmware first handling)
>> or directly triggered by the hardware when error is happened?
> Architecturally, an SEA must be synchronous and *precise*, so if you
> take an SEA on a particular load instruction, firmware/hardware should
> not be corrupting the context/state of the PE to allow software to
> determine which thread/process encountered the abort.  GHES error status

That's my concern too, and that's why I raised my question :)

> block will be expose to software with information about the type,
> severity, physical address impacted.
>
> Generally the error status block is populated by firmware.  However, as
> long as the above requirement is met, I don't think the spec precludes
> error status block being populated by hardware.  Those details must be
> completely transparent to software.
>
> Finally, to answer your more specific question:  If the implementation
> of firmware-first involves trapping the SEA in EL3 to do some firmware
> first handling, firmware must maintain the context of the offending ELx,
> generate an error record, and then "replay" the exception to normal
> (non-secure) software at the appropriate vector base address.
>

Thank you for your answer, it clears my confusion now, I will try something
similar on ARM64 platform, will get back to you if I get blocks.

Thanks
Hanjun

