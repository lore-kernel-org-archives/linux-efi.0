From: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [patch 4/7 v2] export more efi table variable to sysfs
Date: Tue, 12 Nov 2013 00:31:10 -0800
Message-ID: <20131112083110.GA7892@kroah.com>
References: <20131105082007.872550445@dhcp-16-126.nay.redhat.com>
 <20131105082717.561020034@dhcp-16-126.nay.redhat.com>
 <20131112004014.GA15377@kroah.com>
 <20131112081937.GE6999@dhcp-16-126.nay.redhat.com>
 <20131112082401.GA13899@dhcp-16-126.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20131112082401.GA13899-je1gSBvt1TcFLmT5oZ11vB/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, horms-/R6kz+dDXgpPR4JQBCEnsQ@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Tue, Nov 12, 2013 at 04:24:01PM +0800, Dave Young wrote:
> On 11/12/13 at 04:19pm, Dave Young wrote:
> > On 11/11/13 at 04:40pm, Greg KH wrote:
> > > On Tue, Nov 05, 2013 at 04:20:11PM +0800, dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org wrote:
> > > > Export fw_vendor, runtime and config tables physical
> > > > addresses to /sys/firmware/efi/systab becaue kexec
> > > > kernel will need them.
> > > 
> > > sysfs files are one-value-per-file.
> > > 
> > > Please don't abuse this and add more values to this single file, in
> > > fact, it should be broken up into individual sysfs files as it is,
> > > because this isn't ok now.
> > > 
> > > Sorry, you don't get to abuse this anymore :(
> > 
> > Ok, I know this, just creating this without thinking about carefully.
> > Will redo the patch, thanks for catching.
> 
> I would like to add new files for the values used in this patchset.
> And will split the original systab later in another patchset.

That's fine with me, thanks.

greg k-h
