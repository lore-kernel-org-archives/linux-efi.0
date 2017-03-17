From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH V12 05/10] acpi: apei: handle SEA notification type for
 ARMv8
Date: Fri, 17 Mar 2017 16:43:11 +0000
Message-ID: <58CC121F.5030807@arm.com>
References: <1488833103-21082-1-git-send-email-tbaicar@codeaurora.org>
 <1488833103-21082-6-git-send-email-tbaicar@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
In-Reply-To: <1488833103-21082-6-git-send-email-tbaicar@codeaurora.org>
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
Cc: linux-efi@vger.kernel.org, kvm@vger.kernel.org, matt@codeblueprint.co.uk, catalin.marinas@arm.com, will.deacon@arm.com, robert.moore@intel.com, paul.gortmaker@windriver.com, lv.zheng@intel.com, kvmarm@lists.cs.columbia.edu, fu.wei@linaro.org, zjzhang@codeaurora.org, linux@armlinux.org.uk, linux-acpi@vger.kernel.org, eun.taik.lee@samsung.com, shijie.huang@arm.com, labbott@redhat.com, lenb@kernel.org, harba@codeaurora.org, john.garry@huawei.com, marc.zyngier@arm.com, punit.agrawal@arm.com, rostedt@goodmis.org, nkaje@codeaurora.org, sandeepa.s.prabhu@gmail.com, linux-arm-kernel@lists.infradead.org, devel@acpica.org, rjw@rjwysocki.net, rruigrok@codeaurora.org, linux-kernel@vger.kernel.org, astone@redhat.com, hanjun.guo@linaro.org, joe@perches.com, pbonzini@redhat.com, akpm@linux-foundation.org, bristot@redhat.com, shiju.jose@huawei.com
List-Id: linux-efi@vger.kernel.org

Hi Tyler,

On 06/03/17 20:44, Tyler Baicar wrote:
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

> diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
> index b25e7cf..b0596ba 100644
> --- a/drivers/acpi/apei/ghes.c
> +++ b/drivers/acpi/apei/ghes.c
> @@ -1023,6 +1075,13 @@ static int ghes_probe(struct platform_device *ghes_dev)
>  		pr_warning(GHES_PFX "Generic hardware error source: %d notified via local interrupt is not supported!\n",
>  			   generic->header.source_id);
>  		goto err;
> +	case ACPI_HEST_NOTIFY_GPIO:
> +	case ACPI_HEST_NOTIFY_SEI:
> +	case ACPI_HEST_NOTIFY_GSIV:
> +		pr_warn(GHES_PFX "Generic hardware error source: %d notified via notification type %u is not supported\n",
> +			generic->header.source_id, generic->header.source_id);
> +		rc = -ENOTSUPP;
> +		goto err;
>  	default:
>  		pr_warning(FW_WARN GHES_PFX "Unknown notification type: %u for generic hardware error source: %d\n",
>  			   generic->notify.type, generic->header.source_id);


This hunk will conflict with Shiju Jose's patch[0] that adds GPIO and GSIV
support. Can we remove it?


Thanks,

James


[0] https://www.spinics.net/lists/linux-acpi/msg72654.html
