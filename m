From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH v3] arm64/efi: don't pad between EFI_MEMORY_RUNTIME
 regions
Date: Wed, 23 Sep 2015 14:50:05 +0100
Message-ID: <20150923135005.GD2867@codeblueprint.co.uk>
References: <1441782414-16284-1-git-send-email-ard.biesheuvel@linaro.org>
 <1441899699-14893-1-git-send-email-ard.biesheuvel@linaro.org>
 <20150910160809.GM29293@leverpostej>
 <CAKv+Gu914YCoEvs9QkS619+gPW3qv1UTXqjmBhLPuH6ZCdmEqA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu914YCoEvs9QkS619+gPW3qv1UTXqjmBhLPuH6ZCdmEqA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Catalin Marinas <Catalin.Marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <Will.Deacon-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, 10 Sep, at 06:10:57PM, Ard Biesheuvel wrote:
> 
> Thanks Mark.
> 
> @Matt: could you please drop the version you have queued, and take
> this one instead?
> Also, this patch will not apply to anything before v4.0 so could you
> please include that in the cc:stable tag?

Sorry for the delay. I've queued up this version with all tags and
I'll send an urgent pull request this week. Thanks everyone.

-- 
Matt Fleming, Intel Open Source Technology Center
