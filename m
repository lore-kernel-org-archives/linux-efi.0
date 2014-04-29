From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 00/10] arm64: UEFI support
Date: Tue, 29 Apr 2014 07:36:24 -0700
Message-ID: <535FB8E8.1060905@zytor.com>
References: <1398442154-19974-1-git-send-email-leif.lindholm@linaro.org> <20140429102817.GE17007@arm.com> <20140429114356.GK26088@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140429114356.GK26088-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
Cc: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Rutland <Mark.Rutland-5wv7dgnIgG8@public.gmane.org>, "linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 04/29/2014 04:43 AM, Matt Fleming wrote:
> (Pulling in Peter and Stephen)
> 
> On Tue, 29 Apr, at 11:28:17AM, Catalin Marinas wrote:
>>
>> The patches look fine to me, they've been through several rounds of
>> review already. How do we propose these get merged as the series
>> contains both generic and arm64 patches? And there are dependencies
>> already in linux-next.
>>
>> Are the EFI patches in -next pulled from some non-rebaseable branch?
> 
> Peter suggsted a plan when he took the generic EFI stuff that's in tip
> (and hence currently in linux-next),
> 
>   It doesn't hurt to inform Stephen, although I think it will simply fall
>   out automatically since he uses git to merge and git will recognize the
>   graph.
> 
>   During the merge window, it means they should not push their patches
>   until Linus has accepted the precondition patches from the tip tree.
>   Since Ingo and I try to push most of the tip tree as early as possible
>   in the merge window, this is usually not a problem.
> 
> So we currently have the prerequisites in tip/x86/efi, and assuming that
> this 10-patch series gets merged into a single branch somewhere, things
> should work automatically for linux-next.
> 
> It may be prudent to negotiate a plan now for when the merge window
> opens because, as Peter mentions above, the stuff in tip/x86/efi needs
> to be merged by Linus first to avoid build breakage with the arm64
> stuff.

Whomever is going to push the arm64 stuff just needs to be aware of this
constraint.  Again, since we tend to push -tip very early in the merge
window, unless there are problems or late additions, this is unlikely to
be a problem in any way.

	-hpa
