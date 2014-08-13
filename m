From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH 1/1] arch/x86: Add better error logging to efi main
Date: Wed, 13 Aug 2014 18:56:11 +0100
Message-ID: <20140813175611.GU15082@console-pimps.org>
References: <1404951161-2677-1-git-send-email-ulf@winkelvos.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1404951161-2677-1-git-send-email-ulf-rS3t9PEbhQ0OIzVOb1FTxg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ulf-rS3t9PEbhQ0OIzVOb1FTxg@public.gmane.org
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Darren Hart <dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Josh Boyer <jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, 10 Jul, at 02:12:41AM, ulf-rS3t9PEbhQ0OIzVOb1FTxg@public.gmane.org wrote:
> @@ -1376,7 +1376,10 @@ struct boot_params *efi_main(struct efi_config *c,
> 
> 	setup_graphics(boot_params);
> 
> -	setup_efi_pci(boot_params);
> +	status = setup_efi_pci(boot_params);
> +	if (status != EFI_SUCCESS) {
> +		efi_printk(sys_table, "setup_efi_pci() failed!\n");
> +	}
 
Actually, it turns out that a lot of people are seeing this error
message in what would be an otherwise quiet boot,

  https://bugzilla.kernel.org/show_bug.cgi?id=81891

Maybe we should distinguish between EFI_PCI_IO_PROTOCOL_GUID not being
found and all other errors, i.e. memory allocation failure. We obviously
do want to know if we failed to allocate memory, but we're less bothered
if we've no PCI devices.

Something like below? Folks on Cc, could you apply this snippet and see
whether you're still seeing the error message?

---

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index f4bdab1dbf66..37743459d089 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -534,8 +534,15 @@ static efi_status_t setup_efi_pci(struct boot_params *params)
 					NULL, &size, pci_handle);
 	}
 
-	if (status != EFI_SUCCESS)
+	if (status != EFI_SUCCESS) {
+		/*
+		 * We must have encountered a non-fatal error condition,
+		 * such as being unable to locate pci_proto. Return, but
+		 * don't report an error.
+		 */
+		status = EFI_SUCCESS;
 		goto free_handle;
+	}
 
 	if (efi_early->is64)
 		status = setup_efi_pci64(params, pci_handle, size);

-- 
Matt Fleming, Intel Open Source Technology Center
