From: "Baicar, Tyler" <tbaicar@codeaurora.org>
Subject: Re: [PATCH V4 09/10] trace, ras: add ARM processor error trace event
Date: Mon, 24 Oct 2016 11:21:21 -0600
Message-ID: <7a8c62a7-c2f4-0cae-ce0a-24cbf827bd4f@codeaurora.org>
References: <1477071013-29563-1-git-send-email-tbaicar@codeaurora.org>
 <1477071013-29563-10-git-send-email-tbaicar@codeaurora.org>
 <20161021163410.0a827eab@gandalf.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
In-Reply-To: <20161021163410.0a827eab@gandalf.local.home>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-efi@vger.kernel.org, kvm@vger.kernel.org, matt@codeblueprint.co.uk, catalin.marinas@arm.com, will.deacon@arm.com, robert.moore@intel.com, paul.gortmaker@windriver.com, lv.zheng@intel.com, kvmarm@lists.cs.columbia.edu, fu.wei@linaro.org, zjzhang@codeaurora.org, linux@armlinux.org.uk, linux-acpi@vger.kernel.org, eun.taik.lee@samsung.com, shijie.huang@arm.com, lenb@kernel.org, harba@codeaurora.org, marc.zyngier@arm.com, punit.agrawal@arm.com, tomasz.nowicki@linaro.org, nkaje@codeaurora.org, sandeepa.s.prabhu@gmail.com, linux-arm-kernel@lists.infradead.org, rjw@rjwysocki.net, rruigrok@codeaurora.org, linux-kernel@vger.kernel.org, astone@redhat.com, hanjun.guo@linaro.org, pbonzini@redhat.com, akpm@linux-foundation.org, bristot@redhat.com
List-Id: linux-efi@vger.kernel.org

On 10/21/2016 2:34 PM, Steven Rostedt wrote:
> On Fri, 21 Oct 2016 11:30:12 -0600
> Tyler Baicar <tbaicar@codeaurora.org> wrote:
>
>> Currently there are trace events for the various RAS
>> errors with the exception of ARM processor type errors.
>> Add a new trace event for such errors so that the user
>> will know when they occur. These trace events are
>> consistent with the ARM processor error section type
>> defined in UEFI 2.6 spec section N.2.4.4.
>>
>> Signed-off-by: Tyler Baicar <tbaicar@codeaurora.org>
> Tracing part looks fine to me.
>
> Acked-by: Steven Rostedt <rostedt@goodmis.org>
>
> -- Steve
Thank you Steve!

-- 
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project.
