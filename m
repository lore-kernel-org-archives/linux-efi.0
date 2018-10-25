From: Masayoshi Mizuma <msys.mizuma@gmail.com>
Subject: Re: [PATCH v8 0/3] x86/boot/KASLR: Parse ACPI table and limit kaslr
 in immovable memory
Date: Thu, 25 Oct 2018 09:40:51 -0400
Message-ID: <20181025134050.ggiir77ehntikbwg@gabell>
References: <20181013203429.GE31650@zn.tnic>
 <20181013214550.ag5qzokhkrkwnzsy@gabell>
 <20181013220541.GI31650@zn.tnic>
 <20181015005035.z3xym6nx43hogdge@gabell>
 <20181016151353.punyk7exekut2543@gabell>
 <20181016191113.GI5212@zn.tnic>
 <20181016195429.tovdgqq77gz3eek2@gabell>
 <20181016195902.GK5212@zn.tnic>
 <20181022154204.kagmdb55jtoez4ca@gabell>
 <20181025103345.GF14020@nazgul.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181025103345.GF14020@nazgul.tnic>
Sender: linux-kernel-owner@vger.kernel.org
To: Borislav Petkov <bp@alien8.de>
Cc: Baoquan He <bhe@redhat.com>, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Chao Fan <fanc.fnst@cn.fujitsu.com>, linux-kernel@vger.kernel.org, x86@kernel.org, linux-efi@vger.kernel.org, linux-acpi@vger.kernel.org, mingo@redhat.com, hpa@zytor.com, keescook@chromium.org, rjw@rjwysocki.net, lenb@kernel.org, ard.biesheuvel@linaro.org, indou.takao@jp.fujitsu.com, caoj.fnst@cn.fujitsu.com
List-Id: linux-efi@vger.kernel.org

On Thu, Oct 25, 2018 at 12:33:45PM +0200, Borislav Petkov wrote:
> On Mon, Oct 22, 2018 at 11:42:05AM -0400, Masayoshi Mizuma wrote:
> > I'm trying to store the SRAT info and pass it to kernel_randomize_memory(),
> > looks like add_e820ext()/parse_setup_data().
> > 
> > Is the approach useful only EFI environment? I'm not sure how I
> 
> Does it matter for non-EFI even?
> 
> I mean, you want this code only for your use case - when you have
> movable memory and you're doing kexec, yes?
> 
> And those machines are all EFI boxes I'd assume...

My actual use case is for EFI boxes, however, I think it's better to useful
for legacy BIOS as well because memory hot-plug affinity in SRAT and KASLR
are available on legacy BIOS.
Actually, we can create such environment in qemu.

I have another idea to solve this issue. Adding a SRAT parsing code
to arch/x86/mm/kaslr.c. It is useful for both EFI and BIOS and
also we don't need a new kernel parameter...
Dose the idea make sense?

Thanks,
Masa
