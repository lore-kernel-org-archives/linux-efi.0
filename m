From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH 1/2] efi: Provide a non-blocking SetVariable() operation
Date: Wed, 1 Oct 2014 17:11:51 +0100
Message-ID: <20141001161151.GD14343@console-pimps.org>
References: <1412165200-32141-1-git-send-email-matt@console-pimps.org>
 <1412165200-32141-2-git-send-email-matt@console-pimps.org>
 <20141001152624.GB2843@worktop.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20141001152624.GB2843-IIpfhp3q70z/8w/KjCw3T+5/BudmfyzbbVWyRVo5IupeoWH0uzbU5w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, 01 Oct, at 05:26:24PM, Peter Zijlstra wrote:
> 
> If you want to have this usable from NMI context, you need to convert
> efi_runtime_lock to a raw_spinlock_t.
 
Hmm.. I note that none of the spinlocks in the pstore code path that we
execute to get here are raw_spinlock_t. And that's the only code path
that calls this function.

They need to be raw_spinlock_t for -rt?

> Also, it would probably be a good idea to have some selftest like thing
> that actually calls this from NMI context, right?

Yeah probably, although that'd need to be a core pstore test since
there's nothing really interesting going on in
virt_efi_set_variable_nonblocking(), and it would be good to test it out
in the larger pstore context.

-- 
Matt Fleming, Intel Open Source Technology Center
