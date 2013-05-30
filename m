From: Russ Anderson <rja-sJ/iWh9BUns@public.gmane.org>
Subject: Re: [regression, bisected] x86: efi: Pass boot services variable
	info to runtime code
Date: Thu, 30 May 2013 17:17:37 -0500
Message-ID: <20130530221737.GA11105@sgi.com>
References: <20130522162747.GA20816@sgi.com> <20130523115801.GJ14575@console-pimps.org> <20130523203234.GD20913@sgi.com> <20130524074331.GL14575@console-pimps.org> <20130529210115.GC28027@sgi.com> <alpine.LRH.2.00.1305300018180.1111@twin.jikos.cz> <20130529224645.GA16582@sgi.com> <alpine.LNX.2.00.1305300048520.30576@pobox.suse.cz> <1369880172.17397.11.camel@linux-s257.site>
Reply-To: Russ Anderson <rja-sJ/iWh9BUns@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="0OAP2g/MAC+5xKAE"
Content-Transfer-Encoding: 8bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1369880172.17397.11.camel-ONCj+Eqt86TasUa73XJKwA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Cc: Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H. Peter Anvin" <hpa-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org


--0OAP2g/MAC+5xKAE
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Thu, May 30, 2013 at 10:16:12AM +0800, joeyli wrote:
> 於 四，2013-05-30 於 00:53 +0200，Jiri Kosina 提到：
> > On Wed, 29 May 2013, Russ Anderson wrote:
> > 
> > > > Yes, but this call is clearly happening way before ExitBootServices() -- 
> > > > see the surrounding code, see for example this in efi_main():
> > > > 
> > > > [ ... snip ... ]
> > > > 	setup_efi_vars(boot_params);
> > > > 
> > > > 	setup_efi_pci(boot_params);
> > > > 
> > > > 	status = efi_call_phys3(sys_table->boottime->allocate_pool,
> > > > 				EFI_LOADER_DATA, sizeof(*gdt),
> > > > 				(void **)&gdt);
> > > > 	if (status != EFI_SUCCESS) {
> > > > 		efi_printk("Failed to alloc mem for gdt structure\n");
> > > > 		goto fail;
> > > > 	}
> > > > [ ... snip ... ]
> > > 
> > > Yes.  Note the failing call is sys_table->runtime while all the
> > > other calls are sys_table->boottime and seem to work.  Not sure
> > > why the sys_table->runtime call has a problem but it may be
> > > a clue.  Could something in the runtime path not be set up???
> > 
> > That was my original idea early today as well. My understanding of the 
> > UEFI spec is admittedly limited, but afaics calling runtime method from 
> > boot environment should be a valid thing to do ... ?
> 
> QueryVariableInfo() is a runtime services, all runtime services should
> available bother on boot time and runtime:
> 
> UEFI spec 2.3.1 P.109:
>   Runtime Services
>   Functions that are available before and after any call to  
>   ExitBootServices(). These functions are described in Section 7.

That's a great idea.  This patch moves the QueryVariableInfo()
call from bootime to runtime, in efi_late_init().  The attached
patch is consistent with the UEFI spec and avoids the problem.

Thanks,
-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja-sJ/iWh9BUns@public.gmane.org

--0OAP2g/MAC+5xKAE
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="efi_move_query_call.patch"

Move query_variable_info call to runtime to avoid bios issues.

Signed-off-by: Russ Anderson <rja-sJ/iWh9BUns@public.gmane.org>

---
 arch/x86/boot/compressed/eboot.c |   49 ---------------------------------------
 arch/x86/platform/efi/efi.c      |   35 ++++++++++++---------------
 2 files changed, 16 insertions(+), 68 deletions(-)

Index: linux/arch/x86/boot/compressed/eboot.c
===================================================================
--- linux.orig/arch/x86/boot/compressed/eboot.c	2013-05-30 11:02:19.034914824 -0500
+++ linux/arch/x86/boot/compressed/eboot.c	2013-05-30 16:53:50.512636568 -0500
@@ -251,53 +251,6 @@ static void find_bits(unsigned long mask
 	*size = len;
 }
 
