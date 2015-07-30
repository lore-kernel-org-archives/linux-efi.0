From: Matt Fleming <matt.fleming@intel.com>
Subject: Re: [RFC PATCH 08/16] x86/efi: Carrying swsusp key by setup data
Date: Thu, 30 Jul 2015 17:30:09 +0100
Message-ID: <1438273809.11322.21.camel@intel.com>
References: <1437056730-15247-1-git-send-email-jlee@suse.com>
	 <1437056730-15247-9-git-send-email-jlee@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1437056730-15247-9-git-send-email-jlee@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, linux-pm@vger.kernel.org, "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>, Matthew Garrett <matthew.garrett@nebula.com>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Josh Boyer <jwboyer@redhat.com>, Vojtech Pavlik <vojtech@suse.cz>, Jiri Kosina <jkosina@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>, "Lee, Chun-Yi" <jlee@suse.com>
List-Id: linux-efi@vger.kernel.org

On Thu, 2015-07-16 at 22:25 +0800, Lee, Chun-Yi wrote:
> For forwarding swsusp key from EFI stub to boot kernel, this patch
> allocates setup data for carrying swsusp key, size and the status
> of efi operating.
> 
> Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
> ---
>  arch/x86/boot/compressed/eboot.c      | 29 +++++++++++++++++++++++++----
>  arch/x86/include/uapi/asm/bootparam.h |  1 +
>  2 files changed, 26 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
> index 97b356f..5e1476e 100644
> --- a/arch/x86/boot/compressed/eboot.c
> +++ b/arch/x86/boot/compressed/eboot.c
> @@ -1392,19 +1392,23 @@ free_mem_map:
>  
>  static void setup_swsusp_keys(struct boot_params *params)
>  {
> -	unsigned long key_size, attributes;
> +	struct setup_data *setup_data, *swsusp_setup_data;
>  	struct swsusp_keys *swsusp_keys;
> +	int size = 0;
> +	unsigned long key_size, attributes;
>  	efi_status_t status;

Why the local variable shuffling? It'd be better to leave key_size and
attributes alone.

Also, 'size' doesn't look like it should be int. If you're passing it to
allocate_pool it really wants to be 'unsigned long'.

>  	/* Allocate setup_data to carry keys */
> +	size = sizeof(struct setup_data) + sizeof(struct swsusp_keys);
>  	status = efi_call_early(allocate_pool, EFI_LOADER_DATA,
> -				sizeof(struct swsusp_keys), &swsusp_keys);
> +				size, &swsusp_setup_data);
>  	if (status != EFI_SUCCESS) {
>  		efi_printk(sys_table, "Failed to alloc mem for swsusp_keys\n");
>  		return;
>  	}
>  
> -	memset(swsusp_keys, 0, sizeof(struct swsusp_keys));
> +	memset(swsusp_setup_data, 0, size);
> +	swsusp_keys = (struct swsusp_keys *)swsusp_setup_data->data;
>  
>  	status = efi_call_early(get_variable, SWSUSP_KEY, &EFI_SWSUSP_GUID,
>  				&attributes, &key_size, swsusp_keys->swsusp_key);
> @@ -1413,7 +1417,9 @@ static void setup_swsusp_keys(struct boot_params *params)
>  		memset(swsusp_keys->swsusp_key, 0, SWSUSP_DIGEST_SIZE);
>  		status = efi_call_early(set_variable, SWSUSP_KEY,
>  					&EFI_SWSUSP_GUID, attributes, 0, NULL);
> -		if (status == EFI_SUCCESS) {
> +		if (status)
> +			goto clean_fail;

Please use the EFI status codes explicitly.
