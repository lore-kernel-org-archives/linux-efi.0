From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [GIT PULL] EFI changes for v3.18
Date: Mon, 6 Oct 2014 11:26:01 +0200
Message-ID: <CAKv+Gu8V=g59c3ef_M_OZDR7G5TA=Vd79qi7Lvb4zpx1jUSbYg@mail.gmail.com>
References: <20140928202702.GB18635@console-pimps.org>
	<20140929124321.GB18825@gmail.com>
	<20140929140516.GL5430@worktop>
	<20140929150009.GA9102@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140929150009.GA9102-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 29 September 2014 17:00, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org> wrote:
> On Mon, 29 Sep, at 04:05:16PM, Peter Zijlstra wrote:
>>
>> OMFG what a trainwreck... if they are reentrant like that, a lock isn't
>> going to help you in any way. The implementation of these calls must be
>> lockfree otherwise they cannot possibly be correct.
>
> The only way these services are going to be called is if we (the OS)
> invoke them. These NMI shenanigans we're playing in the locking
> functions are actually for our benefit, not the firmware's.
>

The thing to understand here is that these Runtime Services are never
supposed to be *reentrant*, even under NMI. The special case for NMI,
machine check etc allows the OS to issue a concurrent Runtime Services
call that /preempts/ the call that is already in progress. The spec
explicitly mentions that the preempted function call is entirely
expected to fail.

This is exactly why the spec is so specific on which calls can be
issued concurrently: it puts the burden of exclusive access on the OS,
and the implementation can abort/fail a call in progress if another
one comes in concurrently.

This does imply that even the NMI case should take the lock if it is
free, which makes my implementation incorrect.

Note that I am by no means suggesting that relying on any of this
having been implemented correctly in most firmwares is a good idea.

>> Conditional locking like above is just plain broken, disgusting doesn't
>> even begin to cover it. Full NAK on this. If this is required by the EFI
>> spec someone needs to pull their head from their arse and smell the real
>> world.
>
> The conditional locking isn't intended to conform to the spec, it's
> intended to write a pstore object to the EFI variable NVRAM with our
> last dying breath, even if someone was in the middle of a SetVariable()
> call. All the spec says is that, if we're in a non-recoverable state,
> it's OK to do that. Whether that'll be implemented correctly across a
> range of firmware implementations is another matter.
>
> In fact, maybe we shouldn't support that lockless access at all. I've no
> huge problem changing the code in efi_pstore_write() to bail if we can't
> grab the lock, so that we can be serialized all of the time.
>
> That would certainly make the runtime lock code much simpler.
>

I think there is value in the ability to issue those calls under
MCHECK to record fault metadata, and obviously, the authors of the
spec did as well. However, the question is indeed how robust existing
firmware implementations are under this kind of behavior, so I agree
it is better to make the exclusive access unconditional. Note that
these exception are specific to Intel architectures, for arm64 the
locking was unconditional already.

-- 
Ard.
