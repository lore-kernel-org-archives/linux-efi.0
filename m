From: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH 1/3] efi: Introduce *_continue efi_memory_desc iterators
Date: Thu, 2 Jun 2016 17:29:25 +0100
Message-ID: <20160602162925.GC24938@e104818-lin.cambridge.arm.com>
References: <1464707672-21882-1-git-send-email-catalin.marinas@arm.com>
 <1464707672-21882-2-git-send-email-catalin.marinas@arm.com>
 <20160601103446.GC9280@leverpostej>
 <20160601104326.GA24749@e104818-lin.cambridge.arm.com>
 <20160602143650.GG2658@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160602143650.GG2658-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Jeremy Linton <jeremy.linton-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, Jun 02, 2016 at 03:36:50PM +0100, Matt Fleming wrote:
> On Wed, 01 Jun, at 11:43:26AM, Catalin Marinas wrote:
> > 
> > Thanks for the heads up. I'll rebase the patches after -rc2 but anyway I
> > plan to merge them in 4.8 via the arm64 tree, including the patch above
> > if Matt acks it. So there is enough time to fix the conflicts.
> 
> I'd really prefer it if you didn't take this series through the arm64
> tree, unless there are existing dependencies, of course.
> 
> There were a number of conflicts in 3 different maintainer trees in
> linux-next before the most recent merge window opened, and extra work
> was required to sort that out. I want to avoid that in the future, so
> expect me to be more insistent about keeping EFI patches in the EFI
> tree than I have been in the past. 
> 
> Do arm64 prerequisites exist for this series? Or are you planning on
> adding dependencies on top?

I don't know when Jeremy plans to submit his contiguous PTE patches (we
rejected them on the grounds of unnecessary huge page splitting, hence
this series). If he's not targeting 4.8, I'm happy for the patches to go
in via the EFI tree.

-- 
Catalin
