From: "Baicar, Tyler" <tbaicar@codeaurora.org>
Subject: Re: [PATCH V13 09/10] trace, ras: add ARM processor error trace event
Date: Tue, 21 Mar 2017 21:05:24 -0600
Message-ID: <060cefca-0020-411a-a27d-ede7102cac09@codeaurora.org>
References: <1490136425-4324-1-git-send-email-tbaicar@codeaurora.org>
 <1490136425-4324-10-git-send-email-tbaicar@codeaurora.org>
 <e1e63cbb-a75e-af11-4fa0-446b40999ee8@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
In-Reply-To: <e1e63cbb-a75e-af11-4fa0-446b40999ee8@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Xie XiuQi <xiexiuqi@huawei.com>, christoffer.dall@linaro.org, marc.zyngier@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, rjw@rjwysocki.net, lenb@kernel.org, matt@codeblueprint.co.uk, robert.moore@intel.com, lv.zheng@intel.com, nkaje@codeaurora.org, zjzhang@codeaurora.org, mark.rutland@arm.com, james.morse@arm.com, akpm@linux-foundation.org, eun.taik.lee@samsung.com, sandeepa.s.prabhu@gmail.com, labbott@redhat.com, shijie.huang@arm.com, rruigrok@codeaurora.org, paul.gortmaker@windriver.com, tn@semihalf.com, fu.wei@linaro.org, rostedt@goodmis.org, bristot@redhat.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, linux-efi@vger.kernel.org, devel@acpica.org, Suzuki.Poulose@arm.com, punit.agrawal@arm.com
List-Id: linux-efi@vger.kernel.org

Hello Xie XiuQi,

On 3/21/2017 8:48 PM, Xie XiuQi wrote:
> Reviewed-by: Xie XiuQi <xiexiuqi@huawei.com>
Thank you!
Tyler
>
> On 2017/3/22 6:47, Tyler Baicar wrote:
>> Currently there are trace events for the various RAS
>> errors with the exception of ARM processor type errors.
>> Add a new trace event for such errors so that the user
>> will know when they occur. These trace events are
>> consistent with the ARM processor error section type
>> defined in UEFI 2.6 spec section N.2.4.4.
>>
>> Signed-off-by: Tyler Baicar <tbaicar@codeaurora.org>
>> Acked-by: Steven Rostedt <rostedt@goodmis.org>
>> ---
>>   drivers/acpi/apei/ghes.c    |  8 +++++++-
>>   drivers/firmware/efi/cper.c |  1 +
>>   drivers/ras/ras.c           |  1 +
>>   include/ras/ras_event.h     | 45 +++++++++++++++++++++++++++++++++++++++++++++
>>   4 files changed, 54 insertions(+), 1 deletion(-)
>>
>>

-- 
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project.
