From: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] x86_64/efi: Mapping Boot and Runtime EFI memory regions
 to different starting virtual address
Date: Thu, 30 Jul 2015 20:31:16 +0800
Message-ID: <20150730123116.GL15651@linux-rxt1.site>
References: <1438230757-30840-1-git-send-email-jlee@suse.com>
 <55B9D806.7030705@zytor.com>
 <20150730080323.GD8984@nazgul.tnic>
 <20150730101131.GB2725@codeblueprint.co.uk>
 <20150730110959.GJ15651@linux-rxt1.site>
 <20150730111819.GK15651@linux-rxt1.site>
 <20150730120916.GD2725@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150730120916.GD2725-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "Lee, Chun-Yi" <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, Jul 30, 2015 at 01:09:16PM +0100, Matt Fleming wrote:
> On Thu, 30 Jul, at 07:18:19PM, joeyli wrote:
> > 
> > In the above case, just simply accessing EFI variable through efivars to
> > reproduce issue:
> > 
> > linux-aiip:~ # hexdump -C /sys/firmware/efi/efivars/SecureBoot-8be4df61-93ca-11d2-aa0d-00e098032b8c
> > Killed
> > 
> > [  257.856185] BUG: unable to handle kernel paging request at fffffffefd244e60		<=== address is in Runtime Data region
> > [  257.863200] IP: [<ffffffff81457cdd>] virt_efi_get_variable+0x5d/0xa0
> > [  257.869586] PGD 1a0c067 PUD 13b0ae063 PMD 13b0bc063 PTE 0
> > [  257.875056] Oops: 0000 [#1] SMP 
> > [...snip]
> > [  258.149804] RIP  [<ffffffff81457cdd>] virt_efi_get_variable+0x5d/0xa0
> > [  258.156273]  RSP <ffff8800ba07fd78>
> > [  258.159769] CR2: fffffffefd244e60
> > [  258.163090] ---[ end trace 9edb589760c07d3e ]---
> > 
> > 0xfffffffefd244e60 is covered by Runtime Data region after hibernate resumed:  
> > 
> > [    0.125865] efi: mem26: [Runtime Data       |RUN|  |  |  |   |WB|WT|WC|UC] pa=[0x00000000bb3e5000-0x00000000bb445000) va=[0xfffffffefd1e5000-0xfffffffefd245000) (0MB)
> > 										  					     			0xfffffffefd244e60
> > 
> > But this va address didn't mapped to any pa in hibernating kernel (image kernel):
> > 
> > [    0.111002] efi: mem24: [Runtime Code       |RUN|  |  |  |   |WB|WT|WC|UC] pa=[0x00000000bb385000-0x00000000bb3e5000) va=[0xfffffffefd585000-0xfffffffefd5e5000) (0MB)
> > [    0.125883] efi: mem25: [Runtime Data       |RUN|  |  |  |   |WB|WT|WC|UC] pa=[0x00000000bb3e5000-0x00000000bb445000) va=[0xfffffffefd3e5000-0xfffffffefd445000) (0MB)
> > 																                0xfffffffefd244e60	<=== no mapping
> > [    0.140764] efi: mem29: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] pa=[0x00000000bb7ff000-0x00000000bb800000) va=[0xfffffffefd1ff000-0xfffffffefd200000) (0MB)
> > 
> > 
> > So, when call EFI runtime services, got problem.
> 
> Why is the new kernel calling the EFI runtime services via the old
> mappings?
> 
> -- 
> Matt Fleming, Intel Open Source Technology Center

I think hibernate overwrite it.

Joey Lee
