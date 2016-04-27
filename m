From: Josh Boyer <jwboyer@fedoraproject.org>
Subject: Re: [PATCH] x86/efi-bgrt: Switch all pr_err() to pr_debug() for
 invalid BGRT
Date: Wed, 27 Apr 2016 11:20:26 -0400
Message-ID: <CA+5PVA51UZL3zkYgLAimnXcYQwNJ4h+zCqEt0XRp2UEHaV302g@mail.gmail.com>
References: <1461761412-16046-1-git-send-email-jwboyer@fedoraproject.org>
	<5720BE0B.8080605@moshe.nl>
	<CA+5PVA71vCaf+a=6cEqQxe4iUQeAK5NN-s09bMDa6_NbXZfMNw@mail.gmail.com>
	<5720D365.5080601@moshe.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5720D365.5080601@moshe.nl>
Sender: linux-kernel-owner@vger.kernel.org
To: =?UTF-8?Q?M=C3=B4she_van_der_Sterre?= <me@moshe.nl>
Cc: Matt Fleming <matt@codeblueprint.co.uk>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>, Josh Triplett <josh@joshtriplett.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Apr 27, 2016 at 10:57 AM, M=C3=B4she van der Sterre <me@moshe.n=
l> wrote:
>
> On 04/27/2016 03:56 PM, Josh Boyer wrote:
>>
>> On Wed, Apr 27, 2016 at 9:26 AM, M=C3=B4she van der Sterre <me@moshe=
=2Enl> wrote:
>>>
>>> (additionally CC-ing Josh Triplett)
>>
>> Thanks for doing so.  I completely forgot.
>>
>>> On 04/27/2016 02:50 PM, Josh Boyer wrote:
>>>>
>>>> The promise of pretty boot splashes from firmware via BGRT was at
>>>> best only that; a promise.  The kernel diligently checks to make
>>>> sure the BGRT data firmware gives it is valid, and dutifully warns
>>>> the user when it isn't.  However, it does so via the pr_err log
>>>> level which seems unnecessary.  The user cannot do anything about
>>>> this and there really isn't an error on the part of Linux to
>>>> correct.
>>>>
>>>> This lowers the log level by using pr_debug instead.  Users will
>>>> no longer have their boot process uglified by the kernel reminding
>>>> us that firmware can and often is broken.  Ironic, considering
>>>> BGRT is supposed to make boot pretty to begin with.
>>>
>>> Hi Josh Boyer,
>>>
>>> Are you seeing these errors somewhere? I recently fixed the error
>>> "Ignoring
>>
>> We have a user that reports seeing:
>>
>> "Ignoring BGRT: Invalid version 0 (expected 1)"
>>
>> on a Lenovo T430 machine.  We've had a few other scattered reports o=
n
>> various machine types since BGRT went into the kernel as well.
>
> Ok. With this information, I think pr_debug is indeed better.
>>>
>>> BGRT: invalid status 0 (expected 1)" because Linux apparently inter=
preted
>>> that part of the specification differently than others.
>>> If that's the error you are seeing, perhaps your problem is already
>>> solved
>>> in recent kernels? (fixed in commit 66dbe99)
>>>
>>> Personally I agree that BGRT messages should not annoy actual users=
 of
>>> production firmwares.
>>> However I also agree with the previous consensus that these checks =
(for
>>> actual spec violations) should remain pr_err unless some production
>>> firmware
>>> is triggering them. What do you think?
>>
>> Production firmware is literally the only firmware end users will ev=
er
>> see.  I don't see much point in leaving scary error messages in the
>> kernel to complain about things the user has no chance of fixing or =
in
>> almost all cases even reporting to people who could fix it.
>
> In principle I can understand the wish to show big scary error messag=
es to
> firmware developers doing it wrong.

Yes, that is theoretically possible.  However, my best guess is that
firmware developers aren't typically testing with Linux distributions
during firmware development.  They test with Windows, which is why we
see warnings in Linux that Windows doesn't show.  By then the firmware
is in production and it is too late.

We see this in lots of areas, which is why we have weird quirks for
devices all over the kernel, but I don't think there's value in doing
quirk mechanisms around BGRT.

josh
