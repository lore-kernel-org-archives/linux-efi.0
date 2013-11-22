From: Toshi Kani <toshi.kani-VXdhtT5mjnY@public.gmane.org>
Subject: Re: [patch 0/4 v3] kexec-tools: efi runtime support
Date: Fri, 22 Nov 2013 15:30:48 -0700
Message-ID: <1385159448.1791.161.camel@misato.fc.hp.com>
References: <20131121064043.969000753@dhcp-16-126.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131121064043.969000753-je1gSBvt1TcFLmT5oZ11vB/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, horms-/R6kz+dDXgpPR4JQBCEnsQ@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org, matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, 2013-11-21 at 14:40 +0800, dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org wrote:
> Hi,
> 
> This is the v3 patchset for adding efi runtime support on kexec kernel
> kernel patches was sent a while ago, not yet updated in archive. 
> 
> in kexec-tools, this patchset will do below:
> 1. retrieve efi_info from sysfs boot_params, and fill the
> x86 setup header. If kernel does not export sysfs boot_params,
> still try to find them in debugfs.
> 
> 2. collect data efi runtime needed:
> /sys/firmware/efi/systab: smbios
> /sys/firmware/efi/fw_vendor
> /sys/firmware/efi/runtime
> /sys/firmware/efi/config_table
> 
> /sys/firmware/efi/runtime-map/*, the phys-virt mappings in 1st kernel
> 
> 3. assemble setup_data based on data get in 2) then pass it to 2nd kernel
> 
> Tested on OVMF, dell laptop, lenovo laptop and HP workstation

Tested on an HP EFI-based 60-way server (prototype).  For the series:

Tested-by: Toshi Kani <toshi.kani-VXdhtT5mjnY@public.gmane.org>

Thanks,
-Toshi
