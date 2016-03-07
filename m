From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 09/13] efi/arm64: Check for h/w support before booting a
 >4 KB granule kernel
Date: Mon, 7 Mar 2016 18:05:46 +0700
Message-ID: <CAKv+Gu9XQgrztMm+3dVXCM9KwMP14iY=gH8h6H4ezR94HmSBAg@mail.gmail.com>
References: <1455712566-16727-1-git-send-email-matt@codeblueprint.co.uk>
	<1455712566-16727-10-git-send-email-matt@codeblueprint.co.uk>
	<CAKv+Gu-ZHz9Z6YyusLZdKJA4QPJ8fkxVWaA=EQvTM5iSLM7c1Q@mail.gmail.com>
	<20160307110243.GB27675@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160307110243.GB27675-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jeremy Linton <jeremy.linton-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Suzuki K Poulose <suzuki.poulose-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 7 March 2016 at 18:02, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:
> On Sun, 06 Mar, at 04:35:32AM, Ard Biesheuvel wrote:
>>
>> Hi Matt,
>>
>> This patch turned up in -next with 'granule' replaced with 'granular',
>> both in the commit log and in the patch itself. The term 'granule' is
>> part of the idiom used by the ARM Architecture Reference Manual, and
>> so changing it silently to 'granular' is not entirely appropriate here
>> (although harmless in practice, obviously). In general, I would
>> appreciate it if in the future, such changes were not made silently
>> somewhere in the merge pipeline.
>
> Sorry about this Ard. I'll make sure this doesn't happen again in
> future.
>

Thanks

> Ingo, is there any chance we can fixup this patch in-place and revert
> back to the original wording before it gets to Linus' during the merge
> window?

To be honest, I don't care deeply about the commit log, as long as the
code changes are reverted.

Thanks,
Ard.
