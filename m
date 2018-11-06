From: Baoquan He <bhe@redhat.com>
Subject: Re: [PATCH v8 0/3] x86/boot/KASLR: Parse ACPI table and limit kaslr
 in immovable memory
Date: Tue, 6 Nov 2018 22:07:31 +0800
Message-ID: <20181106140731.GO27491@MiWiFi-R3L-srv>
References: <20181013220541.GI31650@zn.tnic>
 <20181015005035.z3xym6nx43hogdge@gabell>
 <20181016151353.punyk7exekut2543@gabell>
 <20181016191113.GI5212@zn.tnic>
 <20181016195429.tovdgqq77gz3eek2@gabell>
 <20181016195902.GK5212@zn.tnic>
 <20181022154204.kagmdb55jtoez4ca@gabell>
 <20181025103345.GF14020@nazgul.tnic>
 <20181025134050.ggiir77ehntikbwg@gabell>
 <20181106121023.GF13712@zn.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181106121023.GF13712@zn.tnic>
Sender: linux-kernel-owner@vger.kernel.org
To: Masayoshi Mizuma <msys.mizuma@gmail.com>, Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Chao Fan <fanc.fnst@cn.fujitsu.com>, linux-kernel@vger.kernel.org, x86@kernel.org, linux-efi@vger.kernel.org, linux-acpi@vger.kernel.org, mingo@redhat.com, hpa@zytor.com, keescook@chromium.org, rjw@rjwysocki.net, lenb@kernel.org, ard.biesheuvel@linaro.org, indou.takao@jp.fujitsu.com, caoj.fnst@cn.fujitsu.com
List-Id: linux-efi@vger.kernel.org

On 11/06/18 at 01:10pm, Borislav Petkov wrote:
> > I have another idea to solve this issue. Adding a SRAT parsing code
> > to arch/x86/mm/kaslr.c. It is useful for both EFI and BIOS and
> > also we don't need a new kernel parameter...
> > Dose the idea make sense?
> 
> The more automatic stuff we do and we don't have to involve the user,
> the better.
> 
> However, lemme look at Chao's current patchset first - we should not go
> nuts by putting SRAT parsing everywhere :)

arch/x86/mm/ident_map.c is a good example, it's shared between
arch/x86/boot/compressed and arch/x86/mm/init_64.c
