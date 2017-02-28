From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 0/2] efi: Enhance capsule loader to support signed Quark images
Date: Tue, 28 Feb 2017 13:25:13 +0000
Message-ID: <CAKv+Gu-OCr1nX0-kWnWg4=DnDpZvM-ipSCfLbBA8h1e5eJYBbw@mail.gmail.com>
References: <cover.1487182480.git.jan.kiszka@siemens.com> <CAHp75VeVZo8f_aXZ=R8Y+++RSQeT=tFZmL6NNfekKJTkJc-nZA@mail.gmail.com>
 <1bf3c9d8-56aa-818b-350f-deb62ad14e08@siemens.com> <4014c5e6-b5a0-7552-166f-a42992532c09@siemens.com>
 <F54AEECA5E2B9541821D670476DAE19C5DE533B3@PGSMSX102.gar.corp.intel.com>
 <f4f63644-e099-b192-5337-15c07d761fb4@nexus-software.ie> <F54AEECA5E2B9541821D670476DAE19C5DE5373E@PGSMSX102.gar.corp.intel.com>
 <5da59d02-d299-f5c7-48fa-a67bdd017252@siemens.com> <20170228121255.GD28416@codeblueprint.co.uk>
 <fb94de5b-e359-ab8d-bb9b-52efcad91bc5@siemens.com> <20170228122947.GE28416@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170228122947.GE28416-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>, "Kweh, Hock Leong" <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Bryan O'Donoghue <pure.logic-SyKdqv6vbfZdzvEItQ6vdLNAH6kLmebB@public.gmane.org>, Andy Shevchenko <andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, "Ong, Boon Leong" <boon.leong.ong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Mok, Tze Siong" <tze.siong.mok-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 28 February 2017 at 12:29, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:
> On Tue, 28 Feb, at 01:20:25PM, Jan Kiszka wrote:
>>
>> From you POV, does this exclude upstream quirk support for already
>> shipped devices?
>
> It would need to be an extremely small, well-contained change, that
> had no chance of disrupting other users of the capsule interface and
> where I had a good feeling that supporting it wouldn't turn into a
> maintenance nightmare (mountains of DMI strings or new platforms
> coming to market that used it).
>
> That's a tall order, and I'm pretty skeptical. Still, I'll never say
> never. Plus Ard would need convincing to give his ACK too.
>
> P.S. Has anyone actually investigated what would be required to fix
> the firmware to be able to extract the CSH if it was contained inside
> a capsule?

As I said before, I'd be ok with it if we select it compile time,
i.e., no runtime logic that infers whether we are running on such a
system or not, and no carrying both implementations in all kernels
that have capsule loading built in.

But I do realise that it increases the validation space for Matt,
given that he does the testing on the x86 side. For the ARM side of
things, the Kconfig option would simply not be settable. So I am going
to let Matt have the final word on this.
