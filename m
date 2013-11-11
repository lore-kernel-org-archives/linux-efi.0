From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH] efi earlyprintk fix
Date: Mon, 11 Nov 2013 16:13:47 +0000
Message-ID: <20131111161347.GH22636@console-pimps.org>
References: <20131103121647.GA4770@dhcp-16-126.nay.redhat.com>
 <20131104103739.GD21688@console-pimps.org>
 <20131104125853.GB5118@dhcp-16-126.nay.redhat.com>
 <20131106092335.GA3952@dhcp-16-126.nay.redhat.com>
 <20131106093832.GC22856@console-pimps.org>
 <20131107120906.GB4116@dhcp-16-126.nay.redhat.com>
 <20131108103648.GA2318@console-pimps.org>
 <20131109034429.GA4294@dhcp-16-126.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20131109034429.GA4294-je1gSBvt1TcFLmT5oZ11vB/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Sat, 09 Nov, at 11:44:29AM, Dave Young wrote:
> Hi, Matt
> 
> Confirmed, your patch work ok for the pr_cont issue.
 
Excellent, thanks for testing.

> Actually I mixed two problems in my report, one is there's always one blank line
> at the bottom of screen, the other is the pr_cont issue. For the second problem
> change >= to > looks better. For the previous problem still need to move the
> hunk below to the beginning point of early_efi_write function. It just works for me
> but I'm not sure why this is not necessary for other machines. 
> 
> +		if (efi_y + font->height > si->lfb_height) {
> +			u32 i;
> +
> +			efi_y -= font->height;
> +			early_efi_scroll_up();
> +
> +			for (i = 0; i < font->height; i++)
> +				early_efi_clear_scanline(efi_y + i);
> +		}

Dave, unfortunately you're going to need to debug this further because
it doesn't make any sense that your patch is needed, unless there's a
bug in the existing code.

You may also want to rule out that your boot_delay patches are not
inserting delays after printing pr_fmt().

-- 
Matt Fleming, Intel Open Source Technology Center
