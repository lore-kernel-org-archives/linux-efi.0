From: Bryan O'Donoghue <pure.logic-SyKdqv6vbfZdzvEItQ6vdLNAH6kLmebB@public.gmane.org>
Subject: Re: [PATCH 0/2] efi: Enhance capsule loader to support signed Quark
 images
Date: Wed, 1 Mar 2017 14:02:01 +0000
Message-ID: <aaa5266a-ea40-ff07-0fd5-1368b2e88a01@nexus-software.ie>
References: <cover.1487182480.git.jan.kiszka@siemens.com>
 <F54AEECA5E2B9541821D670476DAE19C5DE533B3@PGSMSX102.gar.corp.intel.com>
 <f4f63644-e099-b192-5337-15c07d761fb4@nexus-software.ie>
 <F54AEECA5E2B9541821D670476DAE19C5DE5373E@PGSMSX102.gar.corp.intel.com>
 <5da59d02-d299-f5c7-48fa-a67bdd017252@siemens.com>
 <20170228121255.GD28416@codeblueprint.co.uk>
 <fb94de5b-e359-ab8d-bb9b-52efcad91bc5@siemens.com>
 <20170228122947.GE28416@codeblueprint.co.uk>
 <CAKv+Gu-OCr1nX0-kWnWg4=DnDpZvM-ipSCfLbBA8h1e5eJYBbw@mail.gmail.com>
 <CAHp75VcQ8ZoGqR=iOzVq0WbieMvGFnkTQZ-TBmwBTZT0B1NS_Q@mail.gmail.com>
 <CAHp75VcQcALWdcWAM-odAAnR1uEwE=4rOhtB2E9WtS84ORH8Qw@mail.gmail.com>
 <1fb1a428-672b-be4b-e05b-4363c4b286dd@nexus-software.ie>
 <CAHp75Vd-1RLX+-saZcK1+zMtAUEMDLo+QCiKhfCnr+_u6DSmmA@mail.gmail.com>
 <d5313198-dc0d-8627-cd9e-a9c0b706faa2@nexus-software.ie>
 <CAHp75VdELFFeoJXXHbsHHuyd2xBY0y4T+M7q5+ZFN=ep3Qy9HQ@mail.gmail.com>
 <ce0ddedb-ee72-8dba-0e60-8d5e2d7a69a0@nexus-software.ie>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <ce0ddedb-ee72-8dba-0e60-8d5e2d7a69a0-SyKdqv6vbfZdzvEItQ6vdLNAH6kLmebB@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Shevchenko <andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>, "Kweh, Hock Leong" <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, "Ong, Boon Leong" <boon.leong.ong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Mok, Tze Siong" <tze.siong.mok-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org



On 28/02/17 17:42, Bryan O'Donoghue wrote:
> On 28/02/17 17:18, Andy Shevchenko wrote:
>> On Tue, Feb 28, 2017 at 6:52 PM, Bryan O'Donoghue
>>> A kernel compiled like this
>>>
>>> make menuconfig ARCH=i386
>>
>> I hope you care that it is equivalent to
>>
>> make menuconfig ARCH=i686
>>
>>> make bzImage -j 8
>>>
>>> will run just fine on Quark x1000 I do it regularly. CPUID ought to (and
>>> does) inform the runtime kernel of what to do re: MSRs etc.
>>>
>>> We won't execute xmm/mmx, we won't touch 686 specific MSRs etc, etc.
>>
>> It is i*6*86 code still.
>>
>> So, summarize, you state that
>> 1. CONFIG_SMP=y and
>> 2. CONFIG_M686=y and
>> 3. Kernel works on Quark
>>
>> Is it correct?
>
> Logically yes. It's a very long time since I looked in detail. No harm
> in checking it out though.
>
> I'll compile up the above kernel this evening (GMT) and verify.
>
>

CONFIG_SMP=y - no difference - like I say it's PF# on lock prefix
                instructions, not SMP=y that's the problem here
CONFIG_M686=y (doesnt' boot)
CONFIG_M586TSC=y does boot

So yes M686 is not bootable on this part. My point to you about having a 
custom kernel though still stands, you shouldn't have to compile a quark 
specific kernel - just a 586TSC kernel with Quark support.

For example CentOS is bootable on Quark.


---
bod
