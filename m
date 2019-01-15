From: Hedi Berriche <hedi.berriche@hpe.com>
Subject: Re: [PATCH 1/3] efi/x86: turn EFI runtime semaphore into a global
 lock
Date: Tue, 15 Jan 2019 19:35:34 +0000
Message-ID: <20190115193534.GK12284@sarge.linuxathome.me>
References: <20190109104541.25733-1-hedi.berriche@hpe.com>
 <20190109104541.25733-2-hedi.berriche@hpe.com>
 <alpine.DEB.2.21.1901151953370.1655@nanos.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.1901151953370.1655@nanos.tec.linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, Russ Anderson <rja@hpe.com>, Mike Travis <mike.travis@hpe.com>, Dimitri Sivanich <sivanich@hpe.com>, Steve Wahl <steve.wahl@hpe.com>
List-Id: linux-efi@vger.kernel.org

On Tue, Jan 15, 2019 at 18:55 Thomas Gleixner wrote:
>On Wed, 9 Jan 2019, Hedi Berriche wrote:
>
>> Make efi_runtime_lock semaphore global so that it can be used by EFI
>> runtime callers that may be defined outside efi/runtime-wrappers.c.
>
>The changelog should mention why the lock is renamed.

OK; will add to V2 that it was renamed so that it doesn't clash with the
efi_runtime_lock spinlock defined by CONFIG_EFI_MIXED.

>I have no strong opinion, but to apply that I need an Ack from Ard.

OK; thanks for the feedback.

Cheers,
Hedi.
-- 
Be careful of reading health books, you might die of a misprint.
	-- Mark Twain
