From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [patch 0/7 v2] kexec kernel efi runtime support
Date: Fri, 8 Nov 2013 14:31:18 +0000
Message-ID: <20131108143118.GA22636@console-pimps.org>
References: <20131105082007.872550445@dhcp-16-126.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20131105082007.872550445-je1gSBvt1TcFLmT5oZ11vB/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, horms-/R6kz+dDXgpPR4JQBCEnsQ@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Tue, 05 Nov, at 04:20:07PM, dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org wrote:
> Hi,
> 
> Here is the V2 for supporting kexec kernel efi runtime.
> Per pervious discussion I pass the 1st kernel efi runtime mapping
> via setup_data to 2nd kernel. Besides of the runtime mapping
> info I also pass the fw_vendor, runtime, config table, smbios
> physical address in setup_data. EFI spec mentioned fw_vendor,
> runtime, config table addresses will be converted to virt address
> after entering virtual mode, but we will use it as physical address
> in efi_init. For smbios EFI spec did not mention about the address
> updating, but during my test on a HP workstation, the bios will
> convert it to Virt addr, thus pass it in setup_data as well.

I see this in the dmesg,

[    0.000000] efi: skipping setup_data on EFI 32BIT!

despite the fact that this is on an x86-64 box. Turns out it's because
CONFIG_DEBUG_BOOT_PARAMS isn't set in my config. You may want to turn
that on automatically. After doing that things work on my ASUS box (good
work!) but the SATA controller craps out on my Tunnelmountain machine,
but that's probably unrelated and I'll debug that separately.

I see a bunch of section mismatch warnings,

WARNING: arch/x86/platform/efi/built-in.o(.text+0xd1e): Section mismatch in reference from the function efi_map_regions_fixed() to the function .init.text:efi_map_region_fixed()
The function efi_map_regions_fixed() references
the function __init efi_map_region_fixed().
This is often because efi_map_regions_fixed lacks a __init 
annotation or the annotation of efi_map_region_fixed is wrong.

WARNING: arch/x86/platform/efi/built-in.o(.text+0xd2a): Section mismatch in reference from the function efi_map_regions_fixed() to the variable .init.data:efi_phys
The function efi_map_regions_fixed() references
the variable __initdata efi_phys.
This is often because efi_map_regions_fixed lacks a __initdata 
annotation or the annotation of efi_phys is wrong.

WARNING: arch/x86/platform/built-in.o(.text+0xd1e): Section mismatch in reference from the function efi_map_regions_fixed() to the function .init.text:efi_map_region_fixed()
The function efi_map_regions_fixed() references
the function __init efi_map_region_fixed().
This is often because efi_map_regions_fixed lacks a __init 
annotation or the annotation of efi_map_region_fixed is wrong.

WARNING: arch/x86/platform/built-in.o(.text+0xd2a): Section mismatch in reference from the function efi_map_regions_fixed() to the variable .init.data:efi_phys
The function efi_map_regions_fixed() references
the variable __initdata efi_phys.
This is often because efi_map_regions_fixed lacks a __initdata 
annotation or the annotation of efi_phys is wrong.

WARNING: arch/x86/built-in.o(.text+0x7c357): Section mismatch in reference from the function parse_efi_setup() to the function .init.text:early_memremap()
The function parse_efi_setup() references
the function __init early_memremap().
This is often because parse_efi_setup lacks a __init 
annotation or the annotation of early_memremap is wrong.

WARNING: arch/x86/built-in.o(.text+0x7c390): Section mismatch in reference from the function parse_efi_setup() to the function .init.text:early_iounmap()
The function parse_efi_setup() references
the function __init early_iounmap().
This is often because parse_efi_setup lacks a __init 
annotation or the annotation of early_iounmap is wrong.

WARNING: arch/x86/built-in.o(.text+0x7c5ce): Section mismatch in reference from the function efi_map_regions_fixed() to the function .init.text:efi_map_region_fixed()
The function efi_map_regions_fixed() references
the function __init efi_map_region_fixed().
This is often because efi_map_regions_fixed lacks a __init 
annotation or the annotation of efi_map_region_fixed is wrong.

WARNING: arch/x86/built-in.o(.text+0x7c5da): Section mismatch in reference from the function efi_map_regions_fixed() to the variable .init.data:vdso32_sysenter_end
The function efi_map_regions_fixed() references
the variable __initdata vdso32_sysenter_end.
This is often because efi_map_regions_fixed lacks a __initdata 
annotation or the annotation of vdso32_sysenter_end is wrong.

Also, many of your patch descriptions are missing subsystem tags. Please
fix this in your next submission.

-- 
Matt Fleming, Intel Open Source Technology Center
