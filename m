From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH V13 05/10] acpi: apei: handle SEA notification type for
 ARMv8
Date: Thu, 23 Mar 2017 17:55:33 +0000
Message-ID: <20170323175533.GB32309@e104818-lin.cambridge.arm.com>
References: <1490136425-4324-1-git-send-email-tbaicar@codeaurora.org>
 <1490136425-4324-6-git-send-email-tbaicar@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Content-Disposition: inline
In-Reply-To: <1490136425-4324-6-git-send-email-tbaicar@codeaurora.org>
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

On Tue, Mar 21, 2017 at 04:47:00PM -0600, Tyler Baicar wrote:
> ARM APEI extension proposal added SEA (Synchronous External Abort)
> notification type for ARMv8.
> Add a new GHES error source handling function for SEA. If an error
> source's notification type is SEA, then this function can be registered
> into the SEA exception handler. That way GHES will parse and report
> SEA exceptions when they occur.
> An SEA can interrupt code that had interrupts masked and is treated as
> an NMI. To aid this the page of address space for mapping APEI buffers
> while in_nmi() is always reserved, and ghes_ioremap_pfn_nmi() is
> changed to use the helper methods to find the prot_t to map with in
> the same way as ghes_ioremap_pfn_irq().
> 
> Signed-off-by: Tyler Baicar <tbaicar@codeaurora.org>
> CC: Jonathan (Zhixiong) Zhang <zjzhang@codeaurora.org>
> Reviewed-by: James Morse <james.morse@arm.com>
> ---
>  arch/arm64/Kconfig        |  2 ++
>  arch/arm64/mm/fault.c     | 13 +++++++++
>  drivers/acpi/apei/Kconfig | 15 ++++++++++
>  drivers/acpi/apei/ghes.c  | 70 +++++++++++++++++++++++++++++++++++++++++++----
>  include/acpi/ghes.h       |  7 +++++
>  5 files changed, 101 insertions(+), 6 deletions(-)

For the arch/arm64 part in here:

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
