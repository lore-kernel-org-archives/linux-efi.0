From: "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>
Subject: Re: [RFC PATCH 00/14] Support timezone of ACPI TAD and EFI TIME
Date: Fri, 20 Dec 2013 23:18:56 +0100
Message-ID: <3476450.BMEcId2Lgj@vostro.rjw.lan>
References: <1387439053-8711-1-git-send-email-jlee@suse.com> <52B4BA0A.1030902@zytor.com> <20131220215056.GA29501@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131220215056.GA29501-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, joeyli <jlee-IBi9RG/b67k@public.gmane.org>, Alessandro Zummo <a.zummo-BfzFCNDTiLLj+vYz1yj4TQ@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, Elliott-VXdhtT5mjnY@public.gmane.org, samer.el-haj-mahmoud-VXdhtT5mjnY@public.gmane.org, Oliver Neukum <oneukum-l3A5Bk7waGM@public.gmane.org>, werner-IBi9RG/b67k@public.gmane.org, trenn-l3A5Bk7waGM@public.gmane.org, JBeulich-IBi9RG/b67k@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rtc-linux-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Friday, December 20, 2013 09:50:56 PM Matt Fleming wrote:
> On Fri, 20 Dec, at 01:43:38PM, H. Peter Anvin wrote:
> > 
> > Possibly... will have to investigate.  I would also ask if the same
> > applies to the PNP0B0x devices -- all we really need there is the
> > presence/absence indication and the I/O port base.
> 
> It's worth noting that efi_late_init() exists solely because the ACPI
> infrastructure to find the BGRT table isn't available any earlier.
> 
> If we could setup ACPI earlier that would be awesome.

I'm not sure 100%, but I *think* we need to do that with interrupts enabled.
At least after mm_init(), because it relies on things initialized there if I
remember correctly.

>From what I can tell at the moment, it might be possible to move it before
efi_enter_virtual_mode() if that would help.

Thanks,
Rafael
