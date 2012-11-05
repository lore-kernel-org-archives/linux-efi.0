From: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Subject: Re: [RFC] Second attempt at kernel secure boot support
Date: Mon, 5 Nov 2012 12:36:38 +0000
Message-ID: <20121105123638.GA4374@srcf.ucam.org>
References: <20121102180458.GA12052@srcf.ucam.org>
 <1351899503.2439.49.camel@dabdike.int.hansenpartnership.com>
 <20121103002244.GC18691@srcf.ucam.org>
 <1351944236.2417.7.camel@dabdike.int.hansenpartnership.com>
 <20121103134630.GA28166@srcf.ucam.org>
 <1351983400.2417.21.camel@dabdike.int.hansenpartnership.com>
 <20121104042802.GA11295@srcf.ucam.org>
 <1352020487.2427.5.camel@dabdike.int.hansenpartnership.com>
 <20121104135251.GA17894@srcf.ucam.org>
 <1352103617.2456.3.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1352103617.2456.3.camel@dabdike>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>, Chris Friesen <chris.friesen-b7o/lNNmKxtBDgjK7y7TUQ@public.gmane.org>, Eric Paris <eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Oliver Neukum <oneukum-l3A5Bk7waGM@public.gmane.org>, Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Josh Boyer <jwboyer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Mon, Nov 05, 2012 at 09:20:17AM +0100, James Bottomley wrote:
> On Sun, 2012-11-04 at 13:52 +0000, Matthew Garrett wrote:
> > You don't get to punt on making the kernel secure by simply asserting 
> > that some other system can be secure instead. The chain of trust needs 
> > to go all the way back - if your security model is based on all installs 
> > needing a physically present end user, all installs need a physically 
> > present end user. That's not acceptable, so we need a different security 
> > model.
> 
> I didn't.  I advocated a simple security model which you asserted
> wouldn't allow unattended installs, so I explained how they could be
> done.  

You've explained that a hypothetical piece of software could handle key 
provisioning without providing any explanation for how it would be able 
to do so in a secure manner.

-- 
Matthew Garrett | mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org
