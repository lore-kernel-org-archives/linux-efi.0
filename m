From: Joseph Thelen <jthelen-sJ/iWh9BUns@public.gmane.org>
Subject: Re: [PATCH] x86/efi: Auto enable EFI memmap on SGI UV systems
Date: Fri, 17 Jun 2016 15:57:19 -0500
Message-ID: <20160617205719.GB285943@stormcage.americas.sgi.com>
References: <1464900635-11957-1-git-send-email-jthelen@sgi.com>
 <1464900635-11957-2-git-send-email-jthelen@sgi.com>
 <20160608123623.GW2658@codeblueprint.co.uk>
 <20160614223448.GC172952@stormcage.americas.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160614223448.GC172952-7ppMa7wkY9tKToyKb8PD+Zs2JHu2awxn0E9HWUfgJXw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linn Crosetto <linn-ZPxbGqLxI0U@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Joseph Thelen <jthelen-sJ/iWh9BUns@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, Jun 14, 2016 at 05:34:49PM -0500, Joseph Thelen wrote:
> We're still reasonably confident we'll need something like this. Although,
> after looking into the stuff you mention, it seems that it should perhaps
> be a bit more sophisticated than just checking if we're on a UV system.
> 
> We'll get back to you after digging into this a bit more and coming
> up with some more specific reasons for the change.
> 
> Thanks,
> 
> Joseph Thelen
>

After investigating a bit more, it seems that this is really only
an issue where people are using older bootloaders/managers and kernels, some
of which are still supported / used by big distros like redhat.

Given that this is, as you've pointed out, either a non-issue or easily
remedied without kernel changes now and in the future, we'll try
talking about it directly with any distro where it's still an issue.

Thanks,

Joseph Thelen
