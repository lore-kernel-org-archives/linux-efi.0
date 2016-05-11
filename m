From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH] Xen: EFI: Parse DT parameters for Xen specific UEFI
Date: Wed, 11 May 2016 13:29:48 +0100
Message-ID: <20160511122948.GV2839@codeblueprint.co.uk>
References: <1462523526-3172-1-git-send-email-zhaoshenglong@huawei.com>
 <CANLsYkxUyiUfdjm39SvhKSvmddPLFP3JFAeHpYuxgPyZfexw6w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CANLsYkxUyiUfdjm39SvhKSvmddPLFP3JFAeHpYuxgPyZfexw6w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Shannon Zhao <zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, sstabellini-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, stefano-yd54mjeZNzVBDgjK7y7TUQ@public.gmane.org, julien.grall-5wv7dgnIgG8@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, peter.huangpeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Fri, 06 May, at 09:52:42AM, Mathieu Poirier wrote:
> > +static int __init efi_remap_init(void)
> > +{
> > +       u64 mapsize;
> > +
> > +       pr_info("Remapping and enabling EFI services.\n");
> > +
> > +       mapsize = memmap.map_end - memmap.map;
> > +       memmap.map = (__force void *)ioremap_cache(memmap.phys_map,
> > +                                                  mapsize);
> > +       if (!memmap.map) {
> > +               pr_err("Failed to remap EFI memory map\n");
> > +               return -ENOMEM;
> > +       }
> > +       memmap.map_end = memmap.map + mapsize;
> > +       efi.memmap = &memmap;
> > +
> > +       efi.systab = (__force void *)ioremap_cache(efi_system_table,
> > +                                                  sizeof(efi_system_table_t));
> > +       if (!efi.systab) {
> 
> Is there a reason why memmap.map isn't iounmap() in the error path?
> The original code didn't have it either, hence the question.

I suspect that is a bug.

In reality, if you can't access the EFI System Table because you fail
to map it I would guess you are going to crash very, very quickly
anyhow.
