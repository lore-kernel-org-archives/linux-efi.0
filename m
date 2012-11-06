From: Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC] Second attempt at kernel secure boot support
Date: Tue, 6 Nov 2012 13:17:44 +0000
Message-ID: <20121106131743.GB1818@srcf.ucam.org>
References: <509766DB.9090906@zytor.com>
 <87625kh5r2.fsf@xmission.com>
 <20121105123858.GB4374@srcf.ucam.org>
 <87sj8nc137.fsf@xmission.com>
 <20121105202557.GA16076@srcf.ucam.org>
 <87hap3zbw7.fsf@xmission.com>
 <20121106031219.GB24235@srcf.ucam.org>
 <87fw4nv1vj.fsf@xmission.com>
 <20121106035352.GA24698@srcf.ucam.org>
 <20121106091217.4a5240f0@pyramind.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20121106091217.4a5240f0-38n7/U1jhRXW96NNrWNlrekiAK3p4hvP@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>
Cc: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>, Chris Friesen <chris.friesen-b7o/lNNmKxtBDgjK7y7TUQ@public.gmane.org>, Eric Paris <eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Oliver Neukum <oneukum-l3A5Bk7waGM@public.gmane.org>, Josh Boyer <jwboyer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Tue, Nov 06, 2012 at 09:12:17AM +0000, Alan Cox wrote:
> - is it worth Red Hat doing - that's up to Red Hat's business managers
> 
> - is it worth merging into the kernel - that's not
> 
> The capability bit is small and clean the rest of it is beginning to look
> far too ugly for upstream right now. Not to say it might not end up small
> and clean in the end.

I absolutely agree - the code has to be good enough to be accepted 
upstream and I've no objection to being told that better implementations 
must be produced. I do object to being told that there's no point in 
trying to find an acceptable implementation.

-- 
Matthew Garrett | mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org
