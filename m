From: Masayoshi Mizuma <msys.mizuma@gmail.com>
Subject: Re: [PATCH v8 0/3] x86/boot/KASLR: Parse ACPI table and limit kaslr
 in immovable memory
Date: Sun, 11 Nov 2018 08:45:57 -0500
Message-ID: <20181111134556.qxv2v4g7dl5irzo7@gabell>
References: <20181016195902.GK5212@zn.tnic>
 <20181022154204.kagmdb55jtoez4ca@gabell>
 <20181025103345.GF14020@nazgul.tnic>
 <20181025134050.ggiir77ehntikbwg@gabell>
 <20181106184519.GA16391@zn.tnic>
 <20181106193636.svyjwuwrlgnpuyyf@gabell>
 <20181106204511.GO13712@zn.tnic>
 <20181106222133.lb7674yzszivzihd@gabell>
 <20181108105129.GA7543@zn.tnic>
 <20181110105422.GA20023@zn.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181110105422.GA20023@zn.tnic>
Sender: linux-kernel-owner@vger.kernel.org
To: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Baoquan He <bhe@redhat.com>, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Chao Fan <fanc.fnst@cn.fujitsu.com>, linux-kernel@vger.kernel.org, x86@kernel.org, linux-efi@vger.kernel.org, linux-acpi@vger.kernel.org, mingo@redhat.com, keescook@chromium.org, rjw@rjwysocki.net, lenb@kernel.org, ard.biesheuvel@linaro.org, indou.takao@jp.fujitsu.com, caoj.fnst@cn.fujitsu.com
List-Id: linux-efi@vger.kernel.org

On Sat, Nov 10, 2018 at 11:54:22AM +0100, Borislav Petkov wrote:
> On Thu, Nov 08, 2018 at 11:51:29AM +0100, Borislav Petkov wrote:
> > A global definition which doesn't need allocation?
> > 
> > Maybe hpa would have another, better idea...
> 
> ...and he has: just put that address in a new field in struct
> boot_params by converting one of the padding arrays there.
> 
> Don't forget to document it in Documentation/x86/zero-page.txt
> 
> This way you don't need any of the allocation fun or to use setup_data
> at all.

Thanks!
I have the prototype patch to use boot_params [1].
I will try to brush up it.

[1] https://lore.kernel.org/lkml/20181016151353.punyk7exekut2543@gabell

Thanks,
Masa
