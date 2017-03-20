From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: kexec regression since 4.9 caused by efi
Date: Mon, 20 Mar 2017 10:14:12 +0800
Message-ID: <20170320021412.GA3793@dhcp-128-65.nay.redhat.com>
References: <20170308201616.GC8598@vader>
 <20170309063806.GB17257@dhcp-128-65.nay.redhat.com>
 <20170309095408.GA17883@vader>
 <20170313073748.GA6332@dhcp-128-65.nay.redhat.com>
 <20170316124132.GF6261@codeblueprint.co.uk>
 <20170317020951.GA3942@dhcp-128-65.nay.redhat.com>
 <20170317133232.GI6261@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170317133232.GI6261-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Omar Sandoval <osandov-nWWhXC5lh1RBDgjK7y7TUQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 03/17/17 at 01:32pm, Matt Fleming wrote:
> On Fri, 17 Mar, at 10:09:51AM, Dave Young wrote:
> > 
> > Matt, I think it should be fine although I think the md type checking in
> > efi_mem_desc_lookup() is causing confusion and not easy to understand..
>  
> Could you make that a separate patch if you think of improvements
> there?

Duplicate the lookup function is indeed a little ugly, will do it when I
have a better idea, we can leave it as is since it works.

> 
> > How about move the if chunk early like below because it seems no need
> > to sanity check the addr + size any more if the md is still RUNTIME?
> 
> My original version did as you suggest, but I changed it because we
> *really* want to know if someone tries to reserve a range that spans
> regions. That would be totally unexpected and a warning about a
> potential bug/issue.

Matt, I'm fine if you prefer to capture the range checking errors.
Would you like me to post it or just you send it out?

Thanks
Dave
