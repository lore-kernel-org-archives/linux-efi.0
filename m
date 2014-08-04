From: Matt Fleming <matt@console-pimps.org>
Subject: Re: 3.12 to 3.13 boot regression bisected - still applies to 3.16
Date: Mon, 4 Aug 2014 14:54:52 +0100
Message-ID: <20140804135452.GJ15082@console-pimps.org>
References: <20140804113435.34ed8c76@pluto>
 <20140804122728.GH15082@console-pimps.org>
 <20140804150627.4563b6a7@pluto>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140804150627.4563b6a7@pluto>
Sender: linux-kernel-owner@vger.kernel.org
To: Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: P J P <ppandit@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Mon, 04 Aug, at 03:06:27PM, Bruno Pr=E9mont wrote:
>=20
> Yes, I did as I have seen that patch flying by, but it did not help
> (I tried at 3.16-rc7).
=20
:-( Thanks for testing.

> On 3.16-rc7 I even tried adding earlyprintk=3Defi,keep, console=3Defi=
,
> ignore_loglevel and added some efi_printk() in EFI stub (in the spiri=
t
> of https://bugzilla.kernel.org/show_bug.cgi?id=3D68761)
> The last message I get is my efi_printk() right before exiting boot
> services. Without my efi_printk() there is no output at all.
>=20
> Then system reboots.

OK, so the fact that the system reboots suggests that the boot
stub/kernel caused a fault.
=20
> There is no output on serial console either (via BMC),
> (earlycon=3Duart,io,0x3f8,115200 or earlyprintk=3Dserial,ttyS0,115200=
)
>=20
>=20
> I even tried without initrd (setting CONFIG_INITRAMFS_SOURCE=3D"")
> and got the same end-result.

Oh that's interesting.

> I could share a slightly modified one, replacing the
> contained /etc/passwd. It's about 16MiB in size due to RAID controlle=
r
> management blobs for recovery. Except for that it just tries to find
> ROOT partition, setting up dmcrypt if needed.
=20
This shouldn't be necessary if you can reproduce the issue without an
initrd as you stated above.

> Any hint on how to find out what fails would be nice!
> initrd issues tend not to be easy to debug (it would help if initrd
> issues could be reported at the time kernel tries to start init - e.g=
=2E
> when console outputs are up and running).

I don't think this is necessarily an initrd issue.

The way that I would debug this is to insert while(1); into strategic
places. Yes, it's lame and time consuming, but it's effective.

My first suggestion would be setup_arch(). In particular, because your
machine is resetting, I'd guess that the kernel's early trap handlers
haven't yet been installed.

So throw a,

	while (1);

in there and see if you can get your machine to hang instead of reset.
If it doesn't hang, the reset occurs earlier in boot - work backwards.
If it does hang then you know that execution gets at least that far -
work forwards. Like I said, lame but effective.

Meanwhile I'm going to go and stare at the EFI boot stub code and
instrument OVMF to check for more memory corruption bugs like the one
Michael found in commit c7fb93ec51d4 ("x86/efi: Include a .bss section
within the PE/COFF headers").

--=20
Matt Fleming, Intel Open Source Technology Center
