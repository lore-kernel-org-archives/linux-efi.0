From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: EFI boot problem in 3.11
Date: Sat, 26 Oct 2013 16:51:00 +0100
Message-ID: <20131026155100.GC1982@console-pimps.org>
References: <32EA1272-FF5B-4FAA-B136-1447BF6F9876@rf.net.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <32EA1272-FF5B-4FAA-B136-1447BF6F9876-NpJDBqUeXo2lVyrhU4qvOw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jasper Bryant-Greene <jbg-NpJDBqUeXo2lVyrhU4qvOw@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, 24 Oct, at 12:14:26PM, Jasper Bryant-Greene wrote:
> I have a box here which is set up for EFI boot with no boot loader.
>=20
> The kernel is compiled with a built-in initrd and command line.
>=20
> In 3.10 this was all working well. However, after updating to 3.11.5 =
a
> reboot leads to the EFI firmware boot screen appearing followed by th=
e
> middle section of it going black (just leaving two vertical stripes o=
f
> the EFI firmware boot screen on either side of the screen) and the
> system locking up (numlock etc do not work).
>=20
> However, if I hit =E2=80=98delete=E2=80=99 quickly when powering on, =
and enter the
> firmware setup screen, I can then =E2=80=98exit without saving=E2=80=99=
 and the system
> will boot successfully =E2=80=94 =E2=80=98save and exit=E2=80=99 does=
 not work as that
> performs a full reboot while =E2=80=98exit without saving=E2=80=99 se=
ems to continue
> the boot where it left off.
>=20
> Due to the aforementioned graphics corruption, I am wondering whether
> it is somehow related to the frame buffer? As this is a production
> system I unfortunately do not have flexibility to try a number of
> kernel versions in-between to locate where the issue was introduced.

Nothing springs to mind and nothing jumps out of the log in
drivers/video or arch/x86/platform/efi.

The best way to figure out what's causing this issue really is to bisec=
t
the kernel versions. What hardware are you running on?

--=20
Matt Fleming, Intel Open Source Technology Center
