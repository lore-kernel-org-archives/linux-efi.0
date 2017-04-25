From: "Baicar, Tyler" <tbaicar@codeaurora.org>
Subject: Re: [PATCH V15 04/11] efi: parse ARM processor error
Date: Tue, 25 Apr 2017 10:05:31 -0600
Message-ID: <b39e05d4-fcec-ec26-5aa9-895655eb513c@codeaurora.org>
References: <1492556723-9189-1-git-send-email-tbaicar@codeaurora.org>
 <1492556723-9189-5-git-send-email-tbaicar@codeaurora.org>
 <20170421175527.fjwnqd22jz7br5yu@pd.tnic>
 <e54c9893-446f-9e77-b78b-2548d394719b@codeaurora.org>
 <20170424175240.3nvhbxzwicxnk6og@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
In-Reply-To: <20170424175240.3nvhbxzwicxnk6og@pd.tnic>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Borislav Petkov <bp@alien8.de>
Cc: linux-efi@vger.kernel.org, kvm@vger.kernel.org, matt@codeblueprint.co.uk, catalin.marinas@arm.com, will.deacon@arm.com, robert.moore@intel.com, paul.gortmaker@windriver.com, lv.zheng@intel.com, kvmarm@lists.cs.columbia.edu, fu.wei@linaro.org, rafael@kernel.org, zjzhang@codeaurora.org, linux@armlinux.org.uk, gengdongjiu@huawei.com, linux-acpi@vger.kernel.org, eun.taik.lee@samsung.com, shijie.huang@arm.com, labbott@redhat.com, lenb@kernel.org, harba@codeaurora.org, john.garry@huawei.com, marc.zyngier@arm.com, punit.agrawal@arm.com, rostedt@goodmis.org, nkaje@codeaurora.org, sandeepa.s.prabhu@gmail.com, linux-arm-kernel@lists.infradead.org, tony.luck@intel.com, rjw@rjwysocki.net, rruigrok@codeaurora.org, linux-kernel@vger.kernel.org, astone@redhat.com, hanjun.guo@linaro.org, joe@perches.com, pbonzini@redhat.com, akpm@linux-foundation.org, bristot@redhat.com, shiju.jose@huawe
List-Id: linux-efi@vger.kernel.org

On 4/24/2017 11:52 AM, Borislav Petkov wrote:
> On Fri, Apr 21, 2017 at 12:22:09PM -0600, Baicar, Tyler wrote:
>> I guess it's not really needed. It just may be useful considering there can
>> be numerous error info structures, numerous context info structures, and a
>> variable length vendor information section. I can move this print to only in
>> the length check failure cases.
> And? Why does the user care?
>
> I mean, it is good for debugging when you wanna see you're parsing the
> error info data properly but otherwise it doesn't improve the error
> reporting one bit.
I'll move this to just happen when the length check fails.
>> Because these are part of the error information structure. I wouldn't think
>> FW would populate error information structures that are different versions
>> in the same processor error, but it could be possible from the spec (at
>> least once there are different versions of the table).
> Same argument as above.
I can remove it then.
>
>> There is an error information 64 bit value in the ARM processor error
>> information structure. (UEFI spec 2.6 table 261)
> So that's IP-dependent and explained in the following tables. Any plans
> on decoding that too?
Yes, I do plan on adding further decoding for these values in the future.
>
>> Why's that? Dumping this vendor specific error information is similar to the
>> unrecognized CPER section reporting which is also meant for vendor specific
>> information https://lkml.org/lkml/2017/4/18/751
> And how do those naked bytes help the user understand the error happening?
>
> Even in your example you have:
>
> [  140.739210] {1}[Hardware Error]:   00000000: 4d415201 4d492031 453a4d45 435f4343  .RAM1 IMEM:ECC_C
> [  140.739214] {1}[Hardware Error]:   00000010: 53515f45 44525f42 00000000 00000000  E_QSB_RD........
>
> Which looks like some correctable ECC DRAM error and is actually begging
> to be decoded in a human-readable form. So let's do that completely and
> not dump partially decoded information.
That seems like something that should be done outside of these patches 
(if added to the kernel at all). The decoding for this information would 
all be vendor specific, so I'm not sure if we want to pollute the EFI 
code with vendor specific error decoding. Currently we are using the RAS 
Daemon user space tool for the decoding of this information since 
vendors can easily pick up this tool and add an extension for their 
vendor specific parsing. These prints will only happen when the firmware 
supports the vendor specific error information anyway.

Thanks,
Tyler

-- 
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project.
