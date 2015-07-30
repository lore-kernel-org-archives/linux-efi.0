From: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] x86_64/efi: Mapping Boot and Runtime EFI memory regions
 to different starting virtual address
Date: Thu, 30 Jul 2015 21:39:47 +0800
Message-ID: <20150730133947.GN15651@linux-rxt1.site>
References: <1438230757-30840-1-git-send-email-jlee@suse.com>
 <55B9D806.7030705@zytor.com>
 <20150730080323.GD8984@nazgul.tnic>
 <20150730101131.GB2725@codeblueprint.co.uk>
 <20150730110959.GJ15651@linux-rxt1.site>
 <20150730111819.GK15651@linux-rxt1.site>
 <20150730120916.GD2725@codeblueprint.co.uk>
 <20150730123116.GL15651@linux-rxt1.site>
 <20150730131723.GG2725@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150730131723.GG2725-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "Lee, Chun-Yi" <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, Jul 30, 2015 at 02:17:23PM +0100, Matt Fleming wrote:
> On Thu, 30 Jul, at 08:31:16PM, joeyli wrote:
> > 
> > I think hibernate overwrite it.
> 
> We absolutely must get a more detailed answer before going any further.
> 
> Simply put, if we're remapping the EFI regions into the virtual address
> space and calling SetVirtualAddressMap() on hibernate resume there is no
> reason that anyone should be using the old mappings.
> 
> And since you've demonstrated that we *are* using the old mappings,
> we've likely got a bug somewhere that we need to get a handle on before
> we paper over the issue.
> 
> Where exactly is the old mapping address being used? Is it that
> efi.systab->runtime->get_variable is incorrect? If you could paste the
> disassembled output where the page fault occurs, that would be helpful.
> 
> -- 
> Matt Fleming, Intel Open Source Technology Center

OK, understood! Thanks for your suggestion!

But, I have a question about mapping Boot Code/Data to -4G area. I understand
we need Runtime regions, and 1:1 mapping is the workaround of some buggy BIOS.
But why should kernel mapping Boot regions to -4G area?


Thanks a lot!
Joey Lee
