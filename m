From: "Baicar, Tyler" <tbaicar@codeaurora.org>
Subject: Re: [PATCH V14 02/10] ras: acpi/apei: cper: generic error data entry
 v3 per ACPI 6.1
Date: Thu, 13 Apr 2017 15:33:13 -0600
Message-ID: <faa953d1-61bd-4b53-af0d-1980d9b55d68@codeaurora.org>
References: <1490729440-32591-1-git-send-email-tbaicar@codeaurora.org>
 <1490729440-32591-3-git-send-email-tbaicar@codeaurora.org>
 <20170412133447.n2yft7v266v6k6gh@pd.tnic>
 <8a31ef45-68f6-d444-f174-4a485cccd696@codeaurora.org>
 <20170413204744.iizyyi32v4hjt3fc@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170413204744.iizyyi32v4hjt3fc@pd.tnic>
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
To: Borislav Petkov <bp@alien8.de>
Cc: christoffer.dall@linaro.org, marc.zyngier@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, rjw@rjwysocki.net, lenb@kernel.org, matt@codeblueprint.co.uk, robert.moore@intel.com, lv.zheng@intel.com, nkaje@codeaurora.org, zjzhang@codeaurora.org, mark.rutland@arm.com, james.morse@arm.com, akpm@linux-foundation.org, eun.taik.lee@samsung.com, sandeepa.s.prabhu@gmail.com, labbott@redhat.com, shijie.huang@arm.com, rruigrok@codeaurora.org, paul.gortmaker@windriver.com, tn@semihalf.com, fu.wei@linaro.org, rostedt@goodmis.org, bristot@redhat.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On 4/13/2017 2:47 PM, Borislav Petkov wrote:
> On Thu, Apr 13, 2017 at 02:30:21PM -0600, Baicar, Tyler wrote:
>> I do not agree with this. The struct being passed to this function is
>> already named acpi_hest_generic_data in the existing code and all over this
>> code is named gdata not just d.
> And I'm saying they're too long - the preexisting ones and the ones
> you're adding - and impair readability. This whole driver is one
> unreadable ugly pile and if I were the maintainer I would never allowed
> it in its current form.
>
> But I don't think it really has a maintainer - poor Rafael has to deal
> with it because it is under drivers/acpi/ and that whole RAS firmware
> crap got thrown over the wall at some point and now we're stuck with it.
>
> So this is just my opinion since he asked me to take a look.
Okay, that makes sense. I'd prefer to avoid completely re-writing the 
existing code in this patch set :)

Thanks,
Tyler

-- 
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project.
