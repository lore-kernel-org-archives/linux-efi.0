From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH] efi: Disable interrupts around EFI calls, not in the
 epilog/prolog calls
Date: Tue, 10 Mar 2015 13:36:18 +0000
Message-ID: <20150310133618.GB17573@codeblueprint.co.uk>
References: <20150303025804.GA24587@kt-Inspiron-3542>
 <20150303063433.GA30468@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150303063433.GA30468-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Tapasweni Pathak <tapaswenipathak-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Tue, 03 Mar, at 07:34:33AM, Ingo Molnar wrote:
> 
> So why are interrupts disabled around page table operations to begin 
> with? It's not like any of this can execute on two CPUs at once, nor 
> can this be executed from interrupt context.
> 
> So, shouldn't we only protect the EFI calls themselves? If we did that 
> we could save the efi_flags global variable ugliness as well.
> 
> I.e. something like the attached patch. (not tested and all that)

Looks good to me Ingo. I'll run it through the test farm. Thanks!

-- 
Matt Fleming, Intel Open Source Technology Center
