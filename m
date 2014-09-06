From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH] efi: Resolve some shadow warnings
Date: Sat, 6 Sep 2014 10:03:31 +0100
Message-ID: <20140906090331.GQ3001@console-pimps.org>
References: <1409967292-31441-1-git-send-email-jeffrey.t.kirsher@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1409967292-31441-1-git-send-email-jeffrey.t.kirsher-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Kirsher <jeffrey.t.kirsher-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Mark Rustad <mark.d.rustad-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Fri, 05 Sep, at 06:34:52PM, Jeff Kirsher wrote:
> From: Mark Rustad <mark.d.rustad-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> It is a really bad idea to declare variables or parameters that
> have the same name as common types. It is valid C, but it gets
> surprising if a macro expansion attempts to declare an inner
> local with that type. Change the local names to eliminate the
> hazard.
 
Oops, good catch. Could you include a copy of the compiler shadow
warnings in the commit log? I'm guessing this bug is highlighted with
-Wshadow? How did you discover this problem?

> Change s16 => ps16, s8 => ps8.
 
Hmm... Instead, could you change it to str16 and str8? s8/s16 were
clearly misguided names in the first place, and it's not immediatealy
obvious to me that a 'ps16' would represent "pointer to 16-bit string".

-- 
Matt Fleming, Intel Open Source Technology Center
