From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH v7 09/12] efi: passing kexec necessary efi data via
 setup_data
Date: Sat, 21 Dec 2013 14:53:48 +0000
Message-ID: <20131221145348.GC29501@console-pimps.org>
References: <1387533742-18018-1-git-send-email-dyoung@redhat.com>
 <1387533742-18018-10-git-send-email-dyoung@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1387533742-18018-10-git-send-email-dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, horms-/R6kz+dDXgpPR4JQBCEnsQ@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org, toshi.kani-VXdhtT5mjnY@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Fri, 20 Dec, at 06:02:19PM, Dave Young wrote:
> Add a new setup_data type SETUP_EFI for kexec use.
> Passing the saved fw_vendor, runtime, config tables and efi runtime mappings.
> 
> When entering virtual mode, directly mapping the efi runtime ragions which
> we passed in previously. And skip the step to call SetVirtualAddressMap.
> 
> Specially for HP z420 workstation we need save the smbios physical address.
> The kernel boot sequence proceeds in the following order.  Step 2
> requires efi.smbios to be the physical address.  However, I found that on
> HP z420 EFI system table has a virtual address of SMBIOS in step 1.  Hence,
> we need set it back to the physical address with the smbios in
> efi_setup_data.  (When it is still the physical address, it simply sets
> the same value.)
> 
> 1. efi_init() - Set efi.smbios from EFI system table
> 2. dmi_scan_machine() - Temporary map efi.smbios to access SMBIOS table
> 3. efi_enter_virtual_mode() - Map EFI ranges
> 
> Tested on ovmf+qemu, lenovo thinkpad, a dell laptop and an
> HP z420 workstation.
> 
> v2: refresh based on previous patch changes, code cleanup.
> v3: use ioremap instead of phys_to_virt for efi_setup
> v5: improve some code structure per comments from Matt
>     Boris: improve code structure, spell fix, etc.
>     Improve changelog from Toshi.
>     change the variable efi_setup to the physical address of efi setup_data
>     instead of the ioremapped virt address
> v6: Boris: Documentation fixes
>            move parse_efi_setup to efi_$(BITS).c
>            simplify parse_efi_setup logic
>     Matt: check return value of efi_reuse_config
> v7: cleanup efi_map_regions and efi_map_regions_fixed
>     remove useless return at the end of efi_enter_virtual_mode
> 
> Signed-off-by: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  arch/x86/include/asm/efi.h            |  13 +++
>  arch/x86/include/uapi/asm/bootparam.h |   1 +
>  arch/x86/kernel/setup.c               |   3 +
>  arch/x86/platform/efi/efi.c           | 159 ++++++++++++++++++++++++++++------
>  arch/x86/platform/efi/efi_32.c        |   1 +
>  arch/x86/platform/efi/efi_64.c        |   6 ++
>  6 files changed, 158 insertions(+), 25 deletions(-)

[...]

>  		efi_systab.hdr = systab64->hdr;
> -		efi_systab.fw_vendor = systab64->fw_vendor;
> -		tmp |= systab64->fw_vendor;
> +
> +		efi_systab.fw_vendor = data ? (unsigned long)data->fw_vendor :
> +					      systab64->fw_vendor;
> +		tmp |= efi_systab.fw_vendor;

[... snip ...]

> @@ -519,15 +530,20 @@ static int __init efi_systab_init(void *phys)
>  		tmp |= systab64->stderr_handle;
>  		efi_systab.stderr = systab64->stderr;
>  		tmp |= systab64->stderr;
> -		efi_systab.runtime = (void *)(unsigned long)systab64->runtime;
> -		tmp |= systab64->runtime;
> +		efi_systab.runtime = data ?
> +				     (void *)(unsigned long)data->runtime :
> +				     (void *)(unsigned long)systab64->runtime;
> +		tmp |= (unsigned long)efi_systab.runtime;
>  		efi_systab.boottime = (void *)(unsigned long)systab64->boottime;
>  		tmp |= systab64->boottime;
>  		efi_systab.nr_tables = systab64->nr_tables;
> -		efi_systab.tables = systab64->tables;
> -		tmp |= systab64->tables;
> +		efi_systab.tables = data ? (unsigned long)data->tables :
> +					   systab64->tables;
> +		tmp |= efi_systab.tables;
>  
>  		early_memunmap(systab64, sizeof(*systab64));
> +		if (data)
> +			early_memunmap(data, sizeof(*data));
>  #ifdef CONFIG_X86_32
>  		if (tmp >> 32) {
>  			pr_err("EFI data located above 4GB, disabling EFI.\n");

This isn't correct, and means we now won't trigger this pr_err() if
booting a CONFIG_X86_32 kernel with EFI_64BIT and where the ->fw_vendor,
->runtime or ->tables pointer is above 4GB - you've mixed up systab and
systab64. I've fixed this up like so when applying this patch,

---

@@ -494,18 +495,27 @@ static int __init efi_systab_init(void *phys)
 {
 	if (efi_enabled(EFI_64BIT)) {
 		efi_system_table_64_t *systab64;
+		struct efi_setup_data *data = NULL;
 		u64 tmp = 0;
 
+		if (efi_setup) {
+			data = early_memremap(efi_setup, sizeof(*data));
+			if (!data)
+				return -ENOMEM;
+		}
 		systab64 = early_ioremap((unsigned long)phys,
 					 sizeof(*systab64));
 		if (systab64 == NULL) {
 			pr_err("Couldn't map the system table!\n");
+			if (data)
+				early_iounmap(data, sizeof(*data));
 			return -ENOMEM;
 		}
 
 		efi_systab.hdr = systab64->hdr;
-		efi_systab.fw_vendor = systab64->fw_vendor;
-		tmp |= systab64->fw_vendor;
+		efi_systab.fw_vendor = data ? (unsigned long)data->fw_vendor :
+					      systab64->fw_vendor;
+		tmp |= data ? data->fw_vendor : systab64->fw_vendor;
 		efi_systab.fw_revision = systab64->fw_revision;
 		efi_systab.con_in_handle = systab64->con_in_handle;
 		tmp |= systab64->con_in_handle;
@@ -519,15 +529,20 @@ static int __init efi_systab_init(void *phys)
 		tmp |= systab64->stderr_handle;
 		efi_systab.stderr = systab64->stderr;
 		tmp |= systab64->stderr;
-		efi_systab.runtime = (void *)(unsigned long)systab64->runtime;
-		tmp |= systab64->runtime;
+		efi_systab.runtime = data ?
+				     (void *)(unsigned long)data->runtime :
+				     (void *)(unsigned long)systab64->runtime;
+		tmp |= data ? data->runtime : systab64->runtime;
 		efi_systab.boottime = (void *)(unsigned long)systab64->boottime;
 		tmp |= systab64->boottime;
 		efi_systab.nr_tables = systab64->nr_tables;
-		efi_systab.tables = systab64->tables;
-		tmp |= systab64->tables;
+		efi_systab.tables = data ? (unsigned long)data->tables :
+					   systab64->tables;
+		tmp |= data ? data->tables : systab64->tables;
 
 		early_iounmap(systab64, sizeof(*systab64));
+		if (data)
+			early_iounmap(data, sizeof(*data));
 #ifdef CONFIG_X86_32
 		if (tmp >> 32) {
 			pr_err("EFI data located above 4GB, disabling EFI.\n");

-- 
Matt Fleming, Intel Open Source Technology Center
