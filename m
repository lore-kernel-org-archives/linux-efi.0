From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH] x86/efi: Add EFI framebuffer earlyprintk support
Date: Fri, 11 Oct 2013 15:00:39 +0100
Message-ID: <20131011140039.GF12321@console-pimps.org>
References: <1381423261-30566-1-git-send-email-matt@console-pimps.org>
 <20131010172844.GA26430@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20131010172844.GA26430-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, 10 Oct, at 07:28:44PM, Ingo Molnar wrote:
> Btw., could we perhaps remap the whole framebuffer at init time, or is it 
> too large? If early_ioremap() fails for whatever reason then that will 
> emit a WARN_ON(), which will recurse in a fairly nasty way ...
 
The framebuffer memory will be quite large, so I don't think it makes
sense to map it all this early, because it's likely we'll run out of
fixmap entries.

> > +	if (!dst)
> > +		return;
> > +
> > +	memset(dst, 0, len);
> > +	early_iounmap(dst, len);
> > +}
> > +
> > +static __init void early_efi_clear_screen(void)
> > +{
> > +	struct screen_info *si;
> > +	int y;
> > +
> > +	si = &boot_params.screen_info;
> > +	for (y = 0; y < si->lfb_height; y++)
> > +		early_efi_clear_line(y);
> 
> Looks a bit superfluous to introduce 'si' just for that single use?
 
I did this to reduce the length of the "for (y = 0..." line.

> > +}
> > +
> > +static void early_efi_write_char(void *dst, char c, int h)
> > +{
> > +	const u8 *src;
> > +	u32 fgcolor = 0xaaaaaa;
> 
> That's RGB grey, right? Why not 0xffffff for a very visible white?
 
The VGA earlyprintk code uses the equivalent grey, AFAIK, which is why I
picked this value.

> > +	u8 s8;
> > +	int m;
> > +
> > +	src = font->data + (c * font->height);
> 
> here too the multiplication does not need parantheses.
> 
> > +	s8 = *(src + h);
> 
> We normally only care about the ASCII range, but doesn't 'c' want to be 
> 'unsigned char', to make sure we do the right thing, should anyone use 
> above 0x7f characters in printk, accidentally or intentionally?
 
Yeah, this should be unsigned.

> > +
> > +	for (m = 0; m < 8; m++) {
> > +		u32 val, mask = 0;
> > +
> > +		if ((s8 >> (7 - m)) & 1)
> > +			mask = 0xffffffff;
> > +
> > +		val = mask & fgcolor;
> 
> Hm, because this is really about 32-bit pixel framebuffer, is that mask 
> code a _really_ roundabout way of saying:
> 
> 	const u32 color_grey  = 0x00aaaaaa;
> 	const u32 color_black = 0x00000000;
> 	...
> 
> 		if ((s8 >> (7 - m)) & 1)
> 			pixel = color_grey;
> 		else
> 			pixel = color_black;
> 
> 		*dst = pixel;
> 
> ?
> 
> > +		memcpy(dst, &val, 4);
> 
> Also, why not pass in dst as 'u32 *' and replace the memcpy with:
> 
> 		*dst = val;
> 
> ?
> 
> > +		dst += 4;
> 
> and this with:
> 
> 		dst++;
> 
> ?
 

Yeah, that's a nice cleanup.

 
> > +			}
> > +
> > +			early_iounmap(dst, len);
> > +		}
> > +
> > +		num -= count;
> > +		efi_x += count * font->width;
> > +		str += count;
> > +
> > +		if (num > 0 && *s == '\n') {
> > +			efi_x = 0;
> > +			efi_y += font->height;
> 
> btw., it's a fixed-width, fixed-height font, right?
 
Correct.

> > +			str++;
> > +			num--;
> > +		}
> > +
> > +		if (efi_x >= si->lfb_width) {
> > +			efi_x = 0;
> > +			efi_y += font->height;
> > +		}
> > +
> > +		if (efi_y + font->height >= si->lfb_height) {
> > +			early_efi_clear_screen();
> > +			efi_y = 0;
> 
> So, if I understand it correctly this clears the screen and starts at the 
> top when we scroll off the bottom, right?
> 
> That might make the recovery of oopses hard when the number of log lines 
> is unlucky.
> 
> Would scrolling a few lines up instead, via a well-calculated memcpy and 
> memset be doable?
 
Yeah we can do that. I thought about this originally but decided against
it because I figured it would complicate the code unnecessarily. But it
turned out to be fairly trivial.
 
> > +	if (!font)
> > +		return -ENODEV;
> > +
> > +	early_efi_clear_screen();
> 
> Assuming we implement scrolling above, here too it might make sense to 
> scroll up the framebuffer - if the crash is early enough then some 
> firmware and boot stub info might still be present in the framebuffer?

It's possible that some info will be in the framebuffer, but we can't
begin writing immediately after the boot stub info because we don't know
the last xy coordinates the firmware wrote to.

But yeah, leaving it intact and beginning our output from the last line
of the framebuffer makes more sense than clearing the screen entirely.

-- 
Matt Fleming, Intel Open Source Technology Center
