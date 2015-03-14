From: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v2] efi/arm64: use UEFI for system reset and poweroff
Date: Sat, 14 Mar 2015 11:00:43 +0000
Message-ID: <20150314110043.GA9696@e104818-lin.cambridge.arm.com>
References: <1425653364-12591-1-git-send-email-ard.biesheuvel@linaro.org>
 <20150310144857.GE17573@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150310144857.GE17573-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, mark.rutland-5wv7dgnIgG8@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Tue, Mar 10, 2015 at 02:48:57PM +0000, Matt Fleming wrote:
> On Fri, 06 Mar, at 03:49:24PM, Ard Biesheuvel wrote:
> > If UEFI Runtime Services are available, they are preferred over direct
> > PSCI calls or other methods to reset the system.
> > 
> > For the reset case, we need to hook into machine_restart(), as the
> > arm_pm_restart function pointer may be overwritten by modules.
> > 
> > Tested-by: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
> > Reviewed-by: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
> > Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> > ---
> >  arch/arm64/kernel/efi.c     | 9 +++++++++
> >  arch/arm64/kernel/process.c | 8 ++++++++
> >  2 files changed, 17 insertions(+)
> 
> Looks good to me.
> 
> Reviewed-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> Catalin, are you picking this up?

Yes, I will. Thanks.

-- 
Catalin
