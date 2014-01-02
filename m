From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v7 00/12] kexec kernel efi runtime support
Date: Thu, 2 Jan 2014 10:42:56 +0800
Message-ID: <20140102024256.GB2563@darkstar.nay.redhat.com>
References: <1387533742-18018-1-git-send-email-dyoung@redhat.com>
 <20131221173515.GE29501@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20131221173515.GE29501-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, horms-/R6kz+dDXgpPR4JQBCEnsQ@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org, toshi.kani-VXdhtT5mjnY@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Sat, Dec 21, 2013 at 05:35:15PM +0000, Matt Fleming wrote:
> On Fri, 20 Dec, at 06:02:10PM, Dave Young wrote:
> > Here is the V7 patchset for supporting kexec kernel efi runtime.
> > Per pervious discussion I pass the 1st kernel efi runtime mapping
> > via setup_data to 2nd kernel. Besides of the runtime mapping
> > info I also pass the fw_vendor, runtime, config table, smbios
> > physical address in setup_data. EFI spec mentioned fw_vendor,
> > runtime, config table addresses will be converted to virt address
> > after entering virtual mode, but we will use it as physical address
> > in efi_init. For smbios EFI spec did not mention about the address
> > updating, but during my test on a HP workstation, the bios will
> > convert it to Virt addr, thus pass it in setup_data as well.
> 
> OK Dave, I've pulled patches 3-12 into the 'kexec' branch at,
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git
> 
> I plan on sending this branch to the tip folks this week for further
> testing.
> 

Hi, Matt

randconfig build robot reports several problems:
1. sparse warnings which should be fixed by the early_memremap patches
2. ksysfs.c building fails because of lack include <asm/io.h>
3. parse_efi_setup is called in arch/x86/kernel/setup.c, but if it will
   faill in case withoug CONFIG_EFI.

Here is the fix for 2. and 3, please take a look. I'm not sure if I
should resend the patches or leave them to you.

(Build tested with the configs mentioned in the failure report email.
Tested kexec boot in OVMF/qemu virtual machine)

Thanks a lot~
-----------------

build fix: include asm/io.h for calling ioremap_cache
---
 arch/x86/kernel/ksysfs.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux/arch/x86/kernel/ksysfs.c
===================================================================
--- linux.orig/arch/x86/kernel/ksysfs.c
+++ linux/arch/x86/kernel/ksysfs.c
@@ -16,6 +16,7 @@
 #include <linux/stat.h>
 #include <linux/slab.h>
 #include <linux/mm.h>
+#include <asm/io.h>
 
 #include <asm/setup.h>
 

build fix: move parse_efi_setup to efi*.c, call it in efi_init instead in setup.c
---
 arch/x86/include/asm/efi.h     |    3 +--
 arch/x86/kernel/setup.c        |    3 ---
 arch/x86/platform/efi/efi.c    |    1 +
 arch/x86/platform/efi/efi_32.c |    2 +-
 arch/x86/platform/efi/efi_64.c |   18 ++++++++++++++++--
 5 files changed, 19 insertions(+), 8 deletions(-)

Index: linux/arch/x86/include/asm/efi.h
===================================================================
--- linux.orig/arch/x86/include/asm/efi.h
+++ linux/arch/x86/include/asm/efi.h
@@ -143,8 +143,7 @@ struct efi_setup_data {
 };
 
 extern u64 efi_setup;
-extern u32 efi_data_len;
-extern void parse_efi_setup(u64 phys_addr, u32 data_len);
+extern void parse_efi_setup(void);
 
 #ifdef CONFIG_EFI
 
Index: linux/arch/x86/kernel/setup.c
===================================================================
--- linux.orig/arch/x86/kernel/setup.c
+++ linux/arch/x86/kernel/setup.c
@@ -447,9 +447,6 @@ static void __init parse_setup_data(void
 		case SETUP_DTB:
 			add_dtb(pa_data);
 			break;
-		case SETUP_EFI:
-			parse_efi_setup(pa_data, data_len);
-			break;
 		default:
 			break;
 		}
Index: linux/arch/x86/platform/efi/efi.c
===================================================================
--- linux.orig/arch/x86/platform/efi/efi.c
+++ linux/arch/x86/platform/efi/efi.c
@@ -719,6 +719,7 @@ void __init efi_init(void)
 			  ((__u64)boot_params.efi_info.efi_systab_hi<<32));
 #endif
 
+	parse_efi_setup();
 	if (efi_systab_init(efi_phys.systab))
 		return;
 
Index: linux/arch/x86/platform/efi/efi_32.c
===================================================================
--- linux.orig/arch/x86/platform/efi/efi_32.c
+++ linux/arch/x86/platform/efi/efi_32.c
@@ -48,7 +48,7 @@ void __init efi_map_region(efi_memory_de
 }
 
 void __init efi_map_region_fixed(efi_memory_desc_t *md) {}
-void __init parse_efi_setup(u64 phys_addr, u32 data_len) {}
+void __init parse_efi_setup(void) {}
 
 void efi_call_phys_prelog(void)
 {
Index: linux/arch/x86/platform/efi/efi_64.c
===================================================================
--- linux.orig/arch/x86/platform/efi/efi_64.c
+++ linux/arch/x86/platform/efi/efi_64.c
@@ -229,7 +229,21 @@ void __iomem *__init efi_ioremap(unsigne
 	return (void __iomem *)__va(phys_addr);
 }
 
-void __init parse_efi_setup(u64 phys_addr, u32 data_len)
+void __init parse_efi_setup(void)
 {
-	efi_setup = phys_addr + sizeof(struct setup_data);
+	struct setup_data *data;
+	u64 pa_data;
+
+	pa_data = boot_params.hdr.setup_data;
+	while (pa_data) {
+		u32 map_len;
+
+		map_len = max(PAGE_SIZE - (pa_data & ~PAGE_MASK),
+			      (u64)sizeof(struct setup_data));
+		data = early_memremap(pa_data, map_len);
+		if (data->type == SETUP_EFI)
+			efi_setup = pa_data + sizeof(struct setup_data);
+		pa_data = data->next;
+		early_iounmap(data, map_len);
+	}
 }
