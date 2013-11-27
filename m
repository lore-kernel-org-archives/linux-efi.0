From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH v4 00/12] kexec kernel efi runtime support
Date: Wed, 27 Nov 2013 12:50:03 +0000
Message-ID: <20131127125003.GG18170@console-pimps.org>
References: <1385445477-9665-1-git-send-email-dyoung@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1385445477-9665-1-git-send-email-dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, horms-/R6kz+dDXgpPR4JQBCEnsQ@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org, toshi.kani-VXdhtT5mjnY@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Tue, 26 Nov, at 01:57:45PM, Dave Young wrote:
> Hi,
> 
> Here is the V4 resend for supporting kexec kernel efi runtime.
> Per pervious discussion I pass the 1st kernel efi runtime mapping
> via setup_data to 2nd kernel. Besides of the runtime mapping
> info I also pass the fw_vendor, runtime, config table, smbios
> physical address in setup_data. EFI spec mentioned fw_vendor,
> runtime, config table addresses will be converted to virt address
> after entering virtual mode, but we will use it as physical address
> in efi_init. For smbios EFI spec did not mention about the address
> updating, but during my test on a HP workstation, the bios will
> convert it to Virt addr, thus pass it in setup_data as well.
 
Dave, your commits introduce a bunch of new sparse warnings,

/home/build/git/efi/arch/x86/platform/efi/efi.c:130:15: warning: incorrect type in assignment (different address spaces)
/home/build/git/efi/arch/x86/platform/efi/efi.c:130:15:    expected struct setup_data *sdata
/home/build/git/efi/arch/x86/platform/efi/efi.c:130:15:    got void [noderef] <asn:2>*
/home/build/git/efi/arch/x86/platform/efi/efi.c:140:23: warning: incorrect type in argument 1 (different address spaces)
/home/build/git/efi/arch/x86/platform/efi/efi.c:140:23:    expected void [noderef] <asn:2>*addr
/home/build/git/efi/arch/x86/platform/efi/efi.c:140:23:    got struct setup_data *sdata
/home/build/git/efi/arch/x86/platform/efi/efi.c:143:16: warning: incorrect type in assignment (different address spaces)
/home/build/git/efi/arch/x86/platform/efi/efi.c:143:16:    expected struct efi_setup_data *[addressable] [toplevel] esdata
/home/build/git/efi/arch/x86/platform/efi/efi.c:143:16:    got void [noderef] <asn:2>*

/home/build/git/efi/arch/x86/platform/efi/efi.c:701:20: warning: incorrect type in assignment (different address spaces)
/home/build/git/efi/arch/x86/platform/efi/efi.c:701:20:    expected void *tablep
/home/build/git/efi/arch/x86/platform/efi/efi.c:701:20:    got void [noderef] <asn:2>*
/home/build/git/efi/arch/x86/platform/efi/efi.c:722:23: warning: incorrect type in argument 1 (different address spaces)
/home/build/git/efi/arch/x86/platform/efi/efi.c:722:23:    expected void [noderef] <asn:2>*addr
/home/build/git/efi/arch/x86/platform/efi/efi.c:722:23:    got void *tablep

/home/build/git/efi/arch/x86/platform/efi/efi.c:1079:31: warning: incorrect type in argument 1 (different address spaces)
/home/build/git/efi/arch/x86/platform/efi/efi.c:1079:31:    expected void [noderef] <asn:2>*addr
/home/build/git/efi/arch/x86/platform/efi/efi.c:1079:31:    got struct efi_setup_data *[addressable] [toplevel] esdata

-- 
Matt Fleming, Intel Open Source Technology Center
