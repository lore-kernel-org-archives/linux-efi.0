From: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Subject: Re: [PATCH] x86/efi: pull NV+BS variables out before we exit boot
 services
Date: Tue, 19 Mar 2013 01:48:50 +0000
Message-ID: <20130319014850.GA28934@srcf.ucam.org>
References: <1363596014.2412.8.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1363596014.2412.8.camel-sFMDBYUN5F8GjUHQrlYNx2Wm91YjaHnnhRte9Li2A+AAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Mar 18, 2013 at 08:40:14AM +0000, James Bottomley wrote:

> The object here is to make the NV+BS variables accessible (at least read only)
> at runtime so we can get a full picture of the state of the EFI variables for
> debugging and secure boot purposes.

I'd really prefer not to do this - the reason these aren't flagged as RT 
is that they're not supposed to be visible at runtime and may break 
certain security assumptions. If there's a real development purpose to 
this then it ought to be guarded as a config option.

-- 
Matthew Garrett | mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org
