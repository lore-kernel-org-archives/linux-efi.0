From: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: [PATCH 0/2] efi: Enhance capsule loader to support signed Quark images
Date: Tue, 28 Feb 2017 19:18:58 +0200
Message-ID: <CAHp75VdELFFeoJXXHbsHHuyd2xBY0y4T+M7q5+ZFN=ep3Qy9HQ@mail.gmail.com>
References: <cover.1487182480.git.jan.kiszka@siemens.com> <CAHp75VeVZo8f_aXZ=R8Y+++RSQeT=tFZmL6NNfekKJTkJc-nZA@mail.gmail.com>
 <1bf3c9d8-56aa-818b-350f-deb62ad14e08@siemens.com> <4014c5e6-b5a0-7552-166f-a42992532c09@siemens.com>
 <F54AEECA5E2B9541821D670476DAE19C5DE533B3@PGSMSX102.gar.corp.intel.com>
 <f4f63644-e099-b192-5337-15c07d761fb4@nexus-software.ie> <F54AEECA5E2B9541821D670476DAE19C5DE5373E@PGSMSX102.gar.corp.intel.com>
 <5da59d02-d299-f5c7-48fa-a67bdd017252@siemens.com> <20170228121255.GD28416@codeblueprint.co.uk>
 <fb94de5b-e359-ab8d-bb9b-52efcad91bc5@siemens.com> <20170228122947.GE28416@codeblueprint.co.uk>
 <CAKv+Gu-OCr1nX0-kWnWg4=DnDpZvM-ipSCfLbBA8h1e5eJYBbw@mail.gmail.com>
 <CAHp75VcQ8ZoGqR=iOzVq0WbieMvGFnkTQZ-TBmwBTZT0B1NS_Q@mail.gmail.com>
 <CAHp75VcQcALWdcWAM-odAAnR1uEwE=4rOhtB2E9WtS84ORH8Qw@mail.gmail.com>
 <1fb1a428-672b-be4b-e05b-4363c4b286dd@nexus-software.ie> <CAHp75Vd-1RLX+-saZcK1+zMtAUEMDLo+QCiKhfCnr+_u6DSmmA@mail.gmail.com>
 <d5313198-dc0d-8627-cd9e-a9c0b706faa2@nexus-software.ie>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <d5313198-dc0d-8627-cd9e-a9c0b706faa2@nexus-software.ie>
Sender: linux-kernel-owner@vger.kernel.org
To: Bryan O'Donoghue <pure.logic@nexus-software.ie>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Matt Fleming <matt@codeblueprint.co.uk>, Jan Kiszka <jan.kiszka@siemens.com>, "Kweh, Hock Leong" <hock.leong.kweh@intel.com>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@alien8.de>, "Ong, Boon Leong" <boon.leong.ong@intel.com>, "Mok, Tze Siong" <tze.siong.mok@intel.com>
List-Id: linux-efi@vger.kernel.org

On Tue, Feb 28, 2017 at 6:52 PM, Bryan O'Donoghue
<pure.logic@nexus-software.ie> wrote:
> On 28/02/17 15:27, Andy Shevchenko wrote:
>> On Tue, Feb 28, 2017 at 5:07 PM, Bryan O'Donoghue
>> <pure.logic@nexus-software.ie> wrote:
>>> On 28/02/17 13:36, Andy Shevchenko wrote:
>>>> On Tue, Feb 28, 2017 at 3:35 PM, Andy Shevchenko
>>>> <andy.shevchenko@gmail.com> wrote:
>>>>> On Tue, Feb 28, 2017 at 3:25 PM, Ard Biesheuvel
>>>>> <ard.biesheuvel@linaro.org> wrote:
>>>>>> On 28 February 2017 at 12:29, Matt Fleming <matt@codeblueprint.co.uk> wrote:
>>>>>>> On Tue, 28 Feb, at 01:20:25PM, Jan Kiszka wrote:
>>>>>
>>>>>> As I said before, I'd be ok with it if we select it compile time,
>>>>>> i.e., no runtime logic that infers whether we are running on such a
>>>>>> system or not, and no carrying both implementations in all kernels
>>>>>> that have capsule loading built in.
>>>>>
>>>>> Actually it most likely that Quark kernel (kernel compiled to be run
>>>>> on Quark) will be ever used on the rest of (modern) x86 since it's
>>>>> 486+ architecture (kernel has specific option for it, 586TSC).
>>>>
>>>> + it's UP only!
>>>>
>>>>> So, we might just be dependent or chosen by Quark.
>>>>
>>>
>>> Still though the current ia32 kernel runs on Quark and all other ia32
>>> systems.
>>
>> How come? Quark has a silicon bug (SMP kernel might oops) and it is
>> not even i586!
>
> sorry if this is a bit long in advance...
>
> You mean a lock prefixed pagefault.
>
> For reference Quark should be considered CONFIG_M586TSC=y (or better)
> i.e. it's 586 ISA with a TSC added on.

