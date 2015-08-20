From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH v2 05/16] x86/efi: Get entropy through EFI random number
 generator protocol
Date: Thu, 20 Aug 2015 21:26:20 +0100
Message-ID: <20150820202620.GF2567@codeblueprint.co.uk>
References: <1439273796-25359-1-git-send-email-jlee@suse.com>
 <1439273796-25359-6-git-send-email-jlee@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1439273796-25359-6-git-send-email-jlee-IBi9RG/b67k@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Lee, Chun-Yi" <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, Len Brown <len.brown-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>, Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vojtech Pavlik <vojtech-AlSwsSmVLrQ@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Lee, Chun-Yi" <jlee-IBi9RG/b67k@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, 11 Aug, at 02:16:25PM, Lee, Chun-Yi wrote:
> +
> +static unsigned long efi_get_rng64(efi_system_table_t *sys_table,
> +				   void **rng_handle)
> +{
> +	const struct efi_config *efi_early = __efi_early();
> +	efi_rng_protocol_64 *rng = NULL;
> +	efi_guid_t rng_proto = EFI_RNG_PROTOCOL_GUID;
> +	u64 *handles = (u64 *)(unsigned long)rng_handle;
> +	efi_status_t status;
> +	unsigned long rng_number;
> +
> +	status = efi_call_early(handle_protocol, handles[0],
> +				&rng_proto, (void **)&rng);
> +	if (status != EFI_SUCCESS)
> +		efi_printk(sys_table, "Failed to get EFI_RNG_PROTOCOL handles\n");
> +
> +	if (status == EFI_SUCCESS && rng) {
> +		status = efi_early->call((unsigned long)rng->get_rng, rng, NULL,
> +					sizeof(rng_number), &rng_number);

Actually, one thing just occurred to me - you're not passing an
RNGAlgorithm value and are relying upon the firmware's default
implementation.

I don't think that's a safe bet, the default could be anything and
might vary across implementations.

Can we do a little better here and pick a "preferred" algorithm
instead of the default?

-- 
Matt Fleming, Intel Open Source Technology Center
