From: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH 4/6] efi: Get the secure boot status [ver #2]
Date: Wed, 23 Nov 2016 10:47:58 +0000
Message-ID: <20161123104757.GE24624@leverpostej>
References: <147986054870.13790.8640536414645705863.stgit@warthog.procyon.org.uk>
 <147986057768.13790.3027173260868896792.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <147986057768.13790.3027173260868896792.stgit-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wed, Nov 23, 2016 at 12:22:57AM +0000, David Howells wrote:
> @@ -1158,6 +1158,8 @@ struct boot_params *efi_main(struct efi_config *c,
>  	else
>  		setup_boot_services32(efi_early);
>  
> +	boot_params->secure_boot = (efi_get_secureboot(sys_table) == 1);

In the arm stub's efi_entry(), we fail-safe, and assume secure boot for any
non-zero status (including errors). e.g. 

	secure_boot = efi_get_secureboot(sys_table);
	if (secure_boot > 0)
		pr_efi(sys_table, "UEFI Secure Boot is enabled.\n");

	if (secure_boot < 0) {
		pr_efi_err(sys_table,
			"could not determine UEFI Secure Boot status.\n");
	}

	/*
	 * Unauthenticated device tree data is a security hazard, so
	 * ignore 'dtb=' unless UEFI Secure Boot is disabled.
	 */
	if (secure_boot != 0 && strstr(cmdline_ptr, "dtb=")) {
		pr_efi(sys_table, "Ignoring DTB from command line.\n");

... should we not do likewise here, e.g.

	int secure_boot = efi_get_secureboot(sys_table);

	if (secure_boot > 0)
		pr_efi(sys_table, "UEFI Secure Boot is enabled.\n");
	if (secure_boot < 0)
		pr_efi_err(sys_table,
			"could not determine UEFI Secure Boot status.\n");

	/*
	 * Fail-safe in the case of an error determining the secure boot
	 * status.
	 */
	boot_params->secure_boot = (secure_boot != 0);

... ?

Thanks,
Mark.
