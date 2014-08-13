From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH] firmware: Do not use WARN_ON(!spin_is_locked())
Date: Wed, 13 Aug 2014 16:02:01 +0100
Message-ID: <20140813150201.GT15082@console-pimps.org>
References: <1407729253-31341-1-git-send-email-linux@roeck-us.net>
 <20140813141836.GQ15082@console-pimps.org>
 <53EB7831.4080306@roeck-us.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <53EB7831.4080306-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, 13 Aug, at 07:37:37AM, Guenter Roeck wrote:
> 
> WARN_ON and WARN_ON_SMP are unconditional. lockdep_assert_held()
> is only active if lockdep debugging is enabled. Not knowing the code,
> nor the reason why the unconditional method was chosen, I prefer
> to refrain from functional changes and limit myself to bug fixes.
 
As the author of that code, I feel confident telling you that the
unconditional method was used because the author is a boob. The code
isn't so important that we need to unconditionally check the locks, and
indeed it's possible to run into all sorts of problems when you don't
use the standard lock-checking functions - the non-SMP crash being a
good example.

> Also, if and how the code can be optimized is another question,
> which in my opinion should be separate from a bug fix.
> 
> Anyway, this specific bug doesn't affect me at this time;
> I only noticed the problem since mainline currently crashes
> on several non-SMP platforms due to the same problem. So
> I don't mind if this patch is not or not immediately applied
> until the discussion about how to best fix it is complete.

Would you mind sending a patch swapping WARN_ON(!spin_is_locked()) for
lockdep_assert_held() ? That's still a bug fix (and your non-SMP
breakage rationale still makes sense), but I think it's a more
preferable fix.

-- 
Matt Fleming, Intel Open Source Technology Center
