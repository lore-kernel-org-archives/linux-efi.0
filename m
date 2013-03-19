From: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Subject: Re: [PATCH] x86/efi: pull NV+BS variables out before we exit boot
 services
Date: Tue, 19 Mar 2013 17:25:06 +0000
Message-ID: <20130319172506.GA11969@srcf.ucam.org>
References: <1363596014.2412.8.camel@dabdike.int.hansenpartnership.com>
 <20130319014850.GA28934@srcf.ucam.org>
 <1363680885.2377.11.camel@dabdike.int.hansenpartnership.com>
 <20130319163531.GA10879@srcf.ucam.org>
 <1363713447.2377.60.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1363713447.2377.60.camel-sFMDBYUN5F8GjUHQrlYNx2Wm91YjaHnnhRte9Li2A+AAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, Mar 19, 2013 at 05:17:27PM +0000, James Bottomley wrote:
> On Tue, 2013-03-19 at 16:35 +0000, Matthew Garrett wrote:
> > On Tue, Mar 19, 2013 at 08:14:45AM +0000, James Bottomley wrote:
> > 
> > > Any security assumptions that rely on inability to read certain
> > > information aren't really going to be that secure.  Inability to modify,
> > > sure, but inability to read, not really.
> > 
> > Well, I guess that's public/private key cryptography screwed.
> 
> Well, OK, it's ex-BIOS writers we're dealing with, so I won't say no-one
> would be stupid enough to come up with a security scheme embedding
> Private Keys in BS+NV variables, but I would have thought the fact that
> Linux would blow the lid off it might be a good incentive not to do it
> and thus a plus point for this patch.

The hibernation scheme we'd discussed involved having the first stage 
loader generating a keypair and handing half of it to the OS for 
encryption of the hibernation partition, then handing the other half to 
the OS on the next boot so it can decrypt it. That requires non-RT 
variables to be restricted from OS visibility.

-- 
Matthew Garrett | mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org
