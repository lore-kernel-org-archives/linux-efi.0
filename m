From: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Subject: Re: [PATCH] x86/efi: pull NV+BS variables out before we exit boot
 services
Date: Wed, 20 Mar 2013 11:47:45 +0000
Message-ID: <20130320114745.GA448@srcf.ucam.org>
References: <20130319163531.GA10879@srcf.ucam.org>
 <1363713447.2377.60.camel@dabdike.int.hansenpartnership.com>
 <20130319172506.GA11969@srcf.ucam.org>
 <1363717411.2377.68.camel@dabdike.int.hansenpartnership.com>
 <20130319182810.GA13003@srcf.ucam.org>
 <1363718456.2377.71.camel@dabdike.int.hansenpartnership.com>
 <20130319185003.GA13301@srcf.ucam.org>
 <1363734031.2377.77.camel@dabdike.int.hansenpartnership.com>
 <20130319231756.GA21071@srcf.ucam.org>
 <1363766403.2373.3.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1363766403.2373.3.camel-sFMDBYUN5F8GjUHQrlYNx2Wm91YjaHnnhRte9Li2A+AAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Mar 20, 2013 at 08:00:03AM +0000, James Bottomley wrote:

> I agree with this.  But I do think the volatile secret key scheme, where
> you discard the key immediately after use is the more secure one because
> it relies on fewer secrets (and, indeed, no secrets at all after the
> event).  It's a case where transparency encourages better security
> architecture.

That somewhat depends what you're securing against. There's an argument 
that reusing this key is actually sufficiently secure so long as the 
only way to obtain it is with physical access to the machine - that way 
you don't have an nvram update cycle every boot. Exposing these 
variables to userspace doesn't make it impossible to produce a secure 
system, but it does remove some choices that were previously available.

-- 
Matthew Garrett | mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org
