From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH 1/2] efi: Determine how much space is used by boot services-only
 variables
Date: Wed, 03 Apr 2013 14:09:02 +0100
Message-ID: <515C29EE.8050008@console-pimps.org>
References: <515150EC.7040203@redhat.com> <1364829240-26475-1-git-send-email-matthew.garrett@nebula.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1364829240-26475-1-git-send-email-matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Cc: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org, jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 01/04/13 16:13, Matthew Garrett wrote:
> EFI variables can be flagged as being accessible only within boot services.
> This makes it awkward for us to figure out how much space they use at
> runtime. In theory we could figure this out by simply comparing the results
> from QueryVariableInfo() to the space used by all of our variables, but
> that fails if the platform doesn't garbage collect on every boot. Thankfully,
> calling QueryVariableInfo() while still inside boot services gives a more
> reliable answer. This patch passes that information from the EFI boot stub
> up to the efivars code, letting us calculate a reasonably accurate value.
> 
> Signed-off-by: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
> ---
>  arch/x86/boot/compressed/eboot.c      | 47 +++++++++++++++++++++++++++++++++++
>  arch/x86/include/asm/efi.h            | 10 ++++++++
>  arch/x86/include/uapi/asm/bootparam.h |  1 +
>  arch/x86/platform/efi/efi.c           | 21 ++++++++++++++++
>  drivers/firmware/efivars.c            | 29 +++++++++++++++++++++
>  5 files changed, 108 insertions(+)

We're fixing a regression in efivars.c, but only for those users that
boot via the EFI boot stub? That seems likely to upset some people.

Introducing new features via the EFI boot stub is fine, and working
around firmware bugs so that we can use some feature is also cool, but
we can't start fixing regressions from other subsystems in the EFI boot
stub.

-- 
Matt Fleming, Intel Open Source Technology Center
