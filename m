From: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] x86/boot: EFI_MIXED should not prohibit loading above 4G
Date: Mon, 9 Jun 2014 10:15:12 -0400
Message-ID: <20140609141512.GA22049@redhat.com>
References: <1402140380-15377-1-git-send-email-matt@console-pimps.org>
 <20140609125427.GA16256@redhat.com>
 <CADknwL7Jeh82W3=rEqGqh=37zpqhmMuP1jy+DDq9vb2gQ+9hzg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CADknwL7Jeh82W3=rEqGqh=37zpqhmMuP1jy+DDq9vb2gQ+9hzg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Jun 09, 2014 at 02:18:54PM +0100, Matt Fleming wrote:
> On 9 June 2014 13:54, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > Hi Matt,
> >
> > So with new kexec syscall I have written 64bit bzImage loader. For now
> > I would like to detect this situation and disable loading and once
> > 32bit loader gets implemented it can take care of loading bzImage below
> > 4G.
> 
> What situation do you want to detect? You want to detect when it's
> impossible to load a kernel above 4G in the kexec path because you're
> booting with 32-bit EFI firmware?

Yes.

> 
> > So how do I find out if EFI is 32bit.
> 
> efi_enabled(EFI_64BIT) will tell you that, but you probably also want
> to check that EFI runtime services are actually usable with
> efi_enabled(EFI_RUNTIME_SERVICES) since if they're not, you'll never
> call into the firmware so it doesn't matter where you load the kernel
> (this may happen with "noefi" kernel parameter).

Ok, thanks. Or I can check whether EFI run time map is there or not. I am
assuming that efi runtime services are not enabled, then run time map
will not be there either.

Thanks
Vivek
