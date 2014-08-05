From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
Subject: Re: 3.12 to 3.13 boot regression bisected - still applies to 3.16
Date: Tue, 5 Aug 2014 10:02:42 +0200
Message-ID: <20140805100242.425e1093@pluto>
References: <20140804113435.34ed8c76@pluto>
	<20140804122728.GH15082@console-pimps.org>
	<20140804150627.4563b6a7@pluto>
	<20140804135452.GJ15082@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140804135452.GJ15082@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt@console-pimps.org>
Cc: P J P <ppandit@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Mon, 4 Aug 2014 14:54:52 +0100 Matt Fleming wrote:

> On Mon, 04 Aug, at 03:06:27PM, Bruno Pr=C3=A9mont wrote:
> >=20
> > Yes, I did as I have seen that patch flying by, but it did not help
> > (I tried at 3.16-rc7).
> =20
> :-( Thanks for testing.
>=20
> > On 3.16-rc7 I even tried adding earlyprintk=3Defi,keep, console=3De=
fi,
> > ignore_loglevel and added some efi_printk() in EFI stub (in the spi=
rit
> > of https://bugzilla.kernel.org/show_bug.cgi?id=3D68761)
> > The last message I get is my efi_printk() right before exiting boot
> > services. Without my efi_printk() there is no output at all.
> >=20
> > Then system reboots.
>=20
> OK, so the fact that the system reboots suggests that the boot
> stub/kernel caused a fault.
> =20
> > There is no output on serial console either (via BMC),
> > (earlycon=3Duart,io,0x3f8,115200 or earlyprintk=3Dserial,ttyS0,1152=
00)
> >=20
> >=20
> > I even tried without initrd (setting CONFIG_INITRAMFS_SOURCE=3D"")
> > and got the same end-result.
>=20
> Oh that's interesting.
>=20
> > I could share a slightly modified one, replacing the
> > contained /etc/passwd. It's about 16MiB in size due to RAID control=
ler
> > management blobs for recovery. Except for that it just tries to fin=
d
> > ROOT partition, setting up dmcrypt if needed.
> =20
> This shouldn't be necessary if you can reproduce the issue without an
> initrd as you stated above.

I just verified CONFIG_INITRAMFS_SOURCE=3D"" on 3.16 and it reboots.

> > Any hint on how to find out what fails would be nice!
> > initrd issues tend not to be easy to debug (it would help if initrd
> > issues could be reported at the time kernel tries to start init - e=
=2Eg.
> > when console outputs are up and running).
>=20
> I don't think this is necessarily an initrd issue.
>=20
> The way that I would debug this is to insert while(1); into strategic
> places. Yes, it's lame and time consuming, but it's effective.
>=20
> My first suggestion would be setup_arch(). In particular, because you=
r
> machine is resetting, I'd guess that the kernel's early trap handlers
> haven't yet been installed.
>=20
> So throw a,
>=20
> 	while (1);
>=20
> in there and see if you can get your machine to hang instead of reset=
=2E
> If it doesn't hang, the reset occurs earlier in boot - work backwards=
=2E
> If it does hang then you know that execution gets at least that far -
> work forwards. Like I said, lame but effective.

I tried in setup_arch(), but system still keeps rebooting.

Working backwards I got to x86_64_start_kernel() in
arch/x86/kernel/head64.c but system is still rebooting.

Not sure what happens before x86_64_start_kernel() is called, it seems
to be called from ASM code in arch/x86/kernel/head_64.S.

> Meanwhile I'm going to go and stare at the EFI boot stub code and
> instrument OVMF to check for more memory corruption bugs like the one
> Michael found in commit c7fb93ec51d4 ("x86/efi: Include a .bss sectio=
n
> within the PE/COFF headers").

If there are places between exit_boot() in
arch/x86/boot/compressed/eboot.c and x86_64_start_kernel() where I
should include such loops, please tell!

Bruno
