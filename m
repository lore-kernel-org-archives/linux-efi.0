From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH] efi: Handle memory error structures produced based on
 old versions of standard
Date: Tue, 30 Jun 2015 13:22:44 +0100
Message-ID: <20150630122244.GJ28334@codeblueprint.co.uk>
References: <20150623170534.GA21341@agluck-desk.sc.intel.com>
 <558AF115.8020909@codeaurora.org>
 <20150628142909.GA28334@codeblueprint.co.uk>
 <20150629182106.GA25924@agluck-desk.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150629182106.GA25924-E6Nu+q68HHTI/KE9syI0vLvm/XP+8Wra@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Luck, Tony" <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Zhang, Jonathan Zhixiong" <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, harba-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, linaro-acpi-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Mon, 29 Jun, at 11:21:07AM, Luck, Tony wrote:
> The memory error record structure includes as its first field a
> bitmask of which subsequent fields are valid. The allows new fields
> to be added to the structure while keeping compatibility with older
> software that parses these records. This mechanism was used between
> versions 2.2 and 2.3 to add four new fields, growing the size of the
> structure from 73 bytes to 80. But Linux just added all the new
> fields so this test:
> 	if (gdata->error_data_length >= sizeof(*mem_err))
> 		cper_print_mem(newpfx, mem_err);
> 	else
> 		goto err_section_too_small;
> now make Linux complain about old format records being too short.
> 
> Add a definition for the old format of the structure and use that
> for the minimum size check. Pass the actual size to cper_print_mem()
> so it can sanity check the validation_bits field to ensure that if
> a BIOS using the old format sets bits as if it were new, we won't
> access fields beyond the end of the structure.
> 
> Signed-off-by: Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/firmware/efi/cper.c | 13 ++++++++++---
>  include/linux/cper.h        | 22 +++++++++++++++++++++-
>  2 files changed, 31 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/firmware/efi/cper.c b/drivers/firmware/efi/cper.c
> index 4fd9961d552e..b2012004a8ab 100644
> --- a/drivers/firmware/efi/cper.c
> +++ b/drivers/firmware/efi/cper.c
> @@ -305,10 +305,15 @@ const char *cper_mem_err_unpack(struct trace_seq *p,
>  	return ret;
>  }
>  
> -static void cper_print_mem(const char *pfx, const struct cper_sec_mem_err *mem)
> +static void cper_print_mem(const char *pfx, const struct cper_sec_mem_err *mem,
> +	int len)
>  {
>  	struct cper_mem_err_compact cmem;
>  
> +	/* Don't trust UEFI 2.1/2.2 structure with bad validation bits */
> +	if (len == sizeof(struct cper_sec_mem_err_old) &&
> +	    (mem->validation_bits & ~(CPER_MEM_VALID_RANK_NUMBER - 1)))
> +		return;

I would have thought that we'd want to print an error message here
instead of silently returning?

Otherwise looks good.

-- 
Matt Fleming, Intel Open Source Technology Center
