From: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Subject: Re: [RFC] Second attempt at kernel secure boot support
Date: Tue, 6 Nov 2012 03:12:19 +0000
Message-ID: <20121106031219.GB24235@srcf.ucam.org>
References: <20121104042802.GA11295@srcf.ucam.org>
 <1352020487.2427.5.camel@dabdike.int.hansenpartnership.com>
 <20121104135251.GA17894@srcf.ucam.org>
 <87d2zsmv8r.fsf@xmission.com>
 <509766DB.9090906@zytor.com>
 <87625kh5r2.fsf@xmission.com>
 <20121105123858.GB4374@srcf.ucam.org>
 <87sj8nc137.fsf@xmission.com>
 <20121105202557.GA16076@srcf.ucam.org>
 <87hap3zbw7.fsf@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <87hap3zbw7.fsf-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>, Chris Friesen <chris.friesen-b7o/lNNmKxtBDgjK7y7TUQ@public.gmane.org>, Eric Paris <eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Oliver Neukum <oneukum-l3A5Bk7waGM@public.gmane.org>, Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Josh Boyer <jwboyer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Mon, Nov 05, 2012 at 06:46:32PM -0800, Eric W. Biederman wrote:
> Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org> writes:
> 
> > On Mon, Nov 05, 2012 at 11:16:12AM -0800, Eric W. Biederman wrote:
> >> Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org> writes:
> >> > No, in the general case the system will do that once it fails to find a 
> >> > bootable OS on the drive.
> >> 
> >> In the general case there will be a bootable OS on the drive.
> >
> > That's in no way a given.
> 
> You have it backwards.  The conclusion here is that having a case where
> a non-interactive install is possible is not a given.

I deal with customers who perform non-interactive installs. The fact 
that you don't care about that use case is entirely irrelevant to me, 
because you're not the person that I am obliged to satisfy.

-- 
Matthew Garrett | mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org
