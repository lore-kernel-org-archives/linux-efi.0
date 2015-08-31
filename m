From: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] efifb: Add support for 64-bit frame buffer addresses
Date: Mon, 31 Aug 2015 11:23:31 -0400
Message-ID: <20150831152330.GC17921@redhat.com>
References: <1440763939-17027-1-git-send-email-matt@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1440763939-17027-1-git-send-email-matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fbdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Pete Hawkins <pete.hawkins-ZTdz3wlHnvg@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Chad Page <chad.page-ZTdz3wlHnvg@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, Aug 28, 2015 at 01:12:19PM +0100, Matt Fleming wrote:
> From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> The EFI Graphics Output Protocol uses 64-bit frame buffer addresses
> but these get truncated to 32-bit by the EFI boot stub when storing
> the address in the 'lfb_base' field of 'struct screen_info'.
> 
> Add a 'ext_lfb_base' field for the upper 32-bits of the frame buffer
> address and set VIDEO_TYPE_CAPABILITY_64BIT_BASE when the field is
> useable.
> 
> It turns out that the reason no one has required this support so far
> is that there's actually code in tianocore to "downgrade" PCI
> resources that have option ROMs and 64-bit BARS from 64-bit to 32-bit
> to cope with legacy option ROMs that can't handle 64-bit addresses.
> The upshot is that basically all GOP devices in the wild use a 32-bit
> frame buffer address.
> 
> Still, it is possible to build firmware that uses a full 64-bit GOP
> frame buffer address. Chad did, which led to him reporting this issue.
> 
> Add support in anticipation of GOP devices using 64-bit addresses more
> widely, and so that efifb works out of the box when that happens.
> 
> Reported-by: Chad Page <chad.page-ZTdz3wlHnvg@public.gmane.org>
> Cc: Pete Hawkins <pete.hawkins-ZTdz3wlHnvg@public.gmane.org>
> Cc: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
> Signed-off-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Looks good to me.

Acked-by: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

-- 
        Peter
