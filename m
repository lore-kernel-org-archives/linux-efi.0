From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH V5 02/10] ras: acpi/apei: cper: generic error data entry
 v3 per ACPI 6.1
Date: Fri, 25 Nov 2016 18:20:16 +0000
Message-ID: <583880E0.8080705@arm.com>
References: <1479767763-27532-1-git-send-email-tbaicar@codeaurora.org>
 <1479767763-27532-3-git-send-email-tbaicar@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
In-Reply-To: <1479767763-27532-3-git-send-email-tbaicar@codeaurora.org>
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
Cc: linux-efi@vger.kernel.org, kvm@vger.kernel.org, matt@codeblueprint.co.uk, catalin.marinas@arm.com, will.deacon@arm.com, robert.moore@intel.com, paul.gortmaker@windriver.com, lv.zheng@intel.com, kvmarm@lists.cs.columbia.edu, fu.wei@linaro.org, zjzhang@codeaurora.org, linux@armlinux.org.uk, linux-acpi@vger.kernel.org, eun.taik.lee@samsung.com, shijie.huang@arm.com, lenb@kernel.org, harba@codeaurora.org, marc.zyngier@arm.com, punit.agrawal@arm.com, tomasz.nowicki@linaro.org, nkaje@codeaurora.org, rostedt@goodmis.org, sandeepa.s.prabhu@gmail.com, linux-arm-kernel@lists.infradead.org, rjw@rjwysocki.net, rruigrok@codeaurora.org, linux-kernel@vger.kernel.org, astone@redhat.com, hanjun.guo@linaro.org, pbonzini@redhat.com, akpm@linux-foundation.org, bristot@redhat.com
List-Id: linux-efi@vger.kernel.org

Hi Tyler,

On 21/11/16 22:35, Tyler Baicar wrote:
> Currently when a RAS error is reported it is not timestamped.
> The ACPI 6.1 spec adds the timestamp field to the generic error
> data entry v3 structure. The timestamp of when the firmware
> generated the error is now being reported.

> diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
> index b79abc5..9063d68 100644
> --- a/drivers/acpi/apei/ghes.c
> +++ b/drivers/acpi/apei/ghes.c
> @@ -420,7 +420,8 @@ static void ghes_handle_memory_failure(struct acpi_hest_generic_data *gdata, int
>  	int flags = -1;
>  	int sec_sev = ghes_severity(gdata->error_severity);
>  	struct cper_sec_mem_err *mem_err;
> -	mem_err = (struct cper_sec_mem_err *)(gdata + 1);
> +
> +	mem_err = acpi_hest_generic_data_payload(gdata);
>  
>  	if (!(mem_err->validation_bits & CPER_MEM_VALID_PA))
>  		return;
> @@ -450,14 +451,18 @@ static void ghes_do_proc(struct ghes *ghes,
>  {
>  	int sev, sec_sev;
>  	struct acpi_hest_generic_data *gdata;
> +	uuid_le sec_type;

ghes.c doesn't include <linux/uuid.h>, but I see it already uses uuid_le_cmp().
Worth fixing as part of this patch?


>  
>  	sev = ghes_severity(estatus->error_severity);
>  	apei_estatus_for_each_section(estatus, gdata) {
>  		sec_sev = ghes_severity(gdata->error_severity);
> -		if (!uuid_le_cmp(*(uuid_le *)gdata->section_type,
> +		sec_type = *(uuid_le *)gdata->section_type;
> +

You don't use sec_type again here, why change this?
(should it be in a later patch?)


> +		if (!uuid_le_cmp(sec_type,
>  				 CPER_SEC_PLATFORM_MEM)) {
>  			struct cper_sec_mem_err *mem_err;
> -			mem_err = (struct cper_sec_mem_err *)(gdata+1);
> +
> +			mem_err = acpi_hest_generic_data_payload(gdata);
>  			ghes_edac_report_mem_error(ghes, sev, mem_err);
>  
>  			arch_apei_report_mem_error(sev, mem_err);
> @@ -467,7 +472,8 @@ static void ghes_do_proc(struct ghes *ghes,
>  		else if (!uuid_le_cmp(*(uuid_le *)gdata->section_type,
>  				      CPER_SEC_PCIE)) {
>  			struct cper_sec_pcie *pcie_err;
> -			pcie_err = (struct cper_sec_pcie *)(gdata+1);
> +
> +			pcie_err = acpi_hest_generic_data_payload(gdata);
>  			if (sev == GHES_SEV_RECOVERABLE &&
>  			    sec_sev == GHES_SEV_RECOVERABLE &&
>  			    pcie_err->validation_bits & CPER_PCIE_VALID_DEVICE_ID &&
> diff --git a/drivers/firmware/efi/cper.c b/drivers/firmware/efi/cper.c
> index d425374..7e2439e 100644
> --- a/drivers/firmware/efi/cper.c
> +++ b/drivers/firmware/efi/cper.c
> @@ -32,6 +32,9 @@
>  #include <linux/acpi.h>
>  #include <linux/pci.h>
>  #include <linux/aer.h>
> +#include <linux/printk.h>
> +#include <linux/bcd.h>
> +#include <acpi/ghes.h>
>  
>  #define INDENT_SP	" "
>  
> @@ -386,13 +389,37 @@ static void cper_print_pcie(const char *pfx, const struct cper_sec_pcie *pcie,
>  	pfx, pcie->bridge.secondary_status, pcie->bridge.control);
>  }
>  
> +static void cper_estatus_print_section_v300(const char *pfx,
> +	const struct acpi_hest_generic_data_v300 *gdata)
> +{
> +	__u8 hour, min, sec, day, mon, year, century, *timestamp;
> +
> +	if (gdata->validation_bits & ACPI_HEST_GEN_VALID_TIMESTAMP) {
> +		timestamp = (__u8 *)&(gdata->time_stamp);
> +		sec = bcd2bin(timestamp[0]);
> +		min = bcd2bin(timestamp[1]);
> +		hour = bcd2bin(timestamp[2]);
> +		day = bcd2bin(timestamp[4]);
> +		mon = bcd2bin(timestamp[5]);
> +		year = bcd2bin(timestamp[6]);
> +		century = bcd2bin(timestamp[7]);
> +		printk("%stime: %7s %02d%02d-%02d-%02d %02d:%02d:%02d\n", pfx,
> +			0x01 & *(timestamp + 3) ? "precise" : "", century,
> +			year, mon, day, hour, min, sec);
> +	}
> +}
> +
>  static void cper_estatus_print_section(
> -	const char *pfx, const struct acpi_hest_generic_data *gdata, int sec_no)
> +	const char *pfx, struct acpi_hest_generic_data *gdata, int sec_no)
>  {
>  	uuid_le *sec_type = (uuid_le *)gdata->section_type;
>  	__u16 severity;
>  	char newpfx[64];
>  
> +	if (acpi_hest_generic_data_version(gdata) >= 3)
> +		cper_estatus_print_section_v300(pfx,
> +			(const struct acpi_hest_generic_data_v300 *)gdata);
> +
>  	severity = gdata->error_severity;
>  	printk("%s""Error %d, type: %s\n", pfx, sec_no,
>  	       cper_severity_str(severity));
> @@ -403,14 +430,18 @@ static void cper_estatus_print_section(
>  
>  	snprintf(newpfx, sizeof(newpfx), "%s%s", pfx, INDENT_SP);
>  	if (!uuid_le_cmp(*sec_type, CPER_SEC_PROC_GENERIC)) {
> -		struct cper_sec_proc_generic *proc_err = (void *)(gdata + 1);
> +		struct cper_sec_proc_generic *proc_err;
> +
> +		proc_err = acpi_hest_generic_data_payload(gdata);
>  		printk("%s""section_type: general processor error\n", newpfx);
>  		if (gdata->error_data_length >= sizeof(*proc_err))
>  			cper_print_proc_generic(newpfx, proc_err);
>  		else
>  			goto err_section_too_small;
>  	} else if (!uuid_le_cmp(*sec_type, CPER_SEC_PLATFORM_MEM)) {
> -		struct cper_sec_mem_err *mem_err = (void *)(gdata + 1);
> +		struct cper_sec_mem_err *mem_err;
> +
> +		mem_err = acpi_hest_generic_data_payload(gdata);
>  		printk("%s""section_type: memory error\n", newpfx);
>  		if (gdata->error_data_length >=
>  		    sizeof(struct cper_sec_mem_err_old))
> @@ -419,7 +450,9 @@ static void cper_estatus_print_section(
>  		else
>  			goto err_section_too_small;
>  	} else if (!uuid_le_cmp(*sec_type, CPER_SEC_PCIE)) {
> -		struct cper_sec_pcie *pcie = (void *)(gdata + 1);
> +		struct cper_sec_pcie *pcie;
> +
> +		pcie = acpi_hest_generic_data_payload(gdata);
>  		printk("%s""section_type: PCIe error\n", newpfx);
>  		if (gdata->error_data_length >= sizeof(*pcie))
>  			cper_print_pcie(newpfx, pcie, gdata);
> @@ -438,7 +471,7 @@ void cper_estatus_print(const char *pfx,
>  			const struct acpi_hest_generic_status *estatus)
>  {
>  	struct acpi_hest_generic_data *gdata;
> -	unsigned int data_len, gedata_len;
> +	unsigned int data_len;
>  	int sec_no = 0;
>  	char newpfx[64];
>  	__u16 severity;
> @@ -451,12 +484,12 @@ void cper_estatus_print(const char *pfx,
>  	printk("%s""event severity: %s\n", pfx, cper_severity_str(severity));
>  	data_len = estatus->data_length;
>  	gdata = (struct acpi_hest_generic_data *)(estatus + 1);
> +
>  	snprintf(newpfx, sizeof(newpfx), "%s%s", pfx, INDENT_SP);
> -	while (data_len >= sizeof(*gdata)) {
> -		gedata_len = gdata->error_data_length;
> +
> +	while (data_len >= acpi_hest_generic_data_size(gdata)) {
>  		cper_estatus_print_section(newpfx, gdata, sec_no);
> -		data_len -= gedata_len + sizeof(*gdata);
> -		gdata = (void *)(gdata + 1) + gedata_len;
> +		gdata = acpi_hest_generic_data_next(gdata);
>  		sec_no++;
>  	}
>  }
> @@ -486,12 +519,13 @@ int cper_estatus_check(const struct acpi_hest_generic_status *estatus)
>  		return rc;
>  	data_len = estatus->data_length;
>  	gdata = (struct acpi_hest_generic_data *)(estatus + 1);
> -	while (data_len >= sizeof(*gdata)) {
> -		gedata_len = gdata->error_data_length;
> -		if (gedata_len > data_len - sizeof(*gdata))
> +
> +	while (data_len >= acpi_hest_generic_data_size(gdata)) {
> +		gedata_len = acpi_hest_generic_data_error_length(gdata);
> +		if (gedata_len > data_len - acpi_hest_generic_data_size(gdata))
>  			return -EINVAL;
> -		data_len -= gedata_len + sizeof(*gdata);
> -		gdata = (void *)(gdata + 1) + gedata_len;
> +		data_len -= gedata_len + acpi_hest_generic_data_size(gdata);
> +		gdata = acpi_hest_generic_data_next(gdata);
>  	}
>  	if (data_len)
>  		return -EINVAL;
> diff --git a/include/acpi/ghes.h b/include/acpi/ghes.h
> index 68f088a..56b9679 100644
> --- a/include/acpi/ghes.h
> +++ b/include/acpi/ghes.h
> @@ -73,3 +73,13 @@ static inline void ghes_edac_unregister(struct ghes *ghes)
>  {
>  }
>  #endif
> +
> +#define acpi_hest_generic_data_version(gdata)			\
> +	(gdata->revision >> 8)
> +
> +static inline void *acpi_hest_generic_data_payload(struct acpi_hest_generic_data *gdata)
> +{
> +	return acpi_hest_generic_data_version(gdata) >= 3 ?
> +		(void *)(((struct acpi_hest_generic_data_v300 *)(gdata)) + 1) :
> +		gdata + 1;
> +}
> diff --git a/include/linux/cper.h b/include/linux/cper.h
> index dcacb1a..13ea41c 100644
> --- a/include/linux/cper.h
> +++ b/include/linux/cper.h
> @@ -255,6 +255,18 @@ enum {
>  
>  #define CPER_PCIE_SLOT_SHIFT			3
>  

> +#define acpi_hest_generic_data_error_length(gdata)	\
> +	(((struct acpi_hest_generic_data *)(gdata))->error_data_length)
> +#define acpi_hest_generic_data_size(gdata)		\
> +	((acpi_hest_generic_data_version(gdata) >= 3) ?	\
> +	sizeof(struct acpi_hest_generic_data_v300) :	\
> +	sizeof(struct acpi_hest_generic_data))
> +#define acpi_hest_generic_data_record_size(gdata)	\
> +	(acpi_hest_generic_data_size(gdata) +		\
> +	acpi_hest_generic_data_error_length(gdata))
> +#define acpi_hest_generic_data_next(gdata)		\
> +	((void *)(gdata) + acpi_hest_generic_data_record_size(gdata))
> +

How come these aren't in ghes.h?



Reviewed-by: James Morse <james.morse@arm.com>


Thanks,

James
