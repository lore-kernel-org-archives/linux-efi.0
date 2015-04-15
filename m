From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH] x86_64/efi: enforce 32 bit address for command line
 buffer
Date: Wed, 15 Apr 2015 21:06:26 +0100
Message-ID: <20150415200626.GG4804@codeblueprint.co.uk>
References: <1429058752-13478-1-git-send-email-roy.franz@linaro.org>
 <20150415131826.GE4804@codeblueprint.co.uk>
 <CAFECyb9oF45aLHPqu91yQ0w-KzkL-2io3SLD8gjtO4q2z+=XyA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAFECyb9oF45aLHPqu91yQ0w-KzkL-2io3SLD8gjtO4q2z+=XyA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wed, 15 Apr, at 11:56:05AM, Roy Franz wrote:
> Yeah, I guess it shouldn't surprise me that there is support for 64
> bit addresses  there :)
> 
> I'l spin another patch that sets boot_params->ext_cmd_line_ptr with
> the upper 32 bits of the address.
> Should I conditionalize this with #ifdef CONFIG_X86_64, or just do it
> unconditionally, with it being a NOP
> on 32 bit?  (I guess I may end up with an extra cast for the 32 bit case)

Unconditionally is best, I'm loathe to introduce #ifdefs unless
absolutely necessary.

Thanks!

-- 
Matt Fleming, Intel Open Source Technology Center
