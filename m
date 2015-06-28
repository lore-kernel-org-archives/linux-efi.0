From: Tom Yan <tom.ty89-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: lower log level of efi-bgrt / handle status 0
Date: Mon, 29 Jun 2015 01:10:52 +0800
Message-ID: <CAGnHSEnBNr-HVaUMjRqPK104mV1r16uDsktob+9WADr84fBh0w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

My motherboard is ASUS H87-PRO which has UEFI BIOS. The kernel gives
the following error on every boot:

Ignoring BGRT: invalid status 0 (expected 1)

This happens when the "Boot Logo" BIOS option is set to "Auto" (AND
using a PCI-E display card, IIRC). According to the mobo's manual,
"Auto" means:

"Automatically adjust the boot logo size according to Windows requirements."

while the error will be gone if I set it to "Full Screen" (which makes
the boot logo look huge and ugly) or "Disabled" instead.

The thing is nothing really goes wrong when I choose "Auto" except
from keep seeing that error. So could you make it accept/handle status
0, or at least lower the log level of messages in efi-bgrt? I can see
that all of them make use of pr_err() and I wonder how important is
this BGRT thing.
