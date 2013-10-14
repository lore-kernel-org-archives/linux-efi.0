From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH v2 2/2] x86/efi: Add EFI framebuffer earlyprintk support
Date: Mon, 14 Oct 2013 06:08:20 +0100
Message-ID: <20131014050820.GK12321@console-pimps.org>
References: <1381502037-22225-1-git-send-email-matt@console-pimps.org>
 <1381502037-22225-3-git-send-email-matt@console-pimps.org>
 <20131012175615.GB18849@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20131012175615.GB18849-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Sat, 12 Oct, at 07:56:15PM, Ingo Molnar wrote:
> > +static void early_efi_write_char(u32 *dst, unsigned char c, unsigned int h)
> > +{
> > +	const u32 color_black = 0x00000000;
> > +	const u32 color_grey = 0x00aaaaaa;
> 
> I still think this should be white - that should be more visible than 
> grey, especially in brightly lit places. (And I'm really sorry about nerds 
> in the basement getting eye damage.)
> 
> Also, what is the highest byte typically, can that ever be part of 
> multiple framebuffers and can it mean an alpha channel? If yes then '0x00' 
> (read: fully translucent) might not be the best of choices for console 
> output. In that case -1 (0xffffffff) would work in a natural way.
> 
> (If it's reserved bits then it has to be all zeroes.)

The GOP part of the spec says that the top byte is reserved, and must be
set to zero, and looking at the efifb driver it disables transparency
support when allocating the color map,

int fb_alloc_cmap(struct fb_cmap *cmap, int len, int transp)

[...]

	if ((err = fb_alloc_cmap(&info->cmap, 256, 0)) < 0) {
		printk(KERN_ERR "efifb: cannot allocate colormap\n");
		goto err_unmap;
	}


-- 
Matt Fleming, Intel Open Source Technology Center
