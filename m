From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH] x86/efi: Always map boot service regions into new EFI
 page tables
Date: Sun, 13 Mar 2016 23:07:36 +0000
Message-ID: <20160313230736.GB2619@codeblueprint.co.uk>
References: <1457695163-29632-1-git-send-email-matt@codeblueprint.co.uk>
 <1457695163-29632-2-git-send-email-matt@codeblueprint.co.uk>
 <1457888975.3884.9.camel@talk21.com>
 <20160313215847.GA2619@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160313215847.GA2619-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Scott Ashcroft <scott.ashcroft-qw6QB7/foO7QT0dZR+AlfA@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Maarten Lankhorst <maarten.lankhorst-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>, Raphael Hertzog <hertzog-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>, Roger Shimizu <rogershimizu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alexis Murzeau <amurzeau-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Sun, 13 Mar, at 09:58:47PM, Matt Fleming wrote:
> (Fixing Maarten's email address which I botched originally)
> 
> On Sun, 13 Mar, at 05:09:35PM, Scott Ashcroft wrote:
> > On Fri, 2016-03-11 at 11:19 +0000, Matt Fleming wrote:
> > > Some machines have EFI regions in page zero (physical address
> > > 0x00000000) and historically that region has been added to the e820
> > > map via trim_bios_range(), and ultimately mapped into the kernel page
> > > tables. It was not mapped via efi_map_regions() as one would expect.
> > > 
> > > Alexis reports that with the new separate EFI page tables some boot
> > > services regions, such as page zero, are not mapped. This triggers an
> > > oops during the SetVirtualAddressMap() runtime call.
> > 
> > 
> > I'm still seeing a failure to boot even with this patch.
> > 
> > http://www.qzxyz.com/IMG_20160313_164601.jpgSorry for the dodgy photo but the screen has almost a mirror finish.
> > 
> > Attached is the dmesg from 4.4 with efi=debug memblock=debug
> 
> Well, crap. Can you enable CONFIG_EFI_PGT_DUMP and send the dmesg
> because it would be good to know how things are mapped before this
> patch.
> 
> I'd be surprised if the issue you're seeing is related to the one that
> Alexis reported. Having corrupt page table structures is a whole new
> bag of scary.
> 
> Does $(grep pdpe1gb /proc/cpuinfo) show any output on your machine?

Assuming the answer to this question is "no", can you try out this
patch?

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 8fee5b6f8f66..af74849e8c0f 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -1055,7 +1055,7 @@ static int populate_pud(struct cpa_data *cpa, unsigned long start, pgd_t *pgd,
 	/*
 	 * Map everything starting from the Gb boundary, possibly with 1G pages
 	 */
-	while (end - start >= PUD_SIZE) {
+	while (cpu_has_gbpages && end - start >= PUD_SIZE) {
 		set_pud(pud, __pud(cpa->pfn << PAGE_SHIFT | _PAGE_PSE |
 				   massage_pgprot(pud_pgprot)));
 
