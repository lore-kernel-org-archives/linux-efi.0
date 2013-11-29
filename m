From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 00/12] kexec kernel efi runtime support
Date: Fri, 29 Nov 2013 16:28:22 +0800
Message-ID: <20131129082822.GA4186@dhcp-16-126.nay.redhat.com>
References: <1385445477-9665-1-git-send-email-dyoung@redhat.com>
 <20131127125003.GG18170@console-pimps.org>
 <20131128020840.GB4282@dhcp-16-126.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20131128020840.GB4282-je1gSBvt1TcFLmT5oZ11vB/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, horms-/R6kz+dDXgpPR4JQBCEnsQ@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org, toshi.kani-VXdhtT5mjnY@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 11/28/13 at 10:08am, Dave Young wrote:
> On 11/27/13 at 12:50pm, Matt Fleming wrote:
> > On Tue, 26 Nov, at 01:57:45PM, Dave Young wrote:
> > > Hi,
> > > 
> > > Here is the V4 resend for supporting kexec kernel efi runtime.
> > > Per pervious discussion I pass the 1st kernel efi runtime mapping
> > > via setup_data to 2nd kernel. Besides of the runtime mapping
> > > info I also pass the fw_vendor, runtime, config table, smbios
> > > physical address in setup_data. EFI spec mentioned fw_vendor,
> > > runtime, config table addresses will be converted to virt address
> > > after entering virtual mode, but we will use it as physical address
> > > in efi_init. For smbios EFI spec did not mention about the address
> > > updating, but during my test on a HP workstation, the bios will
> > > convert it to Virt addr, thus pass it in setup_data as well.
> >  
> > Dave, your commits introduce a bunch of new sparse warnings,
> 
> Hi, Matt
> 
> Will fix them, thanks.
> 
> > 
> > /home/build/git/efi/arch/x86/platform/efi/efi.c:130:15: warning: incorrect type in assignment (different address spaces)
> > /home/build/git/efi/arch/x86/platform/efi/efi.c:130:15:    expected struct setup_data *sdata
> > /home/build/git/efi/arch/x86/platform/efi/efi.c:130:15:    got void [noderef] <asn:2>*
> > /home/build/git/efi/arch/x86/platform/efi/efi.c:140:23: warning: incorrect type in argument 1 (different address spaces)
> > /home/build/git/efi/arch/x86/platform/efi/efi.c:140:23:    expected void [noderef] <asn:2>*addr
> > /home/build/git/efi/arch/x86/platform/efi/efi.c:140:23:    got struct setup_data *sdata
> > /home/build/git/efi/arch/x86/platform/efi/efi.c:143:16: warning: incorrect type in assignment (different address spaces)
> > /home/build/git/efi/arch/x86/platform/efi/efi.c:143:16:    expected struct efi_setup_data *[addressable] [toplevel] esdata
> > /home/build/git/efi/arch/x86/platform/efi/efi.c:143:16:    got void [noderef] <asn:2>*
> > 
> > /home/build/git/efi/arch/x86/platform/efi/efi.c:701:20: warning: incorrect type in assignment (different address spaces)
> > /home/build/git/efi/arch/x86/platform/efi/efi.c:701:20:    expected void *tablep
> > /home/build/git/efi/arch/x86/platform/efi/efi.c:701:20:    got void [noderef] <asn:2>*
> > /home/build/git/efi/arch/x86/platform/efi/efi.c:722:23: warning: incorrect type in argument 1 (different address spaces)
> > /home/build/git/efi/arch/x86/platform/efi/efi.c:722:23:    expected void [noderef] <asn:2>*addr
> > /home/build/git/efi/arch/x86/platform/efi/efi.c:722:23:    got void *tablep
> > 
> > /home/build/git/efi/arch/x86/platform/efi/efi.c:1079:31: warning: incorrect type in argument 1 (different address spaces)
> > /home/build/git/efi/arch/x86/platform/efi/efi.c:1079:31:    expected void [noderef] <asn:2>*addr
> > /home/build/git/efi/arch/x86/platform/efi/efi.c:1079:31:    got struct efi_setup_data *[addressable] [toplevel] esdata

For the early_memremap, these warnings are safe, but it create a lot of
warnings and looks anoise.

I think for anyone who are using early_memremap should know this is a normal
kernel memory instead of real __iomem, so I'd prefer below fix, it will suppress
most of original and new warnings:

diff --git a/arch/x86/include/asm/io.h b/arch/x86/include/asm/io.h
index 34f69cb..1db414f 100644
--- a/arch/x86/include/asm/io.h
+++ b/arch/x86/include/asm/io.h
@@ -325,9 +325,10 @@ extern void early_ioremap_init(void);
 extern void early_ioremap_reset(void);
 extern void __iomem *early_ioremap(resource_size_t phys_addr,
 				   unsigned long size);
-extern void __iomem *early_memremap(resource_size_t phys_addr,
+extern void *early_memremap(resource_size_t phys_addr,
 				    unsigned long size);
 extern void early_iounmap(void __iomem *addr, unsigned long size);
+extern void early_memunmap(void *addr, unsigned long size);
 extern void fixup_early_ioremap(void);
 extern bool is_early_ioremap_ptep(pte_t *ptep);
 
diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 799580c..92a896652 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -562,10 +562,10 @@ early_ioremap(resource_size_t phys_addr, unsigned long size)
 }
 
 /* Remap memory */
-void __init __iomem *
+void __init *
 early_memremap(resource_size_t phys_addr, unsigned long size)
 {
-	return __early_ioremap(phys_addr, size, PAGE_KERNEL);
+	return (__force void __kernel *) __early_ioremap(phys_addr, size, PAGE_KERNEL);
 }
 
 void __init early_iounmap(void __iomem *addr, unsigned long size)
@@ -620,3 +620,8 @@ void __init early_iounmap(void __iomem *addr, unsigned long size)
 	}
 	prev_map[slot] = NULL;
 }
+
+void __init early_memunmap(void *addr, unsigned long size)
+{
+	early_iounmap((__force void __iomem *)addr, size);
+}
