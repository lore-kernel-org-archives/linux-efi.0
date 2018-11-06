From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v8 0/3] x86/boot/KASLR: Parse ACPI table and limit kaslr
 in immovable memory
Date: Tue, 6 Nov 2018 13:10:23 +0100
Message-ID: <20181106121023.GF13712@zn.tnic>
References: <20181013214550.ag5qzokhkrkwnzsy@gabell>
 <20181013220541.GI31650@zn.tnic>
 <20181015005035.z3xym6nx43hogdge@gabell>
 <20181016151353.punyk7exekut2543@gabell>
 <20181016191113.GI5212@zn.tnic>
 <20181016195429.tovdgqq77gz3eek2@gabell>
 <20181016195902.GK5212@zn.tnic>
 <20181022154204.kagmdb55jtoez4ca@gabell>
 <20181025103345.GF14020@nazgul.tnic>
 <20181025134050.ggiir77ehntikbwg@gabell>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181025134050.ggiir77ehntikbwg@gabell>
Sender: linux-kernel-owner@vger.kernel.org
To: Masayoshi Mizuma <msys.mizuma@gmail.com>
Cc: Baoquan He <bhe@redhat.com>, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Chao Fan <fanc.fnst@cn.fujitsu.com>, linux-kernel@vger.kernel.org, x86@kernel.org, linux-efi@vger.kernel.org, linux-acpi@vger.kernel.org, mingo@redhat.com, hpa@zytor.com, keescook@chromium.org, rjw@rjwysocki.net, lenb@kernel.org, ard.biesheuvel@linaro.org, indou.takao@jp.fujitsu.com, caoj.fnst@cn.fujitsu.com
List-Id: linux-efi@vger.kernel.org

On Thu, Oct 25, 2018 at 09:40:51AM -0400, Masayoshi Mizuma wrote:
> My actual use case is for EFI boxes, however, I think it's better to useful
> for legacy BIOS as well because memory hot-plug affinity in SRAT and KASLR
> are available on legacy BIOS.
> Actually, we can create such environment in qemu.

Ah, right, qemu. :)

> I have another idea to solve this issue. Adding a SRAT parsing code
> to arch/x86/mm/kaslr.c. It is useful for both EFI and BIOS and
> also we don't need a new kernel parameter...
> Dose the idea make sense?

The more automatic stuff we do and we don't have to involve the user,
the better.

However, lemme look at Chao's current patchset first - we should not go
nuts by putting SRAT parsing everywhere :)

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
