From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [PATCH] x86/efi: pull NV+BS variables out before we exit boot
 services
Date: Tue, 19 Mar 2013 08:14:45 +0000
Message-ID: <1363680885.2377.11.camel@dabdike.int.hansenpartnership.com>
References: <1363596014.2412.8.camel@dabdike.int.hansenpartnership.com>
	 <20130319014850.GA28934@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130319014850.GA28934-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, 2013-03-19 at 01:48 +0000, Matthew Garrett wrote:
> On Mon, Mar 18, 2013 at 08:40:14AM +0000, James Bottomley wrote:
> 
> > The object here is to make the NV+BS variables accessible (at least read only)
> > at runtime so we can get a full picture of the state of the EFI variables for
> > debugging and secure boot purposes.
> 
> I'd really prefer not to do this - the reason these aren't flagged as RT 
> is that they're not supposed to be visible at runtime and may break 
> certain security assumptions.

I suppose they could be flagged as read only by root, but I haven't seen
anything non-innocuous in them yet.  It's mostly shell redirects and a
bit more useful information about the secure boot configuration.

Any security assumptions that rely on inability to read certain
information aren't really going to be that secure.  Inability to modify,
sure, but inability to read, not really.

>  If there's a real development purpose to 
> this then it ought to be guarded as a config option.

I've no objection to them going under the secure boot lockdown config
option if that's what you're thinking.

James
