From: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v3 1/8] x86: Kill E820_RESERVED_KERN
Date: Mon, 9 Mar 2015 08:18:25 +0800
Message-ID: <20150309001825.GB18497@linux-rxt1.site>
References: <1425776181-10219-1-git-send-email-yinghai@kernel.org>
 <1425776181-10219-2-git-send-email-yinghai@kernel.org>
 <alpine.DEB.2.10.1503071748530.5739@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1503071748530.5739-X6Q0R45D7oAcqpCFd4KODRPsWskHk0ljAL8bYrjMMd8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Sat, Mar 07, 2015 at 05:59:14PM -0800, David Rientjes wrote:
> On Sat, 7 Mar 2015, Yinghai Lu wrote:
> 
> > Now we are using memblock to do early resource reserver/allocation
> > instead of using e820 map directly, and setup_data is reserved in
> > memblock early already.
> > Also kexec generate setup_data and pass pointer to second kernel,
> > so second kernel reserve setup_data by their own.
> > (Now kexec-tools create SETUP_EFI and SETUP_E820_EXT).
> > 
> > We can kill E820_RESERVED_KERN and not touch e820 map at all.
> > 
> > That will fix bug in mark_nonsave_region that can not handle that
> > case: E820_RAM and E820_RESERVED_KERN ranges are continuous and
> > boundary is not page aligned.
> > 
> > Bugzilla: https://bugzilla.opensuse.org/show_bug.cgi?id=913885
> 
> Is this the bug referenced in the commit message that is fixed?  If so, 
> it's only a bug for resume, correct?  I'm not sure if that's clear enough 
> just from the commit message, I was looking at this patch for an e820 
> problem I'm currently facing on 3.3.

Yinghai's patches fixed the e820 not page aligned issue that's one of the
issues on bug reporter's machine. I found another issue of the BIOS that
sometimes it doesn't really keep the e820 table unchanging for hibernate
resuming, this BIOS issue causes the total available page number checking
fail. I will file another openSUSE bug to separate those 2 issues.

> 
> > Reported-by: "Lee, Chun-Yi" <jlee-IBi9RG/b67k@public.gmane.org>
> > Tested-by: "Lee, Chun-Yi" <jlee-IBi9RG/b67k@public.gmane.org>
> > Cc: "Lee, Chun-Yi" <jlee-IBi9RG/b67k@public.gmane.org>
> > Signed-off-by: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> 
> Hmm, although the bug is reported for a 3.12 kernel, I assume this is for 
> stable 3.10+?  If so, it should apply fine with the exception of removing 
> e820_reserve_setup_data() from setup_arch() rather than 
> memblock_x86_reserve_range_setup_data().  Or is it for 3.2 as well and 
> needs to be completely rebased for that kernel?

Thanks a lot!
Joey Lee
