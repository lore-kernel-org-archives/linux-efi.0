From: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] x86_64/efi: Mapping Boot and Runtime EFI memory regions
 to different starting virtual address
Date: Thu, 30 Jul 2015 22:16:01 +0800
Message-ID: <20150730141601.GO15651@linux-rxt1.site>
References: <55B9D806.7030705@zytor.com>
 <20150730080323.GD8984@nazgul.tnic>
 <20150730101131.GB2725@codeblueprint.co.uk>
 <20150730110959.GJ15651@linux-rxt1.site>
 <20150730111819.GK15651@linux-rxt1.site>
 <20150730120916.GD2725@codeblueprint.co.uk>
 <20150730123116.GL15651@linux-rxt1.site>
 <20150730131723.GG2725@codeblueprint.co.uk>
 <20150730133947.GN15651@linux-rxt1.site>
 <20150730140542.GI2725@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150730140542.GI2725-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "Lee, Chun-Yi" <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, Jul 30, 2015 at 03:05:42PM +0100, Matt Fleming wrote:
> On Thu, 30 Jul, at 09:39:47PM, joeyli wrote:
> > 
> > OK, understood! Thanks for your suggestion!
> > 
> > But, I have a question about mapping Boot Code/Data to -4G area. I understand
> > we need Runtime regions, and 1:1 mapping is the workaround of some buggy BIOS.
> > But why should kernel mapping Boot regions to -4G area?
> 
> We map the Boot Service regions in the -4G area for simplicity, i.e.
> it's easier to iterate through the EFI memory map in order, and map
> things starting at -4G and working down to lower addresses, than it
> would be to make different mapping decisions based on the region type.
> 
> As for why we map the Boot Service regions *at all*, that's also a bug
> workaround, see commit 916f676f8dc0 ("x86, efi: Retain boot service code
> until after switching to virtual mode"). We setup the mappings before we
> call efi_free_boot_services().
> 
> -- 
> Matt Fleming, Intel Open Source Technology Center

Thanks for your explanation.

For my issue, I will check if rewriting the VA of runtime services can fix issue.
If not, then I think need find a way to sync the mapping in EFI page table between
boot kernel and image kernel.


Thanks a lot!
Joey Lee
