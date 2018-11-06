From: Masayoshi Mizuma <msys.mizuma@gmail.com>
Subject: Re: [PATCH v8 0/3] x86/boot/KASLR: Parse ACPI table and limit kaslr
 in immovable memory
Date: Tue, 6 Nov 2018 14:36:38 -0500
Message-ID: <20181106193636.svyjwuwrlgnpuyyf@gabell>
References: <20181013220541.GI31650@zn.tnic>
 <20181015005035.z3xym6nx43hogdge@gabell>
 <20181016151353.punyk7exekut2543@gabell>
 <20181016191113.GI5212@zn.tnic>
 <20181016195429.tovdgqq77gz3eek2@gabell>
 <20181016195902.GK5212@zn.tnic>
 <20181022154204.kagmdb55jtoez4ca@gabell>
 <20181025103345.GF14020@nazgul.tnic>
 <20181025134050.ggiir77ehntikbwg@gabell>
 <20181106184519.GA16391@zn.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181106184519.GA16391@zn.tnic>
Sender: linux-kernel-owner@vger.kernel.org
To: Borislav Petkov <bp@alien8.de>
Cc: Baoquan He <bhe@redhat.com>, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Chao Fan <fanc.fnst@cn.fujitsu.com>, linux-kernel@vger.kernel.org, x86@kernel.org, linux-efi@vger.kernel.org, linux-acpi@vger.kernel.org, mingo@redhat.com, hpa@zytor.com, keescook@chromium.org, rjw@rjwysocki.net, lenb@kernel.org, ard.biesheuvel@linaro.org, indou.takao@jp.fujitsu.com, caoj.fnst@cn.fujitsu.com
List-Id: linux-efi@vger.kernel.org

On Tue, Nov 06, 2018 at 07:45:19PM +0100, Borislav Petkov wrote:
> Ok, having swapped the whole thing back into my brain, forget what I
> said earlier today.
> 
> Didn't we talk about passing info with setup_data to the later kernel
> stage? You even had a patch:
> 
> https://lkml.kernel.org/r/20181022154204.kagmdb55jtoez4ca@gabell
> 
> So what is that "idea" again about adding SRAT parsing code to
> arch/x86/mm/kaslr.c?!?!
> 
> The intent of passing info with setup_data is to *avoid* parsing SRAT
> yet another time and duplicating that code one more time.
> 
> IOW:
> 
> * The first place that needs SRAT parsing, does the parsing - i.e., the
> compressed stage.
> 
> * Later stages get information passed to them with setup_data. No second
> parsing.
> 
> Ok?

Yes, I think I can see what you are saying. However, I'm not sure how
I use the setup_data in legacy BIOS environment. So, I said the another
idea which adding the SRAT parsing code to arch/x86/mm/kaslr.c as well.
Yes, as you said, that is not so good...

I would appreciate if you could help to use setup_data or something to
pass the information to later kernel stage in BIOS environment.

Thanks,
Masa
