From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH 0/5] x86/efi: Implement FPU context save/restore
Date: Fri, 4 Apr 2014 12:11:35 +0100
Message-ID: <20140404111135.GE5222@console-pimps.org>
References: <1395958243-14458-1-git-send-email-ricardo.neri-calderon@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1395958243-14458-1-git-send-email-ricardo.neri-calderon-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ricardo Neri <ricardo.neri-calderon-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, 27 Mar, at 03:10:38PM, Ricardo Neri wrote:
> It may be possible that EFI firmware wants to use the FPU. Thus, in such a case,
> the kernel EFI runtime services need to make sure that they save and restore the
> FPU context.
> 
> Additionally, several FPU internal functions require alternatives to be in place
> when running. Some of the FPU context save/restore instances that this series
> implements may occur early during boot; before the alternatives have run.
> Several FPU internal functions are updated to use the alternatives-safe variant
> of static_cpu_has. The performance penalty is negligible as the impacted
> functions are not performance-critical.
> 
> In order to prepare to implement the FPU context save/restore, this series also
> reworks many of the efi_call macros. The code will also be more readable and
> continue to be reusable between x86_64 and i386.

Thanks Ricardo, I've picked these up. I'll merge them into my 'next'
branch once the merge window closes.

-- 
Matt Fleming, Intel Open Source Technology Center