-static efi_status_t setup_efi_vars(struct boot_params *params)
-{
-	struct setup_data *data;
-	struct efi_var_bootdata *efidata;
-	u64 store_size, remaining_size, var_size;
-	efi_status_t status;
-
-	if (sys_table->runtime->hdr.revision < EFI_2_00_SYSTEM_TABLE_REVISION)
-		return EFI_UNSUPPORTED;
-
-	data = (struct setup_data *)(unsigned long)params->hdr.setup_data;
-
-	while (data && data->next)
-		data = (struct setup_data *)(unsigned long)data->next;
-
-	status = efi_call_phys4((void *)sys_table->runtime->query_variable_info,
-				EFI_VARIABLE_NON_VOLATILE |
-				EFI_VARIABLE_BOOTSERVICE_ACCESS |
-				EFI_VARIABLE_RUNTIME_ACCESS, &store_size,
-				&remaining_size, &var_size);
-
-	if (status != EFI_SUCCESS) { // RJA
-		efi_printk("RJA: setup_efi_vars FAILED\n");
-		return status;
-	}
-
-	status = efi_call_phys3(sys_table->boottime->allocate_pool,
-				EFI_LOADER_DATA, sizeof(*efidata), &efidata);
-
-	if (status != EFI_SUCCESS)
-		return status;
-
-	efidata->data.type = SETUP_EFI_VARS;
-	efidata->data.len = sizeof(struct efi_var_bootdata) -
-		sizeof(struct setup_data);
-	efidata->data.next = 0;
-	efidata->store_size = store_size;
-	efidata->remaining_size = remaining_size;
-	efidata->max_var_size = var_size;
-
-	if (data)
-		data->next = (unsigned long)efidata;
-	else
-		params->hdr.setup_data = (unsigned long)efidata;
-
-}
-
 static efi_status_t setup_efi_pci(struct boot_params *params)
 {
 	efi_pci_io_protocol *pci;
@@ -1204,8 +1157,6 @@ struct boot_params *efi_main(void *handl
 
 	setup_graphics(boot_params);
 
-	setup_efi_vars(boot_params);
-
 	setup_efi_pci(boot_params);
 
 	status = efi_call_phys3(sys_table->boottime->allocate_pool,
Index: linux/arch/x86/platform/efi/efi.c
===================================================================
--- linux.orig/arch/x86/platform/efi/efi.c	2013-05-30 11:02:19.034914824 -0500
+++ linux/arch/x86/platform/efi/efi.c	2013-05-30 17:05:38.140039879 -0500
@@ -786,9 +786,6 @@ void __init efi_init(void)
 	char vendor[100] = "unknown";
 	int i = 0;
 	void *tmp;
-	struct setup_data *data;
-	struct efi_var_bootdata *efi_var_data;
-	u64 pa_data;
 
 #ifdef CONFIG_X86_32
 	if (boot_params.efi_info.efi_systab_hi ||
@@ -806,22 +803,6 @@ void __init efi_init(void)
 	if (efi_systab_init(efi_phys.systab))
 		return;
 
-	pa_data = boot_params.hdr.setup_data;
-	while (pa_data) {
-		data = early_ioremap(pa_data, sizeof(*efi_var_data));
-		if (data->type == SETUP_EFI_VARS) {
-			efi_var_data = (struct efi_var_bootdata *)data;
-
-			efi_var_store_size = efi_var_data->store_size;
-			efi_var_remaining_size = efi_var_data->remaining_size;
-			efi_var_max_var_size = efi_var_data->max_var_size;
-		}
-		pa_data = data->next;
-		early_iounmap(data, sizeof(*efi_var_data));
-	}
-
-	boot_used_size = efi_var_store_size - efi_var_remaining_size;
-
 	set_bit(EFI_SYSTEM_TABLES, &x86_efi_facility);
 
 	/*
@@ -877,7 +858,23 @@ void __init efi_init(void)
 
 void __init efi_late_init(void)
 {
+	efi_status_t status;
+
 	efi_bgrt_init();
+
+	if (efi.runtime_version < EFI_2_00_SYSTEM_TABLE_REVISION)
+		return;
+
+	status = efi_call_virt4(query_variable_info,
+				EFI_VARIABLE_NON_VOLATILE |
+				EFI_VARIABLE_BOOTSERVICE_ACCESS |
+				EFI_VARIABLE_RUNTIME_ACCESS,
+				&efi_var_max_var_size, &efi_var_remaining_size,
+				&efi_var_store_size);
+	if (status != EFI_SUCCESS)
+		return;
+
+	boot_used_size = efi_var_store_size - efi_var_remaining_size;
 }
 
 void __init efi_set_executable(efi_memory_desc_t *md, bool executable)

--0OAP2g/MAC+5xKAE--
