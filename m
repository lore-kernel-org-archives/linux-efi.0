From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH 1/1] efi: cper: Support different length of Error Section
Date: Tue, 4 Mar 2014 23:41:45 +0000
Message-ID: <20140304234145.GB17362@console-pimps.org>
References: <6366A95FCFBB78419E783DDD020ED2ECB2E9EC@APMAILMBX03.lenovo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <6366A95FCFBB78419E783DDD020ED2ECB2E9EC-Jk/oIdswkFjYfDlE21CtCN+069o89Hfh@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Adrian Huang12 <ahuang12-6jq1YtArVR3QT0dZR+AlfA@public.gmane.org>
Cc: "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tony Luck <tony.luck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

(Pulling in Tony)

On Tue, 04 Mar, at 04:10:57PM, Adrian Huang12 wrote:
> Some fields might be added to the Error Section in the newer UEFI
> spec. For example, the fields 'Reserved', 'Rank Number',
> 'Card Handle' and 'Module Handle' are added to the Memory Error
> Section started from UEFI spec 2.3. Unfortunately, there will have
> the following warning message if the memory corrected error is
> detected and the field 'revision' in struct acpi_generic_data is
> less then 0x203 (UEFI spec 2.3):
> 
> {1}[Hardware Error]: Hardware error from APEI Generic Hardware Error Source: 3
> {1}[Hardware Error]: It has been corrected by h/w and requires no further action
> {1}[Hardware Error]: event severity: corrected
> {1}[Hardware Error]:  Error 0, type: corrected
> {1}[Hardware Error]:   section_type: memory error
> [Firmware Warn]: error section length is too small
> 
> This behavior causes this corrected error cannot be displayed
> correctly. To solve the issue, this patch supports different
> length of the Error Section for different UEFI spec version.
> 
> And, this patch employs a pre-defined structure to clean up the
> duplicated codes in function cper_estatus_print_section.
> 
> With applying this patch, the memory corrected error could be
> displayed correctly after injecting the error.
> 
> Tested on v3.14-rc5 with Grantley platform and Intel RAStool.
> 
> Signed-off-by: Adrian Huang <ahuang12-6jq1YtArVR3QT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/firmware/efi/cper.c | 110 +++++++++++++++++++++++++++++++++-----------
>  1 file changed, 84 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/firmware/efi/cper.c b/drivers/firmware/efi/cper.c
> index 1491dd4..c33f1e3 100644
> --- a/drivers/firmware/efi/cper.c
> +++ b/drivers/firmware/efi/cper.c
> @@ -132,9 +132,11 @@ static const char * const cper_proc_flag_strs[] = {
>  	"corrected",
>  };
>  
> -static void cper_print_proc_generic(const char *pfx,
> -				    const struct cper_sec_proc_generic *proc)
> +static void cper_print_proc_generic(const char *pfx, const void *data)
>  {
> +	const struct cper_sec_proc_generic *proc =
> +		(struct cper_sec_proc_generic *) data;
> +
>  	if (proc->validation_bits & CPER_PROC_VALID_TYPE)
>  		printk("%s""processor_type: %d, %s\n", pfx, proc->proc_type,
>  		       proc->proc_type < ARRAY_SIZE(cper_proc_type_strs) ?
> @@ -196,8 +198,10 @@ static const char *cper_mem_err_type_strs[] = {
>  	"physical memory map-out event",
>  };
>  
> -static void cper_print_mem(const char *pfx, const struct cper_sec_mem_err *mem)
> +static void cper_print_mem(const char *pfx, const void *data)
>  {
> +	const struct cper_sec_mem_err *mem = (struct cper_sec_mem_err *) data;
> +
>  	if (mem->validation_bits & CPER_MEM_VALID_ERROR_STATUS)
>  		printk("%s""error_status: 0x%016llx\n", pfx, mem->error_status);
>  	if (mem->validation_bits & CPER_MEM_VALID_PA)
> @@ -261,9 +265,10 @@ static const char *cper_pcie_port_type_strs[] = {
>  	"root complex event collector",
>  };
>  
> -static void cper_print_pcie(const char *pfx, const struct cper_sec_pcie *pcie,
> -			    const struct acpi_generic_data *gdata)
> +static void cper_print_pcie(const char *pfx, const void *data)
>  {
> +	struct cper_sec_pcie *pcie = (struct cper_sec_pcie *) data;
> +
>  	if (pcie->validation_bits & CPER_PCIE_VALID_PORT_TYPE)
>  		printk("%s""port_type: %d, %s\n", pfx, pcie->port_type,
>  		       pcie->port_type < ARRAY_SIZE(cper_pcie_port_type_strs) ?
> @@ -297,12 +302,73 @@ static void cper_print_pcie(const char *pfx, const struct cper_sec_pcie *pcie,
>  	pfx, pcie->bridge.secondary_status, pcie->bridge.control);
>  }
>  
> +struct cper_section_length {
> +	u32 revision;
> +	u32 length;
> +};
> +
> +/* Per ACPI spec 4.0/5.0, the referred UEFI revision is 2.1. */
> +static struct cper_section_length proc_generic_section_len[] = {
> +	{0x201, sizeof(struct cper_sec_proc_generic)},
> +	{}
> +};
> +
> +/*
> + * Per ACPI spec 4.0/5.0, the referred UEFI revision is 2.1.
> + * Some fields are added to Memory Error Section in UEFI 2.3 and later,
> + * so we need to distinguish the difference.
> + */
> +static struct cper_section_length mem_section_len[] = {
> +	{0x203, sizeof(struct cper_sec_mem_err)},
> +	{0x201, offsetof(struct cper_sec_mem_err, reserved)},
> +	{}
> +};
> +
> +/* Per ACPI spec 4.0/5.0, the referred UEFI revision is 2.1. */
> +static struct cper_section_length pcie_section_len[] = {
> +	{0x201, sizeof(struct cper_sec_pcie)},
> +	{}
> +};
> +
> +struct cper_estatus_section_info {
> +	uuid_le type;
> +	char *name;
> +	struct cper_section_length *section_length;
> +	void (*print_fn)(const char *, const void *);
> +};
> +
> +static struct cper_estatus_section_info section_info[] = {
> +	{CPER_SEC_PROC_GENERIC, "general processor", proc_generic_section_len,
> +	 cper_print_proc_generic},
> +	{CPER_SEC_PLATFORM_MEM, "memory", mem_section_len, cper_print_mem},
> +	{CPER_SEC_PCIE, "PCIe", pcie_section_len, cper_print_pcie},
> +	{}
> +};
> +
> +static int cper_estatus_check_section(const struct acpi_generic_data *gdata,
> +				      struct cper_section_length *len)
> +{
> +	struct cper_section_length *sec_length;
> +
> +	for (sec_length = len; sec_length->revision; sec_length++) {
> +		/* Find the corresponding entry. */
> +		if (gdata->revision >= (u16) sec_length->revision)
> +			break;
> +	}
> +
> +	if (!sec_length || !sec_length->revision)
> +		return -EINVAL;
> +
> +	return gdata->error_data_length >= sec_length->length ? 0 : -EINVAL;
> +}
> +
>  static void cper_estatus_print_section(
>  	const char *pfx, const struct acpi_generic_data *gdata, int sec_no)
>  {
>  	uuid_le *sec_type = (uuid_le *)gdata->section_type;
>  	__u16 severity;
>  	char newpfx[64];
> +	struct cper_estatus_section_info *s_info;
>  
>  	severity = gdata->error_severity;
>  	printk("%s""Error %d, type: %s\n", pfx, sec_no,
> @@ -313,28 +379,20 @@ static void cper_estatus_print_section(
>  		printk("%s""fru_text: %.20s\n", pfx, gdata->fru_text);
>  
>  	snprintf(newpfx, sizeof(newpfx), "%s%s", pfx, INDENT_SP);
> -	if (!uuid_le_cmp(*sec_type, CPER_SEC_PROC_GENERIC)) {
> -		struct cper_sec_proc_generic *proc_err = (void *)(gdata + 1);
> -		printk("%s""section_type: general processor error\n", newpfx);
> -		if (gdata->error_data_length >= sizeof(*proc_err))
> -			cper_print_proc_generic(newpfx, proc_err);
> -		else
> -			goto err_section_too_small;
> -	} else if (!uuid_le_cmp(*sec_type, CPER_SEC_PLATFORM_MEM)) {
> -		struct cper_sec_mem_err *mem_err = (void *)(gdata + 1);
> -		printk("%s""section_type: memory error\n", newpfx);
> -		if (gdata->error_data_length >= sizeof(*mem_err))
> -			cper_print_mem(newpfx, mem_err);
> -		else
> -			goto err_section_too_small;
> -	} else if (!uuid_le_cmp(*sec_type, CPER_SEC_PCIE)) {
> -		struct cper_sec_pcie *pcie = (void *)(gdata + 1);
> -		printk("%s""section_type: PCIe error\n", newpfx);
> -		if (gdata->error_data_length >= sizeof(*pcie))
> -			cper_print_pcie(newpfx, pcie, gdata);
> -		else
> +
> +	for (s_info = section_info; s_info->print_fn; s_info++) {
> +		if (uuid_le_cmp(*sec_type, s_info->type))
> +			continue;
> +
> +		if (cper_estatus_check_section(gdata, s_info->section_length))
>  			goto err_section_too_small;
> -	} else
> +
> +		printk("%s""section_type: %s\n", newpfx, s_info->name);
> +		s_info->print_fn(newpfx, (void *) (gdata + 1));
> +		break;
> +	}
> +
> +	if (!s_info->print_fn)
>  		printk("%s""section type: unknown, %pUl\n", newpfx, sec_type);
>  
>  	return;
> -- 
> 1.8.1.2
> 
> 

-- 
Matt Fleming, Intel Open Source Technology Center
