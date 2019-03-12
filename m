From: Sasha Levin <sashal@kernel.org>
Subject: Re: Please revert 7212e37cbdf9 from 4.4-stable
Date: Mon, 11 Mar 2019 20:29:44 -0400
Message-ID: <20190312002944.GL158926@sasha-vm>
References: <20190311134814.GC30367@sarge.linuxathome.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190311134814.GC30367@sarge.linuxathome.me>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org, stable@vger.kernel.org, Borislav Petkov <bp@suse.de>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Russ Anderson <rja@hpe.com>, Dimitri Sivanich <sivanich@hpe.com>, Steve Wahl <steve.wahl@hpe.com>, Mike Travis <mike.travis@hpe.com>, Andy Shevchenko <andy@infradead.org>, Bhupesh Sharma <bhsharma@redhat.com>, Darren Hart <dvhart@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, linux-efi <linux-efi@vger.kernel.org>, platform-driver-x86@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, x86-ml <x86@kernel.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Mar 11, 2019 at 01:48:14PM +0000, Hedi Berriche wrote:
>Hi Greg,
>
>Could you please revert
>
>	7212e37cbdf9 x86/platform/UV: Use efi_runtime_lock to serialise BIOS calls
>
>from 4.4-stable?
>
>In 4.4-stable efi_runtime_lock as defined in drivers/firmware/efi/runtime-wrappers.c
>is a spinlock (given it predates commit dce48e351c0d) and commit
>
>	f331e766c4be x86/platform/UV: Use efi_runtime_lock to serialise BIOS calls
>
>which 7212e37cbdf9 is a backport of, needs it to be a semaphore.

I've queued up the revert. I'm not sure how it ended up on 4.4 to begin
with; sorry about that and thank you.

--
Thanks,
Sasha
