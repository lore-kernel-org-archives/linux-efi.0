From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH 1/5] Add ucs2 -> utf8 helper functions
Date: Mon, 15 Feb 2016 10:15:51 +0000
Message-ID: <20160215101551.GA2591@codeblueprint.co.uk>
References: <1454600074-14854-1-git-send-email-pjones@redhat.com>
 <1454600074-14854-2-git-send-email-pjones@redhat.com>
 <56BDDC95.8030608@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <56BDDC95.8030608-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Laszlo Ersek <lersek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, efi kernel list <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, 12 Feb, at 02:22:29PM, Laszlo Ersek wrote:
> 
> Again, the above two questions don't seem relevant for UEFI
> specifically: first, UEFI is little-endian only; second, UEFI does not
> support surrogate characters -- I found a hint about this in the HII
> chapter of the spec, "31.2.6.2.2 Surrogate Area".
> 
> But since this code is being added to a generic library, the UEFI
> assumptions may not hold for other (future) callers.

We're not generally in the habit of adding code in the kernel to cater
for users that don't exist yet (in this case, non-UEFI), because doing
so pretty much always leads to bit-rot and maintenance headaches down
the line.

If someone wants to use this library in the future for non-UEFI
things, they'll have to make the necessary modifications.
