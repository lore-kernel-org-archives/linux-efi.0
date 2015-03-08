From: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 1/8] x86: Kill E820_RESERVED_KERN
Date: Sat, 7 Mar 2015 22:51:53 -0800
Message-ID: <CAE9FiQWd71SxCf9=Nh_dBSKK2ecHC=s3-2R7dZJM9PGuR7ybzw@mail.gmail.com>
References: <1425776181-10219-1-git-send-email-yinghai@kernel.org>
	<1425776181-10219-2-git-send-email-yinghai@kernel.org>
	<alpine.DEB.2.10.1503071748530.5739@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.10.1503071748530.5739-X6Q0R45D7oAcqpCFd4KODRPsWskHk0ljAL8bYrjMMd8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Chun-Yi Lee <jlee-IBi9RG/b67k@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Sat, Mar 7, 2015 at 5:59 PM, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>
> Hmm, although the bug is reported for a 3.12 kernel, I assume this is for
> stable 3.10+?  If so, it should apply fine with the exception of removing
> e820_reserve_setup_data() from setup_arch() rather than
> memblock_x86_reserve_range_setup_data().  Or is it for 3.2 as well and
> needs to be completely rebased for that kernel?

For 3.10+, we will need to following patches, otherwise will have warning for
SETUP_PCI with ioremap.

for 3.2 that does not SETUP_PCI, should be ok, but will need rebase.

Thanks

Yinghai
