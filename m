From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH v2] efi: Check for null efi kernel parameters
Date: Thu, 30 Jul 2015 13:30:48 +0100
Message-ID: <20150730123047.GE2725@codeblueprint.co.uk>
References: <1437014163-4652-1-git-send-email-ricardo.neri-calderon@linux.intel.com>
 <20150721092217.GA7361@dhcp-129-220.nay.redhat.com>
 <1437701417.10814.12.camel@ranerica-desk01>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1437701417.10814.12.camel@ranerica-desk01>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ricardo Neri <ricardo.neri-calderon-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Glenn P. Williamson" <glenn.p.williamson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, 23 Jul, at 06:30:17PM, Ricardo Neri wrote:
> > 
> > Ricardo, any reason not change in parse_option_str general function? 
> > I prefer to fix it in parse_option_str, because it is for checking
> > if str contains an option string, if str is NULL then it should 
> > return false.
> 
> Yes, I thought about it as well. I thought that this implementation
> aligns with what the majority of the param functions does. That was the
> main reason. But having this in parse_option_str might seem a better
> alternative if more param functions use it.
> > 
> > But since it is only used in efi code for now so I have no strong opinion.
> 
> Matt, do you have any specific preference?

Yeah, I like Ricardo's patch.

The problem with fixing this in parse_option_str() is that it would be
difficult to distinguish between "str is invalid" and "option wasn't
found in str". You'd have to start inspecting the return value to be
able to print a useful message in the caller, e.g.

	ret = parse_option_str(str, "foobar");
	if (ret == -EINVAL)
		pr_err("No option provided for efi parameter");

	if (ret == -ENOENT)
		return;	/* "foobar" not found */
etc.

Plus there's precedence for checking 'str' for NULL in early_param()
handlers.

-- 
Matt Fleming, Intel Open Source Technology Center
