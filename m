From: jerry.hoemann-VXdhtT5mjnY@public.gmane.org
Subject: Re: [PATCH 0/3] Early use of boot service memory
Date: Fri, 15 Nov 2013 15:55:40 -0700
Message-ID: <20131115225540.GA5485@anatevka.fc.hp.com>
References: <20131114180455.GA32212@anatevka.fc.hp.com>
 <CAOJsxLFWMi8DoFp+ufri7XoFO27v+2=0oksh8+NhM6P-OdkOwg@mail.gmail.com>
 <20131115005049.GJ5116@anatevka.fc.hp.com>
 <20131115062417.GB9237@gmail.com>
 <CAE9FiQWzSTtW8N=0hoUe6iCSM-k64Mv97n0whAS0_vZ+psuOsg@mail.gmail.com>
 <5285C639.5040203@zytor.com>
 <20131115140738.GB6637@redhat.com>
 <CAE9FiQUnw9Ujmdtq-AgC4VctQ=fZSBkzehoTbvw=aZeARL+pwA@mail.gmail.com>
 <20131115180324.GD6637@redhat.com>
 <CAE9FiQU_OstEq3VWwBB879O4EY0DE+zVWVens+w0MLFUQmr3sw@mail.gmail.com>
Reply-To: jerry.hoemann-VXdhtT5mjnY@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAE9FiQU_OstEq3VWwBB879O4EY0DE+zVWVens+w0MLFUQmr3sw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Rob Landley <rob-VoJi6FS/r0vR7s880joybQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, x86 maintainers <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "list-T1Yj925okcpg9hUCZPvPmw@public.gmane.org:DOCUMENTATION" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "list-T1Yj925okcpg9hUCZPvPmw@public.gmane.org:MEMORY MANAGEMENT" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, Nov 15, 2013 at 02:24:25PM -0800, Yinghai Lu wrote:
> On Fri, Nov 15, 2013 at 10:03 AM, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > On Fri, Nov 15, 2013 at 09:33:41AM -0800, Yinghai Lu wrote:
> 
> >> I have one system with 6TiB memory, kdump does not work even
> >> crashkernel=512M in legacy mode. ( it only work on system with
> >> 4.5TiB).
> >
> > Recently I tested one system with 6TB of memory and dumped successfully
> > with 512MB reserved under 896MB. Also I have heard reports of successful
> > dump of 12TB system with 512MB reserved below 896MB (due to cyclic
> > mode of makedumpfile).
> >
> > So with newer releases only reason one might want to reserve more
> > memory is that it might provide speed benefits. We need more testing
> > to quantify this.
> 
> You may need bunch of PCIe cards installed.
> 
> The system with 6TiB + 16 PCIe cards, second kernel OOM.
> The system with 4.5TiB + 16 PCIe cards, second kernel works with vmcore dumped.

Yinghai,

Your original email said you were using "legacy mode".  Does this mean
you're not running makedumpfile in cyclic mode?  Cyclic mode makes
a *big* difference in memory foot print of makedumpfile.

thanks


Jerry


> 
> >
> >> --- first kernel can reserve the 512M under 896M, second kernel will
> >> OOM as it load driver for every pci devices...
> >>
> >> So why would RH guys not spend some time on optimizing your kdump initrd
> >> build scripts and only put dump device related driver in it?
> >
> > Try latest Fedora and that's what we do. Now we have moved to dracut
> > based initramfs generation and we tell dracut that build initramfs for
> > host and additional dump destination and dracut builds it for those only.
> > I think there might be scope for further optimization, but I don't think
> > that's the problem any more.
> 
> Good. Assume that will be in RHEL 7.
> 
> >
> > So issue remains that crashkernel=X,high is not a good default choice
> > because it consumes extra 72M which we don't have to.
> 
> then if it falls into 896~4G, user may still need to update kexec-tools ?
> 
> Thanks
> 
> Yinghai

-- 

----------------------------------------------------------------------------
Jerry Hoemann            Software Engineer              Hewlett-Packard

3404 E Harmony Rd. MS 57                        phone:  (970) 898-1022
Ft. Collins, CO 80528                           FAX:    (970) 898-XXXX
                                                email:  jerry.hoemann-VXdhtT5mjnY@public.gmane.org
----------------------------------------------------------------------------
