From: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Subject: Re: [patch 1/3 v2] Add function get_bootparam
Date: Mon, 11 Nov 2013 23:58:31 -0800
Message-ID: <20131112075831.GA6213@kroah.com>
References: <20131105082947.500512312@dhcp-16-126.nay.redhat.com>
 <20131105083428.411624560@dhcp-16-126.nay.redhat.com>
 <1384219658.1847.84.camel@misato.fc.hp.com>
 <52819E71.70201@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <52819E71.70201-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Toshi Kani <toshi.kani-VXdhtT5mjnY@public.gmane.org>, dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, horms-/R6kz+dDXgpPR4JQBCEnsQ@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Nov 11, 2013 at 07:20:17PM -0800, H. Peter Anvin wrote:
> On 11/11/2013 05:27 PM, Toshi Kani wrote:
> > On Tue, 2013-11-05 at 16:29 +0800, dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org wrote:
> >> Not only setup_subarch will get data from debugfs file
> >> boot_params/data, later code for adding efi_info will
> >> also need do same thing. Thus add a common function here
> >> for later use.
> > 
> > get_bootparam() calls find_mnt_by_fsname("debugfs"), which assumes that
> > debugfs is mounted with device name "debugfs".  This function fails
> > when:
> >  - debugfs is not mounted, or
> >  - debugfs is mounted with a different device name, such as nodev [1].
> > 
> > This issue is not introduced by this patch.  But the original code,
> > which sets hardware_subarch, seems to work even if it failed to access
> > debugfs (which is ignored) since hardware_subarch is zero most of the
> > cases anyway.  With this change, however, this failure now makes the 2nd
> > kernel unbootable.  So, it needs to be addressed to make this code path
> > work reliably (or kexec should fail at least).
> > 
> 
> Greg, Ingo,
> 
> Since there is now a legitimate user of this stuff, can we actually
> export this in sysfs (or something else other than sploit^Wdebugfs)?

Hey, after Tejun is done with the kernelfs work, I'll be porting debugfs
to it so you can't call it sploitfs anymore :)

> kexec-tools can have a fallback to debugfs if we really need it, but
> making people mount debugfs to have some essential piece of
> functionality scares the heck out of me.

I agree, that would not be good.

I'm not sure what exactly the sysfs file is wanting to look like?  The
efi section variable sysfs file isn't ok (multiple lines with multiple
values.)  What is this going to look like?

thanks,

greg k-h
