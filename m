From: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Subject: Re: [RFC] Second attempt at kernel secure boot support
Date: Sun, 4 Nov 2012 04:28:02 +0000
Message-ID: <20121104042802.GA11295@srcf.ucam.org>
References: <20121102165456.GB9997@srcf.ucam.org>
 <1351878511.2439.44.camel@dabdike.int.hansenpartnership.com>
 <20121102175416.GA11816@srcf.ucam.org>
 <1351879058.2439.46.camel@dabdike.int.hansenpartnership.com>
 <20121102180458.GA12052@srcf.ucam.org>
 <1351899503.2439.49.camel@dabdike.int.hansenpartnership.com>
 <20121103002244.GC18691@srcf.ucam.org>
 <1351944236.2417.7.camel@dabdike.int.hansenpartnership.com>
 <20121103134630.GA28166@srcf.ucam.org>
 <1351983400.2417.21.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1351983400.2417.21.camel-sFMDBYUN5F8GjUHQrlYNx2Wm91YjaHnnhRte9Li2A+AAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>, Chris Friesen <chris.friesen-b7o/lNNmKxtBDgjK7y7TUQ@public.gmane.org>, Eric Paris <eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Oliver Neukum <oneukum-l3A5Bk7waGM@public.gmane.org>, Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Josh Boyer <jwboyer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Sat, Nov 03, 2012 at 10:56:40PM +0000, James Bottomley wrote:
> On Sat, 2012-11-03 at 13:46 +0000, Matthew Garrett wrote:
> > I... what? Our signed bootloader will boot our signed kernel without any 
> > physically present end-user involvement. We therefore need to make it 
> > as difficult as practically possible for an attacker to use our signed 
> > bootloader and our signed kernel as an attack vector against other 
> > operating systems, which includes worrying about hibernate and kexec. If 
> > people want to support this use case then patches to deal with that need 
> > to be present in the upstream kernel.
> 
> Right, but what I'm telling you is that by deciding to allow automatic
> first boot, you're causing the windows attack vector problem.  You could
> easily do a present user test only on first boot which would eliminate
> it.  Instead, we get all of this.

Your definition of "Best practices" is "Automated installs are 
impossible"? Have you ever actually spoken to a user?

-- 
Matthew Garrett | mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org
