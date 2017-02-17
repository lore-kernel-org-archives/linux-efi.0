From: Bryan O'Donoghue <pure.logic-SyKdqv6vbfZdzvEItQ6vdLNAH6kLmebB@public.gmane.org>
Subject: Re: [PATCH 0/2] efi: Enhance capsule loader to support signed Quark
 images
Date: Fri, 17 Feb 2017 09:51:47 +0000
Message-ID: <89831548-506f-9199-57ae-400ce020081a@nexus-software.ie>
References: <cover.1487182480.git.jan.kiszka@siemens.com>
 <CAHp75VeVZo8f_aXZ=R8Y+++RSQeT=tFZmL6NNfekKJTkJc-nZA@mail.gmail.com>
 <1bf3c9d8-56aa-818b-350f-deb62ad14e08@siemens.com>
 <4014c5e6-b5a0-7552-166f-a42992532c09@siemens.com>
 <F54AEECA5E2B9541821D670476DAE19C5DE533B3@PGSMSX102.gar.corp.intel.com>
 <f4f63644-e099-b192-5337-15c07d761fb4@nexus-software.ie>
 <F54AEECA5E2B9541821D670476DAE19C5DE5373E@PGSMSX102.gar.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <F54AEECA5E2B9541821D670476DAE19C5DE5373E-j2khPEwRog0FyVwBAnZdSLfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Kweh, Hock Leong" <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>, Andy Shevchenko <andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, "Ong, Boon Leong" <boon.leong.ong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Mok, Tze Siong" <tze.siong.mok-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 17/02/17 08:23, Kweh, Hock Leong wrote:
> And to have UEFI expand
> it capsule support and take in signed binary would be a more secured way.
> So, influencing UEFI community to have such support would be the right
> move throughout the discussion. That is my summary.

CSH stands for "Clanton Secure Header" - Clanton being the internal
code-name for Quark X1000 prior to release.

There is no chance the UEFI standard (which can be used on ARM and
potentially other architectures) will accept a SoC specific
route-of-trust prepended header.

Sure some kind of binary signed headers might become part of the
standard eventually but, definitely _not_ a CSH.

The fact is CSH exists in the real-world and a UEFI firmware supports
accepting the CSH/UEFI-capsule pair for updating itself.

I think a far more practical solution is to accommodate the defacto
implementation (the only ? current implementation). To me it defies
reason to have Quark X1000 be the only system (that I know of) capable
of doing a capsule update - have capsule code in the kernel - but _not_
support the header prepended to that capsule that the Quark
firmware/bootrom require.

Right now the capsule code is dead code on Quark x1000. Let's do the
right thing and make it usable. I fully support having a
separate/parallel conversation with the UEFI body but, I'd be amazed if
the "Clanton Secure Header" made it into the standard...

-- 
bod
