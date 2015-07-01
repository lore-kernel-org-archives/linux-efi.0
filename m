From: Ricardo Neri <ricardo.neri-calderon-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH] efi: Check for null efi kernel parameters
Date: Wed, 01 Jul 2015 10:37:34 -0700
Message-ID: <1435772254.1784.40.camel@ranerica-desk01>
References: <1435706013-20375-1-git-send-email-ricardo.neri-calderon@linux.intel.com>
	 <20150701131919.GK28334@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150701131919.GK28334-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Glenn P. Williamson" <glenn.p.williamson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, 2015-07-01 at 14:19 +0100, Matt Fleming wrote:
> Did you hit this by passing "efi=" on the kernel command line?

I hit this by passing "efi" alone. "efi=" works well because the pointer
points to a valid string that only contains \0.
> 
> I would have assumed that the generic early param parsing code would
> have caught this problem since it's obviously a potential issue for
> every other early_param() function, and so needs to be solved in a
> more
> general way.

Yes, I was dubious on where to apply the patch. I saw that
parse_option_str does not check for the validity of the pointers. That
might seem to be a more general fix. I'll take that route.

Thanks and BR,
Ricardo
