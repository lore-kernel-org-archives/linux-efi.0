From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v8 0/3] x86/boot/KASLR: Parse ACPI table and limit kaslr
 in immovable memory
Date: Wed, 10 Oct 2018 10:59:20 +0200
Message-ID: <20181010085920.GB5533@zn.tnic>
References: <20181010084119.17539-1-fanc.fnst@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181010084119.17539-1-fanc.fnst@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Chao Fan <fanc.fnst@cn.fujitsu.com>, Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-efi@vger.kernel.org, linux-acpi@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, keescook@chromium.org, bhe@redhat.com, rjw@rjwysocki.net, lenb@kernel.org, ard.biesheuvel@linaro.org, indou.takao@jp.fujitsu.com, caoj.fnst@cn.fujitsu.com, Masayoshi Mizuma <msys.mizuma@gmail.com>
List-Id: linux-efi@vger.kernel.org

On Wed, Oct 10, 2018 at 04:41:16PM +0800, Chao Fan wrote:
> ***Background:
> People reported that kaslr may randomly chooses some positions
> which are located in movable memory regions. This will break memory
> hotplug feature and make the movable memory chosen by KASLR can't be
> removed.
> 
> ***Solutions:
> There should be a method to limit kaslr to choosing immovable memory
> regions, so there are 2 solutions:
> 1) Add a kernel parameter to specify the memory regions.
> 2) Get the information of memory hot-remove, then kaslr will know the
>    right regions.
> In method 2, information about memory hot-remove is in ACPI
> tables, which will be parsed after start_kernel(), kaslr can't get
> the information.
> In method 1, users should know the regions address and specify in
> kernel parameter.
> 
> In the earliest time, I tried to dig ACPI tabls to solve this problem.
> But I didn't splite the code in 'compressed/' and ACPI code, so the patch
> is hard to follow so refused by community.
> Somebody suggest to add a kernel parameter to specify the
> immovable memory so that limit kaslr in these regions. Then I make
> a new patchset. After several versions, Ingo gave a suggestion:
> https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg1634024.html
> Follow Ingo's suggestion, imitate the ACPI code to parse the acpi
> tables, so that the kaslr can get necessary memory information in
> ACPI tables.
> I think ACPI code is an independent part, so copy the codes
> and functions to 'compressed/' directory, so that kaslr won't
> influence the initialization of ACPI.

... and we just picked up

https://lkml.kernel.org/r/20181001140843.26137-1-msys.mizuma@gmail.com

and without having looked at the rest of your stuff, if people accept
your solution, we don't need the silly parameter anymore, right?

Which means, we should not rush the whole thing yet until the whole
KASLR vs movable memory gets solved properly.

Ingo, Thomas?

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
