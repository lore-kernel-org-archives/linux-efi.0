From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH V15 09/11] ras: acpi / apei: generate trace event for
 unrecognized CPER section
Date: Fri, 5 May 2017 19:53:33 +0200
Message-ID: <20170505175333.h7exckpq2gkggkph@pd.tnic>
References: <1492556723-9189-1-git-send-email-tbaicar@codeaurora.org>
 <1492556723-9189-10-git-send-email-tbaicar@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Content-Disposition: inline
In-Reply-To: <1492556723-9189-10-git-send-email-tbaicar@codeaurora.org>
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
Cc: linux-efi@vger.kernel.org, kvm@vger.kernel.org, matt@codeblueprint.co.uk, catalin.marinas@arm.com, will.deacon@arm.com, robert.moore@intel.com, paul.gortmaker@windriver.com, lv.zheng@intel.com, kvmarm@lists.cs.columbia.edu, fu.wei@linaro.org, rafael@kernel.org, zjzhang@codeaurora.org, linux@armlinux.org.uk, gengdongjiu@huawei.com, linux-acpi@vger.kernel.org, eun.taik.lee@samsung.com, shijie.huang@arm.com, labbott@redhat.com, lenb@kernel.org, harba@codeaurora.org, john.garry@huawei.com, marc.zyngier@arm.com, punit.agrawal@arm.com, rostedt@goodmis.org, nkaje@codeaurora.org, sandeepa.s.prabhu@gmail.com, linux-arm-kernel@lists.infradead.org, devel@acpica.org, tony.luck@intel.com, rjw@rjwysocki.net, rruigrok@codeaurora.org, linux-kernel@vger.kernel.org, astone@redhat.com, hanjun.guo@linaro.org, joe@perches.com, pbonzini@redhat.com, akpm@linux-foundation.org, bristot@redhat.com
List-Id: linux-efi@vger.kernel.org

On Tue, Apr 18, 2017 at 05:05:21PM -0600, Tyler Baicar wrote:
> UEFI spec allows for non-standard section in Common Platform Error
> Record. This is defined in section N.2.3 of UEFI version 2.5.

If the spec calls it non-standard why are we calling it "unknown
section"?

> Currently if the CPER section's type (UUID) does not match with
> any section type that the kernel knows how to parse, trace event
> is not generated for such section. And thus user is not able to know
> happening of such hardware error, including error record of
> non-standard section.

That's sentence sounds funny.

> This commit generates a trace event which contains raw error data
> for unrecognized CPER section.

Never write "This commit" or "This patch" in your commit message -
that's a given.

> 
> Signed-off-by: Tyler Baicar <tbaicar@codeaurora.org>
> CC: Jonathan (Zhixiong) Zhang <zjzhang@codeaurora.org>
> Tested-by: Shiju Jose <shiju.jose@huawei.com>
> ---
>  drivers/acpi/apei/ghes.c | 27 +++++++++++++++++++++++----
>  drivers/ras/ras.c        |  1 +
>  include/ras/ras_event.h  | 45 +++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 69 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
> index b91123f..3d9f63b 100644
> --- a/drivers/acpi/apei/ghes.c
> +++ b/drivers/acpi/apei/ghes.c
> @@ -45,11 +45,13 @@
>  #include <linux/aer.h>
>  #include <linux/nmi.h>
>  #include <linux/sched/clock.h>
> +#include <linux/uuid.h>
>  
>  #include <acpi/actbl1.h>
>  #include <acpi/ghes.h>
>  #include <acpi/apei.h>
>  #include <asm/tlbflush.h>
> +#include <ras/ras_event.h>
>  
>  #include "apei-internal.h"
>  
> @@ -461,12 +463,21 @@ static void ghes_do_proc(struct ghes *ghes,
>  {
>  	int sev, sec_sev;
>  	struct acpi_hest_generic_data *gdata;
> +	uuid_le sec_type;
> +	uuid_le *fru_id = &NULL_UUID_LE;
> +	char *fru_text = "";
>  
>  	sev = ghes_severity(estatus->error_severity);
>  	apei_estatus_for_each_section(estatus, gdata) {
>  		sec_sev = ghes_severity(gdata->error_severity);
> -		if (!uuid_le_cmp(*(uuid_le *)gdata->section_type,
> -				 CPER_SEC_PLATFORM_MEM)) {
> +		sec_type = *(uuid_le *)gdata->section_type;
> +
> +		if (gdata->validation_bits & CPER_SEC_VALID_FRU_ID)
> +			fru_id = (uuid_le *)gdata->fru_id;
> +		if (gdata->validation_bits & CPER_SEC_VALID_FRU_TEXT)
> +			fru_text = gdata->fru_text;
> +
> +		if (!uuid_le_cmp(sec_type, CPER_SEC_PLATFORM_MEM)) {
>  			struct cper_sec_mem_err *mem_err;
>  			mem_err = acpi_hest_get_payload(gdata);
>  			ghes_edac_report_mem_error(ghes, sev, mem_err);
> @@ -475,8 +486,7 @@ static void ghes_do_proc(struct ghes *ghes,
>  			ghes_handle_memory_failure(gdata, sev);
>  		}
>  #ifdef CONFIG_ACPI_APEI_PCIEAER
> -		else if (!uuid_le_cmp(*(uuid_le *)gdata->section_type,
> -				      CPER_SEC_PCIE)) {
> +		else if (!uuid_le_cmp(sec_type, CPER_SEC_PCIE)) {
>  			struct cper_sec_pcie *pcie_err;
>  			pcie_err = acpi_hest_get_payload(gdata);
>  			if (sev == GHES_SEV_RECOVERABLE &&
> @@ -507,6 +517,15 @@ static void ghes_do_proc(struct ghes *ghes,
>  
>  		}
>  #endif
> +#ifdef CONFIG_RAS
> +		else if (trace_unknown_sec_event_enabled()) {
> +			void *unknown_err = acpi_hest_get_payload(gdata);
> +
> +			trace_unknown_sec_event(&sec_type,
> +					fru_id, fru_text, sec_sev,
> +					unknown_err, gdata->error_data_length);
> +		}
> +#endif

Put that in a function in ras.c along with a prototype for
include/linux/ras.h for the !CONFIG_RAS case so that you can save
yourself the ifdeffery in an already not really easy to read function.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
