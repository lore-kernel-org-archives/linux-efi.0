From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH] x86, eboot: Support initrd loaded above 4G
Date: Fri, 11 Jul 2014 08:40:29 +0100
Message-ID: <20140711074029.GD5952@console-pimps.org>
References: <1402773821-15995-1-git-send-email-yinghai@kernel.org>
 <20140618142819.GN24049@console-pimps.org>
 <20140709182651.GB15932@console-pimps.org>
 <CAE9FiQVP6d5GhFBBmX5HDo0w0oKJSizdKvepq5t6vhGNj=W9sg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAE9FiQVP6d5GhFBBmX5HDo0w0oKJSizdKvepq5t6vhGNj=W9sg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, 10 Jul, at 11:00:06AM, Yinghai Lu wrote:
> 
> Oh, no.
> 
> so efi could allocate buffer above 4g but can not access it?

I'm not exactly sure what's wrong with the buffer - whether it's a case
of not being able to access it properly or somehing buggy in the EFI
code for reading files. No fault occurs when reading into it, it just
doesn't contain the correct data.

Either way, I'm going to leave your patch as-is and just ensure I fix
this before the merge window. I think it's a good idea to have whatever
workaround we come up with documented via an entirely separate patch.

-- 
Matt Fleming, Intel Open Source Technology Center
