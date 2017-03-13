From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: kexec regression since 4.9 caused by efi
Date: Mon, 13 Mar 2017 15:37:48 +0800
Message-ID: <20170313073748.GA6332@dhcp-128-65.nay.redhat.com>
References: <20170308201616.GC8598@vader>
 <20170309063806.GB17257@dhcp-128-65.nay.redhat.com>
 <20170309095408.GA17883@vader>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170309095408.GA17883@vader>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Omar Sandoval <osandov-nWWhXC5lh1RBDgjK7y7TUQ@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 03/09/17 at 01:54am, Omar Sandoval wrote:
> On Thu, Mar 09, 2017 at 02:38:06PM +0800, Dave Young wrote:
> > Add efi/kexec list.
> > 
> > On 03/08/17 at 12:16pm, Omar Sandoval wrote:
> 
> [snip]
> 
> > I have no more clue yet from your provided log, but the runtime value is
> > odd to me. It is set in below code:
> > 
> > arch/x86/platform/efi/efi.c: efi_systab_init()
> > 	efi_systab.runtime = data ?
> > 			     (void *)(unsigned long)data->runtime :
> > 			     (void *)(unsigne long)systab64->runtime;
> > 
> > Here data is the setup_data passed by kexec-tools from normal kernel to
> > kexec kernel, efi_setup_data structure is like below: 
> > struct efi_setup_data {
> >         u64 fw_vendor;
> >         u64 runtime;
> >         u64 tables;
> >         u64 smbios;
> >         u64 reserved[8];
> > };
> > 
> > kexec-tools get the runtime address from /sys/firmware/efi/runtime
> > 
> > So can you do some debuggin on your side, eg. see the sysfs runtime
> > value is correct or not. And add some printk in efi init path etc.
> 
> The attached patch fixes this for me.

Omar, could you try below patch? Looking at the efi_mem_desc_lookup, it is not
correct to be used in efi_arch_mem_reserve, if it passed your test, I
can rewrite patch log with more background and send it out:

        for_each_efi_memory_desc(md) {
		[snip]
                if (!(md->attribute & EFI_MEMORY_RUNTIME) &&
                    md->type != EFI_BOOT_SERVICES_DATA &&
                    md->type != EFI_RUNTIME_SERVICES_DATA) {
                        continue;
                }

In above code, it meant to get a md of EFI_MEMORY_RUNTIME of either boot
data or runtime data, this is wrong for efi_mem_reserve, because we are
reserving boot data which has no EFI_MEMORY_RUNTIME attribute at the
running time. Just is happened to work and we did not capture the error.

Signed-off-by: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 arch/x86/platform/efi/quirks.c |    4 +++-
 drivers/firmware/efi/efi.c     |   39 +++++++++++++++++++++++++++++++++++++++
 include/linux/efi.h            |    1 +
 3 files changed, 43 insertions(+), 1 deletion(-)

--- linux-x86.orig/arch/x86/platform/efi/quirks.c
+++ linux-x86/arch/x86/platform/efi/quirks.c
@@ -191,7 +191,9 @@ void __init efi_arch_mem_reserve(phys_ad
 	int num_entries;
 	void *new;
 
-	if (efi_mem_desc_lookup(addr, &md)) {
+	if (efi_md_lookup_boot_data(addr, &md)) {
+		if (md.attribute & EFI_MEMORY_RUNTIME)
+			return;
 		pr_err("Failed to lookup EFI memory descriptor for %pa\n", &addr);
 		return;
 	}
--- linux-x86.orig/drivers/firmware/efi/efi.c
+++ linux-x86/drivers/firmware/efi/efi.c
@@ -353,6 +353,45 @@ err_put:
 subsys_initcall(efisubsys_init);
 
 /*
+ * Find the efi memory descriptor for a given physical address.
+ * Given a physical address, if it exists within an EFI memory map
+ * entry of type EFI_BOOT_SERVICES_DATA and the entry has no attribute
+ * EFI_MEMORY_RUNTIME, then populate the supplied memory descriptor
+ * with the appropriate data.
+ */
+int __init efi_md_lookup_boot_data(u64 phys_addr,
+					 efi_memory_desc_t *out_md)
+{
+	efi_memory_desc_t *md;
+
+	if (!efi_enabled(EFI_MEMMAP)) {
+		pr_err_once("EFI_MEMMAP is not enabled.\n");
+		return -EINVAL;
+	}
+
+	if (!out_md) {
+		pr_err_once("out_md is null.\n");
+		return -EINVAL;
+	}
+
+	for_each_efi_memory_desc(md) {
+		u64 size;
+		u64 end;
+
+		if (md->type != EFI_BOOT_SERVICES_DATA)
+			continue;
+
+		size = md->num_pages << EFI_PAGE_SHIFT;
+		end = md->phys_addr + size;
+		if (phys_addr >= md->phys_addr && phys_addr < end) {
+			memcpy(out_md, md, sizeof(*out_md));
+			return 0;
+		}
+	}
+	return -ENOENT;
+}
+
+/*
  * Find the efi memory descriptor for a given physical address.  Given a
  * physical address, determine if it exists within an EFI Memory Map entry,
  * and if so, populate the supplied memory descriptor with the appropriate
--- linux-x86.orig/include/linux/efi.h
+++ linux-x86/include/linux/efi.h
@@ -979,6 +979,7 @@ extern u64 efi_mem_attribute (unsigned l
 extern int __init efi_uart_console_only (void);
 extern u64 efi_mem_desc_end(efi_memory_desc_t *md);
 extern int efi_mem_desc_lookup(u64 phys_addr, efi_memory_desc_t *out_md);
+extern int efi_md_lookup_boot_data(u64 phys_addr, efi_memory_desc_t *out_md);
 extern void efi_mem_reserve(phys_addr_t addr, u64 size);
 extern void efi_initialize_iomem_resources(struct resource *code_resource,
 		struct resource *data_resource, struct resource *bss_resource);
