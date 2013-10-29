From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 12/12] EFI: Runtime services virtual mapping
Date: Tue, 29 Oct 2013 14:47:20 +0800
Message-ID: <20131029064720.GA16009@dhcp-16-126.nay.redhat.com>
References: <1379602494-26684-1-git-send-email-bp@alien8.de>
 <20131008164551.GB16793@pd.tnic>
 <20131008164831.GD16793@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20131008164831.GD16793-fF5Pk5pvG8Y@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, fwts-devel-nLRlyDuq1AZFpShjVBNYrg@public.gmane.org
List-Id: linux-efi@vger.kernel.org

>  /*
>   * This function will switch the EFI runtime services to virtual mode.
>   * Essentially, look through the EFI memmap and map every region that
> @@ -862,10 +906,10 @@ void efi_memory_uc(u64 addr, unsigned long size)
>  void __init efi_enter_virtual_mode(void)

Boris, could you update the comment? it says below:
 update that memory descriptor with the virtual address obtained
 from ioremap().

Logiclly your patch should update it, then my patch update it again with
the case of mapping to fixed address for kexec.

Thanks
Dave
