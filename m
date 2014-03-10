From: "Jan Beulich" <JBeulich@suse.com>
Subject: Re: [patch] x86/efi: use GFP_ATOMIC under spin_lock
Date: Mon, 10 Mar 2014 07:26:13 +0000
Message-ID: <531D7725020000780012230A@nat28.tlf.novell.com>
References: <20140307112055.GE2351@elgon.mountain>
 <20140307121022.GA32575@gmail.com> <20140307122103.GM4774@mwanda>
 <20140309161946.GA10262@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20140309161946.GA10262@console-pimps.org>
Content-Disposition: inline
Sender: kernel-janitors-owner@vger.kernel.org
To: Matt Fleming <matt@console-pimps.org>
Cc: Matt Fleming <matt.fleming@intel.com>, Ingo Molnar <mingo@kernel.org>, x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>, Dan Carpenter <dan.carpenter@oracle.com>, Ingo Molnar <mingo@redhat.com>, Nathan Zimmer <nzimmer@sgi.com>, Matthew Garrett <mjg59@srcf.ucam.org>, kernel-janitors@vger.kernel.org, linux-efi@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
List-Id: linux-efi@vger.kernel.org

>>> On 09.03.14 at 17:20, Matt Fleming <matt@console-pimps.org> wrote:
> On Fri, 07 Mar, at 03:25:37PM, Dan Carpenter wrote:
>> 
>> You're on your own for fixing the complicated stuff like layering
>> violations. I just do static checker stuff and sed fixes.  ;)
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
> which are both "depends on IA64".

And wrongly so. I continue to think that the fact that various
firmware implementations are broken should not make us by
default avoid using proper abstraction functionality whenever
possible. There's a reason behind that abstraction after all...

> For x86, all other callers are inside
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

Please don't, except perhaps for the phys_efi_get_time() removal.

Jan

