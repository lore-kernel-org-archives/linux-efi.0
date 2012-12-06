From: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Subject: Re: Use PCI ROMs from EFI boot services
Date: Thu, 6 Dec 2012 18:54:39 +0000
Message-ID: <20121206185439.GA17381@srcf.ucam.org>
References: <1345739803-21017-1-git-send-email-mjg@redhat.com>
 <CAErSpo6dn_0b8Ngx9VT=ARs_UXQftEx=2Kczeqemtmo0XyKzuQ@mail.gmail.com>
 <20121203200241.GG5906@thinkpad-t410>
 <CAE9FiQVdpmmExrPrLf7HYVuo0cTY9Xjn6bWzObbuSSeQ-e1PbA@mail.gmail.com>
 <50BFE88D.1000800@zytor.com>
 <CAE9FiQXwZAAMkWYT8EjsewpuZ-OWqoaFscyzGS_pSuO9C3bf9A@mail.gmail.com>
 <CAE9FiQX+aJi5XEyjfjc=K4eXLbQNqE-vd+coyt1dmuujsi_eoQ@mail.gmail.com>
 <CAErSpo7-hUbvvCYPSwtSYKMKWqu99A5H5R4004rSj5Bmv0593g@mail.gmail.com>
 <50C0E339.4030607@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <50C0E339.4030607-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, Dec 06, 2012 at 10:26:01AM -0800, H. Peter Anvin wrote:

> NAK on this bit:
> 
> +       if (boot_params.hdr.version < 0x0209)
> +               return 0;
> 
> This field is kernel->bootloader documentation.  If a nonmaching
> value somehow leaks into the kernel, the kernel could either
> panic("Bootloader written by moron") or it should clear some fields,
> but littering the kernel with these kinds of tests is just plain
> braindead.

Dropping that should be fine. Bjorn, would you prefer a patch from me to 
do that?

-- 
Matthew Garrett | mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org
