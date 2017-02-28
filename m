From: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: [PATCH 0/2] efi: Enhance capsule loader to support signed Quark images
Date: Tue, 28 Feb 2017 17:27:40 +0200
Message-ID: <CAHp75Vd-1RLX+-saZcK1+zMtAUEMDLo+QCiKhfCnr+_u6DSmmA@mail.gmail.com>
References: <cover.1487182480.git.jan.kiszka@siemens.com> <CAHp75VeVZo8f_aXZ=R8Y+++RSQeT=tFZmL6NNfekKJTkJc-nZA@mail.gmail.com>
 <1bf3c9d8-56aa-818b-350f-deb62ad14e08@siemens.com> <4014c5e6-b5a0-7552-166f-a42992532c09@siemens.com>
 <F54AEECA5E2B9541821D670476DAE19C5DE533B3@PGSMSX102.gar.corp.intel.com>
 <f4f63644-e099-b192-5337-15c07d761fb4@nexus-software.ie> <F54AEECA5E2B9541821D670476DAE19C5DE5373E@PGSMSX102.gar.corp.intel.com>
 <5da59d02-d299-f5c7-48fa-a67bdd017252@siemens.com> <20170228121255.GD28416@codeblueprint.co.uk>
 <fb94de5b-e359-ab8d-bb9b-52efcad91bc5@siemens.com> <20170228122947.GE28416@codeblueprint.co.uk>
 <CAKv+Gu-OCr1nX0-kWnWg4=DnDpZvM-ipSCfLbBA8h1e5eJYBbw@mail.gmail.com>
 <CAHp75VcQ8ZoGqR=iOzVq0WbieMvGFnkTQZ-TBmwBTZT0B1NS_Q@mail.gmail.com>
 <CAHp75VcQcALWdcWAM-odAAnR1uEwE=4rOhtB2E9WtS84ORH8Qw@mail.gmail.com> <1fb1a428-672b-be4b-e05b-4363c4b286dd@nexus-software.ie>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1fb1a428-672b-be4b-e05b-4363c4b286dd@nexus-software.ie>
Sender: linux-kernel-owner@vger.kernel.org
To: Bryan O'Donoghue <pure.logic@nexus-software.ie>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Matt Fleming <matt@codeblueprint.co.uk>, Jan Kiszka <jan.kiszka@siemens.com>, "Kweh, Hock Leong" <hock.leong.kweh@intel.com>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@alien8.de>, "Ong, Boon Leong" <boon.leong.ong@intel.com>, "Mok, Tze Siong" <tze.siong.mok@intel.com>
List-Id: linux-efi@vger.kernel.org

On Tue, Feb 28, 2017 at 5:07 PM, Bryan O'Donoghue
<pure.logic@nexus-software.ie> wrote:
> On 28/02/17 13:36, Andy Shevchenko wrote:
>> On Tue, Feb 28, 2017 at 3:35 PM, Andy Shevchenko
>> <andy.shevchenko@gmail.com> wrote:
>>> On Tue, Feb 28, 2017 at 3:25 PM, Ard Biesheuvel
>>> <ard.biesheuvel@linaro.org> wrote:
>>>> On 28 February 2017 at 12:29, Matt Fleming <matt@codeblueprint.co.uk> wrote:
>>>>> On Tue, 28 Feb, at 01:20:25PM, Jan Kiszka wrote:
>>>
>>>> As I said before, I'd be ok with it if we select it compile time,
>>>> i.e., no runtime logic that infers whether we are running on such a
>>>> system or not, and no carrying both implementations in all kernels
>>>> that have capsule loading built in.
>>>
>>> Actually it most likely that Quark kernel (kernel compiled to be run
>>> on Quark) will be ever used on the rest of (modern) x86 since it's
>>> 486+ architecture (kernel has specific option for it, 586TSC).
>>
>> + it's UP only!
>>
>>> So, we might just be dependent or chosen by Quark.
>>
>
> Still though the current ia32 kernel runs on Quark and all other ia32
> systems.

How come? Quark has a silicon bug (SMP kernel might oops) and it is
not even i586!

> It would be a pity/shame to make this feature dependent on
> compiling a Quark specific kernel, after all its only a header on a
> capsule as opposed to a large hardware-level architectural divergence.
>

> I'd still like us to try for a low-fat hook that would a big fat ia32
> kernel just work without having to force a user compile up a
> Quark-specific kernel.

Can you elaborate how to run i686 kernel (which is default for x86
32-bit AFAIK) on Quark?

-- 
With Best Regards,
Andy Shevchenko
