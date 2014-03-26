From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH] Add efi_early_call() macro
Date: Wed, 26 Mar 2014 08:59:53 +0000
Message-ID: <20140326085953.GA2958@console-pimps.org>
References: <20140322110515.GF2815@console-pimps.org>
 <1395787231-14298-1-git-send-email-roy.franz@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1395787231-14298-1-git-send-email-roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org, mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Tue, 25 Mar, at 03:40:30PM, Roy Franz wrote:
> Add the efi_early_call() macro to invoke functions in the efi_early
> structure. Using a macro for these invocations allows the arm32/arm64
> architectures to define the macro differently so that they can directly
> invoke the boot services functions that are exposed in the efi_early
> structure on x86. Prior to the introduction of the efi_early structure
> the efi_call_physN macros were used on all architectures and allowed
> for this differentiation.
> 
> Signed-off-by: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  arch/x86/boot/compressed/eboot.c       |    5 +++++
>  drivers/firmware/efi/efi-stub-helper.c |   26 +++++++++++++-------------
>  2 files changed, 18 insertions(+), 13 deletions(-)

Confused.

Why have you rewritten the patch that I sent Satuday morning?

  https://lkml.org/lkml/2014/3/22/61

I don't think your version goes far enough because you've left all the
efi_early->call() stuff in eboot.c. So now there's two ways to invoke
EFI functions in the x86 boot stub.

What's wrong with the patch that I sent?

-- 
Matt Fleming, Intel Open Source Technology Center
