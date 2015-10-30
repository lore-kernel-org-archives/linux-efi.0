From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v4 3/3] arm64/efi: isolate EFI stub from the kernel proper
Date: Fri, 30 Oct 2015 13:17:24 +0100
Message-ID: <CAKv+Gu-m7dJbiF=8i=+cN=bx+y8AKu_MgHrS29jNK0fTvuwQ5Q@mail.gmail.com>
References: <1444330924-17830-1-git-send-email-ard.biesheuvel@linaro.org>
	<1444330924-17830-4-git-send-email-ard.biesheuvel@linaro.org>
	<562EA894.8070505@arm.com>
	<562EAA22.3010905@arm.com>
	<CAKv+Gu-G1YS9Ha=-rtnPKJTOxBTrdSq6=Tqwq_GPW742JUE+2Q@mail.gmail.com>
	<562F8DCE.4010308@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <562F8DCE.4010308-5wv7dgnIgG8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeremy Linton <jeremy.linton-5wv7dgnIgG8@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Andrey Ryabinin <ryabinin.a.a-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 27 October 2015 at 23:44, Jeremy Linton <jeremy.linton-5wv7dgnIgG8@public.gmane.org> wrote:
> On 10/26/2015 09:20 PM, Ard Biesheuvel wrote:
>>
>> Thanks for the report. The following patch should fix it
>
>
> Ard,
>
> Thanks, it does fix the build problem...
>
> Now to get the darn thing to boot (not related to this AFAIK).
>

Catalin,

Would you like me to resend this as a separate patch?

-- 
Ard.
