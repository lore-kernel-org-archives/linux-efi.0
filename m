From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 12/12] EFI: Runtime services virtual mapping
Date: Fri, 11 Oct 2013 09:42:34 -0400 (EDT)
Message-ID: <643121905.4545046.1381498954428.JavaMail.root@redhat.com>
References: <1379602494-26684-1-git-send-email-bp@alien8.de> <20131008164831.GD16793@pd.tnic> <20131010080635.GA3692@dhcp-16-126.nay.redhat.com> <20131010081434.GB3692@dhcp-16-126.nay.redhat.com> <20131010085827.GA9929@pd.tnic> <20131010123453.GA12321@console-pimps.org> <20131011062437.GA14115@dhcp-16-126.nay.redhat.com> <20131011102706.GE12321@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131011102706.GE12321-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, fwts-devel-nLRlyDuq1AZFpShjVBNYrg@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Matt,

The kernel I referring is the boot kernel aka the 1st kernel,
the boot loader is grub2 from Fedora 19.

[sorry for top reply because of using webmail]


----- Original Message -----
From: "Matt Fleming" <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
To: "Dave Young" <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "Borislav Petkov" <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, "X86 ML" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "LKML" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Borislav Petkov" <bp-l3A5Bk7waGM@public.gmane.org>, "Matthew Garrett" <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "James Bottomley" <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, "Vivek Goyal" <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, fwts-devel-nLRlyDuq1AZFpShjVBNYrg@public.gmane.org
Sent: Friday, October 11, 2013 6:27:06 PM
Subject: Re: [PATCH 12/12] EFI: Runtime services virtual mapping

On Fri, 11 Oct, at 02:24:37PM, Dave Young wrote:
> For the boot efi_reserve_boot_services code, it's mainly for the
> SetVirtualAddressMap callback use, so boot regions should not be reused
> before SetVirtualAddressMap, but the overlapping happens before the
> efi_reserve_boot_services, isn't it a problem?

Hang on, which kernel are you referring to here? The boot kernel or the
kexec'd kernel? I thought you were saying you noticed the overlap when
running in the second (kexec'd) kernel?

The only reason that you would see this overlap in the first (boot)
kernel is if the bootloader messed up and allocated the kernel text as
EfiBootServicesCode/Data. I'd like to believe no bootloaders are still
doing that.

-- 
Matt Fleming, Intel Open Source Technology Center
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
