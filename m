From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: [GIT PULL] EFI changes for v3.11
Date: Mon, 08 Jul 2013 11:36:12 -0700
Message-ID: <51DB069C.1010607@zytor.com>
References: <20130626122331.GK22026@console-pimps.org> <20130703081903.GI25291@console-pimps.org> <3908561D78D1C84285E8C5FCA982C28F31C76880@ORSMSX106.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F31C76880-P5GAC/sN6hlZtRGVdHMbwrfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Luck, Tony" <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 07/08/2013 10:29 AM, Luck, Tony wrote:
>>> ----------------------------------------------------------------
>>> Tony Luck (1):
>>>       [IA64] sim: Add casts to avoid assignment warnings
>>>
>>>  arch/ia64/hp/sim/boot/fw-emu.c | 20 ++++++++++----------
>>>  1 file changed, 10 insertions(+), 10 deletions(-)
>>
>> I don't see this commit in Linus' tree so presumably Tony is still
>> seeing these warnings.
> 
> Correct - I see 10 warning about "assignment makes pointer from integer"
> when building Linus' tree (HEAD = d2b4a646).
> 
> My patch doesn't appear to be in linux-next either (next-20130708).
> 
> I had hoped to have this patch follow in the same path that the
> one that changed the types and introduced the warnings took ...
> but since that didn't work perhaps I should just ask Linus to pull
> it from my ia64 tree.
> 

I can push it, although it seems a bit odd to me to push an ia64-only
patch through the x86 tree.

Let me know what you prefer.

	-hpa
