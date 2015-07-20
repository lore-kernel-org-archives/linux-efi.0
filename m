From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] efi: Check for null efi kernel parameters
Date: Mon, 20 Jul 2015 17:34:01 +0800
Message-ID: <20150720093401.GA9763@dhcp-129-220.nay.redhat.com>
References: <1435706013-20375-1-git-send-email-ricardo.neri-calderon@linux.intel.com>
 <20150701131919.GK28334@codeblueprint.co.uk>
 <1435772254.1784.40.camel@ranerica-desk01>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1435772254.1784.40.camel@ranerica-desk01>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ricardo Neri <ricardo.neri-calderon-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Glenn P. Williamson" <glenn.p.williamson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Matt/Ricardo, thanks for ccing me, and sorry for late response I thought
to reply but I was busy on other things..

On 07/01/15 at 10:37am, Ricardo Neri wrote:
> On Wed, 2015-07-01 at 14:19 +0100, Matt Fleming wrote:
> > Did you hit this by passing "efi=" on the kernel command line?
> 
> I hit this by passing "efi" alone. "efi=" works well because the pointer
> points to a valid string that only contains \0.
> > 
> > I would have assumed that the generic early param parsing code would
> > have caught this problem since it's obviously a potential issue for
> > every other early_param() function, and so needs to be solved in a
> > more
> > general way.
> 
> Yes, I was dubious on where to apply the patch. I saw that
> parse_option_str does not check for the validity of the pointers. That
> might seem to be a more general fix. I'll take that route.

Ricardo, I agree to fix it in parse_option_str. Do you have sent any
update ?

Thanks
Dave