So, if it would be CONFIG_M686=y then?
This is default for x86 32-bit kernels.

>
> I've been meaning to do a write up about this, since I've spent some
> time with a debugger doing an analysis of the fault. Basically any
> operation that is lock-prefixed that also page-faults pushes the address
> of the _previous_ instruction (not the instruction that faulted) onto
> the PF# stack. Which sucks.
>
> Obviously then when you IRET you will execute the previous instruction
> again - on return to user-space - as opposed to the instruction you
> faulted on.
>
> So it's nothing to do with SMP per se, except that the lock prefix was
> added to drive the #lock signal on future SMP versions of the part (that
> never happened). We discussed this @ the time Dave Jones did
>
> commit d4e1a0af1d3a88cdfc8c954d3005eb8745ec518d
> Author: Dave Jones <davej@redhat.com>
> Date:   Tue Oct 28 13:57:53 2014 -0400
>
>     x86: Don't enable F00F workaround on Intel Quark processors
>
> ... and we agreed to have a good look at lock prefixed instructions in
> the kernel. On !SMP builds there is (or was at the time anyway) alot of
> LOCK_PREFIX looking like this
>
> #ifdef CONFIG_SMP
> #define LOCK_PREFIX_HERE \
>                 ".pushsection .smp_locks,\"a\"\n"       \
>                 ".balign 4\n"                           \
>                 ".long 671f - .\n" /* offset */         \
>                 ".popsection\n"                         \
>                 "671:"
>
> #define LOCK_PREFIX LOCK_PREFIX_HERE "\n\tlock; "
>
> #else /* ! CONFIG_SMP */
> #define LOCK_PREFIX_HERE ""
> #define LOCK_PREFIX ""
> #endif
>
> Which meant that !SMP was safe. It was probably overkill though because
> kernel code shouldn't PF anyway.

So, would it work if CONFIG_SMP=y ?
(This is default for x86 32-bit kernels)

> !SMP ia32 builds should be fine and we have never actually seen _kernel_
> code die on SMP builds ... presumably (demonstrably) because lock
> prefixed operations in the kernel don't PF#.

Which doesn't guarantee that it will not oops at some circumstances.

>>> It would be a pity/shame to make this feature dependent on
>>> compiling a Quark specific kernel, after all its only a header on a
>>> capsule as opposed to a large hardware-level architectural divergence.
>>>
>>
>>> I'd still like us to try for a low-fat hook that would a big fat ia32
>>> kernel just work without having to force a user compile up a
>>> Quark-specific kernel.
>>
>> Can you elaborate how to run i686 kernel (which is default for x86
>> 32-bit AFAIK) on Quark?
>
> A kernel compiled like this
>
> make menuconfig ARCH=i386

I hope you care that it is equivalent to

make menuconfig ARCH=i686

> make bzImage -j 8
>
> will run just fine on Quark x1000 I do it regularly. CPUID ought to (and
> does) inform the runtime kernel of what to do re: MSRs etc.
>
> We won't execute xmm/mmx, we won't touch 686 specific MSRs etc, etc.

It is i*6*86 code still.

So, summarize, you state that
1. CONFIG_SMP=y and
2. CONFIG_M686=y and
3. Kernel works on Quark

Is it correct?

If 1 or 2 is not correct it means we can *not* use the same kernel on
Quark. Unfortunately.

-- 
With Best Regards,
Andy Shevchenko
