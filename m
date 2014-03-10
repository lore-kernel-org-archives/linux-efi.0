From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [patch] x86/efi: use GFP_ATOMIC under spin_lock
Date: Mon, 10 Mar 2014 20:07:43 +0300
Message-ID: <20140310170743.GS4774@mwanda>
References: <20140307112055.GE2351@elgon.mountain>
 <20140307121022.GA32575@gmail.com>
 <20140307122103.GM4774@mwanda>
 <20140309161946.GA10262@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140309161946.GA10262@console-pimps.org>
Sender: kernel-janitors-owner@vger.kernel.org
To: Matt Fleming <matt@console-pimps.org>
Cc: Ingo Molnar <mingo@kernel.org>, Matt Fleming <matt.fleming@intel.com>, Nathan Zimmer <nzimmer@sgi.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, linux-efi@vger.kernel.org, kernel-janitors@vger.kernel.org, Matthew Garrett <mjg59@srcf.ucam.org>, Jan Beulich <JBeulich@suse.com>
List-Id: linux-efi@vger.kernel.org

On Sun, Mar 09, 2014 at 04:20:20PM +0000, Matt Fleming wrote:
> On Fri, 07 Mar, at 03:25:37PM, Dan Carpenter wrote:
> > 
> > You're on your own for fixing the complicated stuff like layering
> > violations. I just do static checker stuff and sed fixes.  ;)
> 
> Thanks for the patch Dan. Nice catch.
> 
> But I'm wondering if we can simply delete phys_efi_get_time() to avoid
> the whole problem of doing GFP_KERNEL allocations under a spinlock.
> 
> In fact, the whole EFI time stuff is looking a bit crusty.
> 
> I only see two direct users of efi.get_time() outside of arch,
> 
>   drivers/char/efirtc.c
>   drivers/rtc/rtc-efi.c
> 
> which are both "depends on IA64". For x86, all other callers are inside
> arch/x86/platform/efi/efi.c,
> 
>   efi_set_rtc_mmss()
>   efi_get_time()
> 
> neither of which have any callers - it all appears to be dead code. The
> diff stat of deleting all this dead code isn't too bad either,
> 
>  arch/x86/platform/efi/efi.c    | 151 ++---------------------------------------
>  arch/x86/platform/efi/efi_64.c |  90 ------------------------
>  2 files changed, 5 insertions(+), 236 deletions(-)
> 
> Thoughts?

I don't have strong opinions on this, this was just a static checker
thing, and I don't know the code.

regards,
dan carpenter

