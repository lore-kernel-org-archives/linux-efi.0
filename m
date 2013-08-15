From: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Subject: Re: RFC: default CONFIG_EFI_STUB=y
Date: Thu, 15 Aug 2013 06:15:09 +0100
Message-ID: <20130815051509.GB1933@srcf.ucam.org>
References: <52050985.9070107@zytor.com>
 <1376062345.2087.16.camel@dabdike.int.hansenpartnership.com>
 <52050D03.4030805@zytor.com>
 <520A7B48.3020304@zytor.com>
 <1376419410.3467.67.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1376419410.3467.67.camel-sFMDBYUN5F8GjUHQrlYNx2Wm91YjaHnnhRte9Li2A+AAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, Aug 13, 2013 at 11:43:30AM -0700, James Bottomley wrote:

> Can we actually boot a 32 bit kernel on an EFI64 system?  The last time
> I tried on my Secure Boot SDV it wouldn't work; the problem is getting
> someting in the transfer of control path to boot the processor back to
> 32 bit mode.

In theory, as long as you jump to the 32-bit entry point having already 
set the cpu to that mode. The linux command in grub2 ought to do that.

-- 
Matthew Garrett | mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org
