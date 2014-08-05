From: Matt Fleming <matt@console-pimps.org>
Subject: Re: 3.12 to 3.13 boot regression bisected - still applies to 3.16
Date: Tue, 5 Aug 2014 09:45:42 +0100
Message-ID: <20140805084542.GM15082@console-pimps.org>
References: <20140804113435.34ed8c76@pluto>
 <20140804122728.GH15082@console-pimps.org>
 <20140804150627.4563b6a7@pluto>
 <20140804135452.GJ15082@console-pimps.org>
 <20140805100242.425e1093@pluto>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140805100242.425e1093@pluto>
Sender: linux-kernel-owner@vger.kernel.org
To: Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: P J P <ppandit@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Tue, 05 Aug, at 10:02:42AM, Bruno Pr=E9mont wrote:
>=20
> I tried in setup_arch(), but system still keeps rebooting.
>=20
> Working backwards I got to x86_64_start_kernel() in
> arch/x86/kernel/head64.c but system is still rebooting.
=20
Thanks for doing this. I'm sure it was a major PITA ;-)

> Not sure what happens before x86_64_start_kernel() is called, it seem=
s
> to be called from ASM code in arch/x86/kernel/head_64.S.
=20
Yep. Roughly the code flow goes like this (chronologically),

  efi_pe_entry()	[arch/x86/boot/compressed/head_64.S]
    efi_main()		[arch/x86/boot/compressed/eboot.c]
  startup_64		[arch/x86/kernel/head_64.S]
  secondary_startup64	[arch/x86/kernel/head_64.S]
  x86_64_start_kernel()	[arch/x86/kernel/head64.c]

> > Meanwhile I'm going to go and stare at the EFI boot stub code and
> > instrument OVMF to check for more memory corruption bugs like the o=
ne
> > Michael found in commit c7fb93ec51d4 ("x86/efi: Include a .bss sect=
ion
> > within the PE/COFF headers").
>=20
> If there are places between exit_boot() in
> arch/x86/boot/compressed/eboot.c and x86_64_start_kernel() where I
> should include such loops, please tell!

I guess we need to verify efi_main() actually exits correctly. So a
while (1); loop at the end of that function would be useful.

Assuming that does actually hang, you get the fun of rummaging around i=
n
the early assembly code, where you can use something like this,

bruno:
	hlt
	jmp bruno

to try and force a hang.

Could you also attach your .config? In particular I'm wondering whether
you've got CONFIG_RELOCATBLE enabled.

--=20
Matt Fleming, Intel Open Source Technology Center
