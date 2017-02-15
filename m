From: "Baicar, Tyler" <tbaicar@codeaurora.org>
Subject: Re: [PATCH V8 08/10] ras: acpi / apei: generate trace event for
 unrecognized CPER section
Date: Wed, 15 Feb 2017 10:06:23 -0700
Message-ID: <b1e44c1f-ff88-e43b-6bd3-96ac5e6a31bd@codeaurora.org>
References: <1485969413-23577-1-git-send-email-tbaicar@codeaurora.org>
 <1485969413-23577-9-git-send-email-tbaicar@codeaurora.org>
 <20170215105234.4921db1f@gandalf.local.home>
 <e50b7673-a441-3a6b-cf75-c267881c1a92@codeaurora.org>
 <20170215120342.48eff95d@gandalf.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
In-Reply-To: <20170215120342.48eff95d@gandalf.local.home>
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
Cc: linux-efi@vger.kernel.org, kvm@vger.kernel.org, matt@codeblueprint.co.uk, catalin.marinas@arm.com, will.deacon@arm.com, robert.moore@intel.com, paul.gortmaker@windriver.com, lv.zheng@intel.com, kvmarm@lists.cs.columbia.edu, fu.wei@linaro.org, zjzhang@codeaurora.org, linux@armlinux.org.uk, linux-acpi@vger.kernel.org, eun.taik.lee@samsung.com, shijie.huang@arm.com, labbott@redhat.com, lenb@kernel.org, harba@codeaurora.org, john.garry@huawei.com, marc.zyngier@arm.com, punit.agrawal@arm.com, nkaje@codeaurora.org, sandeepa.s.prabhu@gmail.com, linux-arm-kernel@lists.infradead.org, devel@acpica.org, rjw@rjwysocki.net, rruigrok@codeaurora.org, linux-kernel@vger.kernel.org, astone@redhat.com, hanjun.guo@linaro.org, pbonzini@redhat.com, akpm@linux-foundation.org, bristot@redhat.com, shiju.jose@huawei.com
List-Id: linux-efi@vger.kernel.org

On 2/15/2017 10:03 AM, Steven Rostedt wrote:
> On Wed, 15 Feb 2017 09:54:09 -0700
> "Baicar, Tyler" <tbaicar@codeaurora.org> wrote:
> \
>> In v9 I currently have this and the ARM trace event from this series
>> both wrapped in an
>> ifdef verifying that CONFIG_RAS is enabled. This resolves the kbuild
>> failures and
>> will have this code compiled out when that config isn't enabled. Do you
>> think I
>> should use the ifdef or use these *_enabled() functions?
>>
> I believe you need both. The *_enabled() functions wont prevent build
> errors. But since tracing is seldom enabled (usually only when you want
> to see what's happening), the *_enabled() functions optimize the code
> to not perform tasks that are only needed when tracing is enabled. When
> I say "enabled" I mean actively tracing, as supposed to being just
> enabled in the kernel.
>
> -- Steve
Got it, I will add both!

Thanks,
Tyler

-- 
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project.
