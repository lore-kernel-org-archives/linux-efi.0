From: Kay Sievers <kay-tD+1rO4QERM@public.gmane.org>
Subject: Re: [systemd-devel] [PATCH] Add syste-firmware-efi-efivars.mount for
 support automount EFI variable filesystem
Date: Wed, 24 Oct 2012 15:00:14 +0200
Message-ID: <CAPXgP11ov-2W=189WeT2jN5KDzu3CpSb5rJG=3s1AZ0W1YT+qQ@mail.gmail.com>
References: <1351075322-3824-1-git-send-email-jlee@suse.com>
 <20121024121246.GU19454@in.waw.pl> <CAPXgP10Jejdu6Q=4XDy0ujjX6kKX-efgCZxmPJJiV5YRfNCJ6Q@mail.gmail.com>
 <20121024122337.GV19454@in.waw.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121024122337.GV19454-wrcVdnn0TatmR6Xm/wNWPw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?UTF-8?Q?Zbigniew_J=C4=99drzejewski=2DSzmek?= <zbyszek-wrcVdnn0TatmR6Xm/wNWPw@public.gmane.org>
Cc: "Lee, Chun-Yi" <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, systemd-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Lee, Chun-Yi" <jlee-IBi9RG/b67k@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Oct 24, 2012 at 2:23 PM, Zbigniew J=C4=99drzejewski-Szmek
<zbyszek-wrcVdnn0TatmR6Xm/wNWPw@public.gmane.org> wrote:
> On Wed, Oct 24, 2012 at 02:17:39PM +0200, Kay Sievers wrote:
>> On Wed, Oct 24, 2012 at 2:12 PM, Zbigniew J=C4=99drzejewski-Szmek
>> <zbyszek-wrcVdnn0TatmR6Xm/wNWPw@public.gmane.org> wrote:
>> > On Wed, Oct 24, 2012 at 06:42:02PM +0800, Lee, Chun-Yi wrote:
>> >> Add units/sys-firmware-efi-efivars.mount rule for support automou=
nt EFI variable filesystem
>> >
>> > in systemd parlance, automount means autofs mount, but to have tha=
t, a
>> > second .automount unit is needed.  Please have a look at
>> > http://cgit.freedesktop.org/systemd/systemd/tree/units/proc-sys-fs=
-binfmt_misc.automount
>> > vs
>> > http://cgit.freedesktop.org/systemd/systemd/tree/units/proc-sys-fs=
-binfmt_misc.mount .
>> > Now the question is whether the loading of the fs is slow enough t=
o
>> > matter, ie. if it is actually beneficial to use automount instead =
of
>> > mounting directly.  Since the fs can be compiled as a module, than=
 it
>> > probably is.
>> >
>> > Also, would be nice to add a Documentation=3D line like in
>> > proc-sys-fs-binfmt_misc.automount.
>>
>> It might all not be worth it, and we might just add it to the
>> "unconditionally mounted" list in the compiled-in code (marked with
>> allowed-to-fail). It seems like the better option than having a moun=
t
>> unit, and a module-load force option.
> Probably should be measured by someone with UEFI.

I'll check that when it's merged; in 3.8, I guess.

> This will likely be
> a very rarely used fs

We will likely end up using it ourselves from PID1 to extract boot
loader performance data, just like we do the initrd and other timing
data there. So an automount might not give us any real advantage in
the end.

> so if the loading time is actually measureable,
> than automount probably makes sense.

On EFI systems it will not really be measurable, I guess. The mount is
almost free, because the superblock is in the kernel anyway, very much
like like proc, sysfs, devtmpfs.

=46or non-EFI systems, it might cause a "useless" kernel-initiated
modprobe, which we probably want to avoid by some condition.

>> The current mount unit would never trigger for modules, because the
>> path will not exist. An internal API mount will cause a trransparent
>> kernel-forked modprobe with the mount() syscall.
> Yeah, the ConditionPathExists would have to be dropped.

Right, but maybe we can key-off some other condition, which indicates
an EFI bootup, so we can avoid trying to mount things on systems where
it can't be there.

Looking at if from a distance:
I guess the kernel should just start mounting its "crap" on its own,
instead of relying on userspace to know anything about this
ever-changing stuff. This filesytem is just a directory in /sys,
nothing else for userspace to know about it.

Requiring to patch userspace to mirror the fashion-of-the-month kernel
setup really does not scale in the longer run. Userspace really does
not want to know all these things. It has the right to, and wants to
be "stupid" here, and does not really want to fiddle around in such
kernel-internals.

It might be time to think all this through, it seems very much like an
entirely needless loop to jump through userspace here.

Kay
