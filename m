From: "Baicar, Tyler" <tbaicar@codeaurora.org>
Subject: Re: [PATCH V12 00/10] Add UEFI 2.6 and ACPI 6.1 updates for RAS on
 ARM64
Date: Tue, 7 Mar 2017 09:37:38 -0700
Message-ID: <0908a4cc-bb6b-341b-0bde-ccb820d17385@codeaurora.org>
References: <1488833103-21082-1-git-send-email-tbaicar@codeaurora.org>
 <58BE9B6B.3020000@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
In-Reply-To: <58BE9B6B.3020000@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: James Morse <james.morse@arm.com>
Cc: linux-efi@vger.kernel.org, kvm@vger.kernel.org, matt@codeblueprint.co.uk, catalin.marinas@arm.com, will.deacon@arm.com, robert.moore@intel.com, paul.gortmaker@windriver.com, lv.zheng@intel.com, kvmarm@lists.cs.columbia.edu, fu.wei@linaro.org, zjzhang@codeaurora.org, linux@armlinux.org.uk, linux-acpi@vger.kernel.org, eun.taik.lee@samsung.com, shijie.huang@arm.com, labbott@redhat.com, lenb@kernel.org, harba@codeaurora.org, john.garry@huawei.com, marc.zyngier@arm.com, punit.agrawal@arm.com, rostedt@goodmis.org, nkaje@codeaurora.org, sandeepa.s.prabhu@gmail.com, linux-arm-kernel@lists.infradead.org, devel@acpica.org, rjw@rjwysocki.net, rruigrok@codeaurora.org, linux-kernel@vger.kernel.org, astone@redhat.com, hanjun.guo@linaro.org, joe@perches.com, pbonzini@redhat.com, akpm@linux-foundation.org, bristot@redhat.com, shiju.jose@huawei.com
List-Id: linux-efi@vger.kernel.org

On 3/7/2017 4:37 AM, James Morse wrote:
> Hi Tyler,
>
> On 06/03/17 20:44, Tyler Baicar wrote:
>> When a memory error, CPU error, PCIe error, or other type of hardware error
>> that's covered by RAS occurs, firmware should populate the shared GHES memory
>> location with the proper GHES structures to notify the OS of the error.
>> For example, platforms that implement firmware first handling may implement
>> separate GHES sources for corrected errors and uncorrected errors. If the
>> error is an uncorrectable error, then the firmware will notify the OS
>> immediately since the error needs to be handled ASAP. The OS will then be able
>> to take the appropriate action needed such as offlining a page. If the error
>> is a corrected error, then the firmware will not interrupt the OS immediately.
>> Instead, the OS will see and report the error the next time it's GHES timer
>> expires. The kernel will first parse the GHES structures and report the errors
>> through the kernel logs and then notify the user space through RAS trace
>> events. This allows user space applications such as RAS Daemon to see the
>> errors and report them however the user desires. This patchset extends the
>> kernel functionality for RAS errors based on updates in the UEFI 2.6 and
>> ACPI 6.1 specifications.
> This series doesn't apply cleanly to v4.11-rc1, what did you base it on?
>
> Please base this on a v4.11 release candidate if you want it considered for v4.12.
>
This was based on 4.10, I will base it on 4.11-rc1 for the next patch set.

Thanks,
Tyler

-- 
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project.
