From: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: EFI mode after running kexec
Date: Fri, 30 Aug 2013 21:59:58 -0700
Message-ID: <20130831045958.GA10046@kroah.com>
References: <20130829022632.GA26862@kroah.com>
 <CA+5PVA7jec5DAxgKachkBw1VFobz4rVMQwcqzYQ7ynk7=+d+zg@mail.gmail.com>
 <1377779723.2223.105.camel@dabdike>
 <20130829192001.GB11624@kroah.com>
 <5220CBEE.20706@zytor.com>
 <20130831045244.GA12617@x1.alien8.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130831045244.GA12617-W2mmg7yuTz0QF/eBCRgRTA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Josh Boyer <jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Sat, Aug 31, 2013 at 06:52:44AM +0200, Borislav Petkov wrote:
> On Fri, Aug 30, 2013 at 09:44:30AM -0700, H. Peter Anvin wrote:
> > I and Borislav actually came up with a reasonable solution for SVAM().
> > It sadly creates a new ABI, but at least is (a) reasonable and (b)
> > seems to match Windows close enough. Basically the regions should get
> > mapped one by one from -4 GB downwards.
> 
> Yep, and the mapping works both on OVMF and on my baremetal box. I'm
> currently on vacation but will send out the final stuff when I get back.
> 
> Teaching the kexec-ed kernel to simply use those mappings *without*
> doing SVAM() should be easy afterwards.

Ah, that sounds great, if you need me to test anything, just let me
know, I have some UEFI test boxes I've been working on here...

thanks,

greg k-h
