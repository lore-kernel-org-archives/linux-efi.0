From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/3] efi/x86: turn EFI runtime semaphore into a global
 lock
Date: Tue, 15 Jan 2019 19:55:10 +0100 (CET)
Message-ID: <alpine.DEB.2.21.1901151953370.1655@nanos.tec.linutronix.de>
References: <20190109104541.25733-1-hedi.berriche@hpe.com> <20190109104541.25733-2-hedi.berriche@hpe.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190109104541.25733-2-hedi.berriche@hpe.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Hedi Berriche <hedi.berriche@hpe.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, Russ Anderson <rja@hpe.com>, Mike Travis <mike.travis@hpe.com>, Dimitri Sivanich <sivanich@hpe.com>, Steve Wahl <steve.wahl@hpe.com>
List-Id: linux-efi@vger.kernel.org

On Wed, 9 Jan 2019, Hedi Berriche wrote:

> Make efi_runtime_lock semaphore global so that it can be used by EFI
> runtime callers that may be defined outside efi/runtime-wrappers.c.

The changelog should mention why the lock is renamed. I have no strong
opinion, but to apply that I need an Ack from Ard.

Thanks,

	tglx
