From: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
Subject: Re: [PATCH] firmware: Do not use WARN_ON(!spin_is_locked())
Date: Wed, 13 Aug 2014 19:31:58 -0400
Message-ID: <20140813233158.GB10808@thunk.org>
References: <1407729253-31341-1-git-send-email-linux@roeck-us.net>
 <20140813141836.GQ15082@console-pimps.org>
 <53EB7831.4080306@roeck-us.net>
 <20140813150201.GT15082@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140813150201.GT15082-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Aug 13, 2014 at 04:02:01PM +0100, Matt Fleming wrote:
> On Wed, 13 Aug, at 07:37:37AM, Guenter Roeck wrote:
> > 
> > WARN_ON and WARN_ON_SMP are unconditional. lockdep_assert_held()
> > is only active if lockdep debugging is enabled. Not knowing the code,
> > nor the reason why the unconditional method was chosen, I prefer
> > to refrain from functional changes and limit myself to bug fixes.
>  
> As the author of that code, I feel confident telling you that the
> unconditional method was used because the author is a boob. The code
> isn't so important that we need to unconditionally check the locks, and
> indeed it's possible to run into all sorts of problems when you don't
> use the standard lock-checking functions - the non-SMP crash being a
> good example.

If you want to actually force a BUG_ON if the spinlock is not taken,
even for non-debug kernels, you can use assert_spin_locked().  This
translates to a BUG_ON(!raw_spin_is_locked(x)) on SMP kernels, and a
no-op on UP kernels.

If you're confident in your testing that any problems would be
discovered before you push your patches to linus (and you actually use
lockdep in your testing :-), then lockdep_assert_held() doesn't add
any overhead if !lockdep, and so it might be a better choice for you.

							- Ted
