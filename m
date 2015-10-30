From: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v4 3/3] arm64/efi: isolate EFI stub from the kernel proper
Date: Fri, 30 Oct 2015 14:35:04 +0000
Message-ID: <20151030143504.GD31073@leverpostej>
References: <1444330924-17830-1-git-send-email-ard.biesheuvel@linaro.org>
 <1444330924-17830-4-git-send-email-ard.biesheuvel@linaro.org>
 <562EA894.8070505@arm.com>
 <562EAA22.3010905@arm.com>
 <CAKv+Gu-G1YS9Ha=-rtnPKJTOxBTrdSq6=Tqwq_GPW742JUE+2Q@mail.gmail.com>
 <562F8DCE.4010308@arm.com>
 <CAKv+Gu-m7dJbiF=8i=+cN=bx+y8AKu_MgHrS29jNK0fTvuwQ5Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu-m7dJbiF=8i=+cN=bx+y8AKu_MgHrS29jNK0fTvuwQ5Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
Cc: Jeremy Linton <jeremy.linton-5wv7dgnIgG8@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Andrey Ryabinin <ryabinin.a.a-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

[Adding Catalin to the To line]

On Fri, Oct 30, 2015 at 01:17:24PM +0100, Ard Biesheuvel wrote:
> On 27 October 2015 at 23:44, Jeremy Linton <jeremy.linton-5wv7dgnIgG8@public.gmane.org> wrote:
> > On 10/26/2015 09:20 PM, Ard Biesheuvel wrote:
> >>
> >> Thanks for the report. The following patch should fix it
> >
> >
> > Ard,
> >
> > Thanks, it does fix the build problem...
> >
> > Now to get the darn thing to boot (not related to this AFAIK).
> >
> 
> Catalin,
> 
> Would you like me to resend this as a separate patch?

Ard's referring to the patch in a prior reply [1].

Mark.

[1] http://lists.infradead.org/pipermail/linux-arm-kernel/2015-October/381074.html
