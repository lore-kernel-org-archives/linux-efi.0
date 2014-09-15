From: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH RFC] x86 early_ioremap: increase FIX_BTMAPS_SLOTS to 8
Date: Sun, 14 Sep 2014 19:42:05 -0700
Message-ID: <20140915024205.GA2561@kroah.com>
References: <20140826090641.GA16550@darkstar.nay.redhat.com>
 <20140914141412.GJ18582@console-pimps.org>
 <20140915023805.GA2700@darkstar.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140915023805.GA2700-4/PLUo9XfK+sDdueE5tM26fLeoKvNuZc@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-E0kO6a4B6psdnm+yROfE0A@public.gmane.org, lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, rafael.j.wysocki-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, robert.moore-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Mon, Sep 15, 2014 at 10:38:05AM +0800, Dave Young wrote:
> On 09/14/14 at 03:14pm, Matt Fleming wrote:
> > On Tue, 26 Aug, at 05:06:41PM, Dave Young wrote:
> > > 3.16 kernel boot fail with earlyprintk=efi, it keeps scrolling at the
> > > bottom line of screen.
> > > 
> > > Bisected, the first bad commit is below:
> > > commit 86dfc6f339886559d80ee0d4bd20fe5ee90450f0
> > > Author: Lv Zheng <lv.zheng-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > > Date:   Fri Apr 4 12:38:57 2014 +0800
> > > 
> > >     ACPICA: Tables: Fix table checksums verification before installation.
> > 
> > [...]
> > 
> > > Quote reply from Lv.zheng about the early ioremap slot usage in this case:
> > > 
> > > """
> > > In early_efi_scroll_up(), 2 mapping entries will be used for the src/dst screen buffer.
> > > In drivers/acpi/acpica/tbutils.c, we've improved the early table loading code in acpi_tb_parse_root_table().
> > > We now need 2 mapping entries:
> > > 1. One mapping entry is used for RSDT table mapping. Each RSDT entry contains an address for another ACPI table.
> > > 2. For each entry in RSDP, we need another mapping entry to map the table to perform necessary check/override before installing it.
> > > 
> > > When acpi_tb_parse_root_table() prints something through EFI earlyprintk console, we'll have 4 mapping entries used.
> > > The current 4 slots setting of early_ioremap() seems to be too small for such a use case.
> > > """
> > > 
> > > Thus increase the slot to 8 in this patch to fix this issue.
> > > boot-time mappings become 512 page with this patch.
> >  
> > This analysis and solution makes sense to me, but I was really hoping
> > for one of the x86 maintainers to ACK the below patch. I'm happy to take
> > it through the EFI tree if it's not picked up into tip meanwhile.
> > 
> > Also, Dave, it sounds like this should be tagged for stable if the bug
> > has been around since v3.16?
> 
> Matt, yes, it should be a stable issue, ccing Greg and stable list.

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>
