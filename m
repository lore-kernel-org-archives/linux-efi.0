From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH V13 04/10] arm64: exception: handle Synchronous External
 Abort
Date: Thu, 23 Mar 2017 17:02:06 +0000
Message-ID: <20170323170206.GA32309@e104818-lin.cambridge.arm.com>
References: <1490136425-4324-1-git-send-email-tbaicar@codeaurora.org>
 <1490136425-4324-5-git-send-email-tbaicar@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Content-Disposition: inline
In-Reply-To: <1490136425-4324-5-git-send-email-tbaicar@codeaurora.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Tyler Baicar <tbaicar@codeaurora.org>
Cc: linux-efi@vger.kernel.org, kvm@vger.kernel.org, matt@codeblueprint.co.uk, will.deacon@arm.com, robert.moore@intel.com, paul.gortmaker@windriver.com, lv.zheng@intel.com, kvmarm@lists.cs.columbia.edu, fu.wei@linaro.org, zjzhang@codeaurora.org, linux@armlinux.org.uk, linux-acpi@vger.kernel.org, eun.taik.lee@samsung.com, shijie.huang@arm.com, labbott@redhat.com, lenb@kernel.org, harba@codeaurora.org, john.garry@huawei.com, marc.zyngier@arm.com, punit.agrawal@arm.com, rostedt@goodmis.org, nkaje@codeaurora.org, sandeepa.s.prabhu@gmail.com, linux-arm-kernel@lists.infradead.org, devel@acpica.org, rjw@rjwysocki.net, rruigrok@codeaurora.org, linux-kernel@vger.kernel.org, astone@redhat.com, hanjun.guo@linaro.org, joe@perches.com, pbonzini@redhat.com, akpm@linux-foundation.org, bristot@redhat.com, shiju.jose@huawei.com
List-Id: linux-efi@vger.kernel.org

On Tue, Mar 21, 2017 at 04:46:59PM -0600, Tyler Baicar wrote:
> SEA exceptions are often caused by an uncorrected hardware
> error, and are handled when data abort and instruction abort
> exception classes have specific values for their Fault Status
> Code.
> When SEA occurs, before killing the process, report the error
> in the kernel logs.
> Update fault_info[] with specific SEA faults so that the
> new SEA handler is used.
> 
> Signed-off-by: Tyler Baicar <tbaicar@codeaurora.org>
> CC: Jonathan (Zhixiong) Zhang <zjzhang@codeaurora.org>
> Reviewed-by: James Morse <james.morse@arm.com>
> ---
>  arch/arm64/include/asm/esr.h |  1 +
>  arch/arm64/mm/fault.c        | 43 +++++++++++++++++++++++++++++++++----------

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
