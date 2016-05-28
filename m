From: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: BGRT warns again on my system
Date: Sat, 28 May 2016 13:46:07 -0700
Message-ID: <CALCETrUJ2QoUSYY82Q1BN3niasiunktnrmdE9Lmi2PZnCJRdag@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?UTF-8?Q?M=C3=B4she_van_der_Sterre?= <me-A/3C56C7qwM@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

My garbage workstation splats like this on boot:

[    0.160523] ioremap: invalid physical address d0c801800000001

This was fixed for a while, but I think the problem was reintroduced by=
:

commit 66dbe99cfe30e113d2e571e68b9b6a1a8985a157
Author: M=C3=B4she van der Sterre <me-A/3C56C7qwM@public.gmane.org>
Date:   Mon Feb 1 22:07:03 2016 +0000

    x86/efi/bgrt: Don't ignore the BGRT if the 'valid' bit is 0

Is there any good way to fix this again?
