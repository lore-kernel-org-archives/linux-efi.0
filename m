From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v2] EFI loader: remove redundant code
Date: Wed, 2 Nov 2016 13:57:58 +0000
Message-ID: <CAKv+Gu_dtd2H8XYy4sjMJMpt6oS6mjj36RLpzQoYTHOiCCC22Q@mail.gmail.com>
References: <20161102041855.GA4479@vnote> <CAKv+Gu8xkxPSkA+3Sqo-kcL=b6ex6MNQ7DrDV_sqcQrfmqkvCw@mail.gmail.com>
 <20161102135603.GA8090@vnote>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161102135603.GA8090@vnote>
Sender: linux-kernel-owner@vger.kernel.org
To: Eugene Korenevsky <ekorenevsky@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Linn Crosetto <linn@hpe.com>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
List-Id: linux-efi@vger.kernel.org

On 2 November 2016 at 13:56, Eugene Korenevsky <ekorenevsky@gmail.com> wrote:
>> > *e820ext is always NULL in 'alloc_e820ext()' (see the code of 'exit_boot()').
>> > Without loss of generality we can replace freeing with returning
>> > EFI_INVALID_PARAMETER. So if the caller would ever incorrectly pass non-NULL
>> > *e820ext, he will obtain a returned error code.
>> >
>>
>> What exactly are you trying to fix here? Adding new artificial failure
>> modes is hardly worth it when all you are doing is cleaning up code
>> that by itself is correct to begin with, but is simply never called.
>
> This code (free_pool, assignments) is dead whether it is correct or
> not. So it is to be removed.
> The check gives some assurance that memory is not leaked if the calling
> code is changed.
>

No, it doesn't. This code executes in the context of the UEFI
firmware, which is riddled with bugs on older x86 platforms (as well
as non newer non-x86 platforms). By returning an error at runtime, you
may be breaking the boot for someone who wil have *no* idea whatsoever
what is going on.

If you want to clean this up in a way that prevents future issues,
please use something like BUILD_BUG()
