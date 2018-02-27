From: Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH v2 3/8] efi: Decode IA32/X64 Processor Error Info
 Structure
Date: Tue, 27 Feb 2018 20:09:44 +0100
Message-ID: <20180227190943.GQ26382@pd.tnic>
References: <20180226193904.20532-1-Yazen.Ghannam@amd.com>
 <20180226193904.20532-4-Yazen.Ghannam@amd.com>
 <20180227142531.GF26382@pd.tnic>
 <DM5PR12MB191637C1857C5D9499D08D66F8C00@DM5PR12MB1916.namprd12.prod.outlook.com>
 <20180227170423.GK26382@pd.tnic>
 <DM5PR12MB1916D78FE4EEF146EE1D8612F8C00@DM5PR12MB1916.namprd12.prod.outlook.com>
 <20180227180231.GO26382@pd.tnic>
 <DM5PR12MB1916230ED7225CE0EB00EDF1F8C00@DM5PR12MB1916.namprd12.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <DM5PR12MB1916230ED7225CE0EB00EDF1F8C00@DM5PR12MB1916.namprd12.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Ghannam, Yazen" <Yazen.Ghannam@amd.com>
Cc: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "ard.biesheuvel@linaro.org" <ard.biesheuvel@linaro.org>, "x86@kernel.org" <x86@kernel.org>, Tony Luck <tony.luck@intel.com>
List-Id: linux-efi@vger.kernel.org

On Tue, Feb 27, 2018 at 06:40:13PM +0000, Ghannam, Yazen wrote:
> Code readability.

Bullshit!

You can't tell me this:

	snprintf(newpfx, sizeof(newpfx), "%s ", pfx);

is less readable than:

	 snprintf(newpfx, sizeof(newpfx), "%s%s", pfx, INDENT_SP);

> 1) No one except debug and HW design folks, who will eventually get a
> report from a user.

Hahahha, yeah right.

The only people who get those reports are the maintainers of the code in
the kernel and the distro people who get all the bugs assigned to them.

And if they can't decode the error - it is Tony and me.

HW folks hear about it from us. And we go and decode the damn crap
*every* time. Do you catch my drift now?

> [    1.990948] [Hardware Error]:  Error 1, type: corrected 
> [    1.995789] [Hardware Error]:  fru_text: ProcessorError 
> [    2.000632] [Hardware Error]:   section_type: IA32/X64 processor error 
> [    2.005796] [Hardware Error]:   Validation Bits: 0x0000000000000207 
> [    2.010953] [Hardware Error]:   Local APIC_ID: 0x0 
> [    2.015991] [Hardware Error]:   CPUID Info: 
> [    2.020747] [Hardware Error]:   00000000: 00800f12 00000000 00400800 00000000 
> [    2.025595] [Hardware Error]:   00000010: 76d8320b 00000000 178bfbff 00000000 
> [    2.030423] [Hardware Error]:   00000020: 00000000 00000000 00000000 00000000 
> [    2.035198] [Hardware Error]:   Error Information Structure 0:
> [    2.039961] [Hardware Error]:    Error Structure Type: a55701f5-e3ef-43de-ac72-249b573fad2c
> [    2.049608] [Hardware Error]:    Error Structure Type: cache error
> [    2.054344] [Hardware Error]:    Validation Bits: 0x0000000000000001
> [    2.059046] [Hardware Error]:    Check Information: 0x0000000020540087
> [    2.063625] [Hardware Error]:     Validation Bits: 0x0087
> [    2.068032] [Hardware Error]:     Transaction Type: 0, Instruction
> [    2.072423] [Hardware Error]:     Operation: 5, instruction fetch
> [    2.076776] [Hardware Error]:     Level: 1
> [    2.081073] [Hardware Error]:     Overflow: true
> [    2.085360] [Hardware Error]:   Context Information Structure 0:
> [    2.089661] [Hardware Error]:    Register Context Type: MSR Registers (Machine Check and other MSRs)
> [    2.098487] [Hardware Error]:    Register Array Size: 0x0050
> [    2.103113] [Hardware Error]:    MSR Address: 0xc0002011
> [    2.107742] [Hardware Error]:    Register Array:
> [    2.112270] [Hardware Error]:    00000000: d8200000000a0151 0000000000000000
> [    2.116845] [Hardware Error]:    00000010: d010000000000000 0000000300000031
> [    2.121228] [Hardware Error]:    00000020: 000100b000000000 000000004a000000
> [    2.125514] [Hardware Error]:    00000030: 0000000000000000 0000000000000000
> [    2.129747] [Hardware Error]:    00000040: 0000000000000000 0000000000000000

Lemme simplify that error record:

[Hardware Error]:  Corrected Processor Error
[Hardware Error]:   APIC_ID: 0x0 | CPUID: 0x17|0x1|0x2
[Hardware Error]:    Type: cache error during instruction fetch
[Hardware Error]:    cache level 1
[Hardware Error]:    Overflow: true

See how much more readable it got! And it is only 5 lines. I can make it
even smaller.

If it were a critical, uncorrectable error, every line counts: imagine
you do the above fat record and the machine freezes at line 5.

Now, I admit that my vesion of the record is not enough to debug it
but it needs to contain only information which is clear and humanly
readable to debug. You can always dump the raw data underneath from the
tracepoint but make the beginning human readable.

Do you know what users say about your error record?

"Err, it says hardware error, is my machine broken? I need to replace my
CPU."

I read that on a weekly basis.

Do you know how expensive support calls are about such errors which are
completely unreadable to people? 20 engineers need to get on a call to
realize it was a dumb correctable error? Btw, this is one of the reasons
why we did the error collector.

So put yourself in the users' shoes, look at the error record and think
hard whether the information displayed is readable to humans.

Btw, decode_error_status() in mce_amd.c is an attempt to explain the
error severity - note the "no action required." thing. It is still not
good enough - people still throw hands in the air and run in headless
chicken mode.

-- 
Regards/Gruss,
    Boris.

SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
-- 
