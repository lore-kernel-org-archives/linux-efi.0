From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH 09/13] efi/arm64: Check for h/w support before booting a
 >4 KB granule kernel
Date: Mon, 7 Mar 2016 11:02:43 +0000
Message-ID: <20160307110243.GB27675@codeblueprint.co.uk>
References: <1455712566-16727-1-git-send-email-matt@codeblueprint.co.uk>
 <1455712566-16727-10-git-send-email-matt@codeblueprint.co.uk>
 <CAKv+Gu-ZHz9Z6YyusLZdKJA4QPJ8fkxVWaA=EQvTM5iSLM7c1Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu-ZHz9Z6YyusLZdKJA4QPJ8fkxVWaA=EQvTM5iSLM7c1Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jeremy Linton <jeremy.linton-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Suzuki K Poulose <suzuki.poulose-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Sun, 06 Mar, at 04:35:32AM, Ard Biesheuvel wrote:
> 
> Hi Matt,
> 
> This patch turned up in -next with 'granule' replaced with 'granular',
> both in the commit log and in the patch itself. The term 'granule' is
> part of the idiom used by the ARM Architecture Reference Manual, and
> so changing it silently to 'granular' is not entirely appropriate here
> (although harmless in practice, obviously). In general, I would
> appreciate it if in the future, such changes were not made silently
> somewhere in the merge pipeline.

Sorry about this Ard. I'll make sure this doesn't happen again in
future.

Ingo, is there any chance we can fixup this patch in-place and revert
back to the original wording before it gets to Linus' during the merge
window?
