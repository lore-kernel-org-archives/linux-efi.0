From: Toshi Kani <toshi.kani-VXdhtT5mjnY@public.gmane.org>
Subject: Re: [PATCH v4 4/4 update] Passing efi related data via setup_data
Date: Mon, 06 Jan 2014 14:58:33 -0700
Message-ID: <1389045513.1792.0.camel@misato.fc.hp.com>
References: <1387533947-18210-1-git-send-email-dyoung@redhat.com>
	 <1387533947-18210-5-git-send-email-dyoung@redhat.com>
	 <20131230071656.GB3827@dhcp-16-126.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131230071656.GB3827-je1gSBvt1TcFLmT5oZ11vB/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org, greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, horms-/R6kz+dDXgpPR4JQBCEnsQ@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Mon, 2013-12-30 at 15:16 +0800, Dave Young wrote:
> For supporting efi runtime, several efi physical addresses
> fw_vendor, runtime, config tables, smbios and the whole runtime
> mapping info need to be used in kexec kernel. Thus introduce
> setup_data struct for passing these data.
> 
> collect the varialbes from /sys/firmware/efi/systab and
> /sys/firmware/efi/runtime-map
> 
> Tested on qemu+ovmf, dell laptop, lenovo laptop and HP workstation.
> 
> v1->v2:
> HPA: use uint*_t instead of __uint*_t
> Simon: indention fix; fix a memory leak
> move offset change update to previous patch in setup header
> only passing setup_data when the bzImage support efi boot
> Vivek: export a value in bzImage probe so it can be used
>       to check if we should pass acpi_rsdp.
> coding style
> 
> v2->v3:
> code cleanup
> bail out if efi mm desc_version != 1
> bhe: define macro for SETUP_EFI
>      break loop if find matched string in systab.
> 
> v3->v4:
> update memmap in efi_info to the saved runtime map
> So kernel side can iterate them as normal boot.
> 
> v4->v5:
> simplify function get_efi_value(), add error handling
> realloc error handling
> move map[0] out of efi_setup_data since memmap addr is set in efi_info
> 
> Signed-off-by: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Tested-by: Toshi Kani <toshi.kani-VXdhtT5mjnY@public.gmane.org>

Thanks,
Toshi
