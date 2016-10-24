From: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Subject: Re: [PATCH V4 02/10] ras: acpi/apei: cper: generic error data entry
 v3 per ACPI 6.1
Date: Mon, 24 Oct 2016 10:50:46 +0100
Message-ID: <da257bb4-48f3-b187-1d43-c68669427cef@arm.com>
References: <1477071013-29563-1-git-send-email-tbaicar@codeaurora.org>
 <1477071013-29563-3-git-send-email-tbaicar@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1477071013-29563-3-git-send-email-tbaicar@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Tyler Baicar <tbaicar@codeaurora.org>, marc.zyngier@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, rjw@rjwysocki.net, lenb@kernel.org, matt@codeblueprint.co.uk, robert.moore@intel.com, lv.zheng@intel.com, nkaje@codeaurora.org, zjzhang@codeaurora.org, mark.rutland@arm.com, james.morse@arm.com, akpm@linux-foundation.org, eun.taik.lee@samsung.com, sandeepa.s.prabhu@gmail.com, shijie.huang@arm.com, rruigrok@codeaurora.org, paul.gortmaker@windriver.com, tomasz.nowicki@linaro.org, fu.wei@linaro.org, rostedt@goodmis.org, bristot@redhat.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, linux-efi@vger.kernel.org, punit.
List-Id: linux-efi@vger.kernel.org

On 21/10/16 18:30, Tyler Baicar wrote:
> Currently when a RAS error is reported it is not timestamped.
> The ACPI 6.1 spec adds the timestamp field to the generic error
> data entry v3 structure. The timestamp of when the firmware
> generated the error is now being reported.
>
> Signed-off-by: Jonathan (Zhixiong) Zhang <zjzhang@codeaurora.org>
> Signed-off-by: Richard Ruigrok <rruigrok@codeaurora.org>
> Signed-off-by: Tyler Baicar <tbaicar@codeaurora.org>
> Signed-off-by: Naveen Kaje <nkaje@codeaurora.org>
> ---
>  drivers/acpi/apei/ghes.c    | 14 +++++++---
>  drivers/firmware/efi/cper.c | 67 +++++++++++++++++++++++++++++++++++++--------
>  include/acpi/ghes.h         | 10 +++++++
>  include/linux/cper.h        | 12 ++++++++
>  4 files changed, 88 insertions(+), 15 deletions(-)
>
> diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
> index 7d020b0..7610f08 100644
> --- a/drivers/acpi/apei/ghes.c
> +++ b/drivers/acpi/apei/ghes.c
> @@ -419,7 +419,8 @@ static void ghes_handle_memory_failure(struct acpi_hest_generic_data *gdata, int
>  	int flags = -1;
>  	int sec_sev = ghes_severity(gdata->error_severity);
>  	struct cper_sec_mem_err *mem_err;
> -	mem_err = (struct cper_sec_mem_err *)(gdata + 1);
> +
> +	mem_err = acpi_hest_generic_data_payload(gdata);
>
>  	if (!(mem_err->validation_bits & CPER_MEM_VALID_PA))
>  		return;
> @@ -449,14 +450,18 @@ static void ghes_do_proc(struct ghes *ghes,
>  {
>  	int sev, sec_sev;
>  	struct acpi_hest_generic_data *gdata;
> +	uuid_le sec_type;
>
>  	sev = ghes_severity(estatus->error_severity);
>  	apei_estatus_for_each_section(estatus, gdata) {
>  		sec_sev = ghes_severity(gdata->error_severity);
> -		if (!uuid_le_cmp(*(uuid_le *)gdata->section_type,
> +		sec_type = *(uuid_le *)gdata->section_type;
> +
> +		if (!uuid_le_cmp(sec_type,
>  				 CPER_SEC_PLATFORM_MEM)) {
>  			struct cper_sec_mem_err *mem_err;
> -			mem_err = (struct cper_sec_mem_err *)(gdata+1);
> +
> +			mem_err = acpi_hest_generic_data_payload(gdata);
>  			ghes_edac_report_mem_error(ghes, sev, mem_err);
>
>  			arch_apei_report_mem_error(sev, mem_err);
> @@ -466,7 +471,8 @@ static void ghes_do_proc(struct ghes *ghes,
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
> index d425374..af7e1e9 100644
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
> +	if (acpi_hest_generic_data_version(gdata))
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
> @@ -438,6 +471,7 @@ void cper_estatus_print(const char *pfx,
>  			const struct acpi_hest_generic_status *estatus)
>  {
>  	struct acpi_hest_generic_data *gdata;
> +	struct acpi_hest_generic_data_v300 *gdata_v3 = NULL;
>  	unsigned int data_len, gedata_len;
>  	int sec_no = 0;
>  	char newpfx[64];
> @@ -451,12 +485,22 @@ void cper_estatus_print(const char *pfx,
>  	printk("%s""event severity: %s\n", pfx, cper_severity_str(severity));
>  	data_len = estatus->data_length;
>  	gdata = (struct acpi_hest_generic_data *)(estatus + 1);
> +	if (acpi_hest_generic_data_version(gdata))
> +		gdata_v3 = (struct acpi_hest_generic_data_v300 *)gdata;

I think the acpi_hest_generic_data_version() doesn't check if the version is
V3 or higher ?

> +
>  	snprintf(newpfx, sizeof(newpfx), "%s%s", pfx, INDENT_SP);
> +
>  	while (data_len >= sizeof(*gdata)) {
>  		gedata_len = gdata->error_data_length;
>  		cper_estatus_print_section(newpfx, gdata, sec_no);
> -		data_len -= gedata_len + sizeof(*gdata);
> -		gdata = (void *)(gdata + 1) + gedata_len;
> +		if(gdata_v3) {
> +			data_len -= gedata_len + sizeof(*gdata_v3);
> +			gdata_v3 = (void *)(gdata_v3 + 1) + gedata_len;
> +			gdata = (struct acpi_hest_generic_data *)gdata_v3;
> +		} else {
> +			data_len -= gedata_len + sizeof(*gdata);
> +			gdata = (void *)(gdata + 1) + gedata_len;
> +		}

Could we not use the helpers we define below to unify the code here and avoid the
switch ?



>  		sec_no++;
>  	}
>  }
> @@ -486,12 +530,13 @@ int cper_estatus_check(const struct acpi_hest_generic_status *estatus)
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

Rest looks good

Cheers
Suzuki
