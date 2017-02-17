From: Bryan O'Donoghue <pure.logic@nexus-software.ie>
Subject: Re: [PATCH 0/2] efi: Enhance capsule loader to support signed Quark
 images
Date: Fri, 17 Feb 2017 11:42:34 +0000
Message-ID: <ef2d9e8b-9a6e-4790-da1c-a76f1496fdcb@nexus-software.ie>
References: <cover.1487182480.git.jan.kiszka@siemens.com>
 <CAHp75VeVZo8f_aXZ=R8Y+++RSQeT=tFZmL6NNfekKJTkJc-nZA@mail.gmail.com>
 <1bf3c9d8-56aa-818b-350f-deb62ad14e08@siemens.com>
 <4014c5e6-b5a0-7552-166f-a42992532c09@siemens.com>
 <F54AEECA5E2B9541821D670476DAE19C5DE533B3@PGSMSX102.gar.corp.intel.com>
 <f4f63644-e099-b192-5337-15c07d761fb4@nexus-software.ie>
 <F54AEECA5E2B9541821D670476DAE19C5DE5373E@PGSMSX102.gar.corp.intel.com>
 <89831548-506f-9199-57ae-400ce020081a@nexus-software.ie>
 <87df71cd-8f45-351f-30bb-ac7e66005c2a@siemens.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87df71cd-8f45-351f-30bb-ac7e66005c2a@siemens.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jan Kiszka <jan.kiszka@siemens.com>, "Kweh, Hock Leong" <hock.leong.kweh@intel.com>, Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@alien8.de>, "Ong, Boon Leong" <boon.leong.ong@intel.com>, "Mok, Tze Siong" <tze.siong.mok@intel.com>
List-Id: linux-efi@vger.kernel.org

On 17/02/17 10:14, Jan Kiszka wrote:
> On 2017-02-17 10:51, Bryan O'Donoghue wrote:
>> On 17/02/17 08:23, Kweh, Hock Leong wrote:
>>> And to have UEFI expand
>>> it capsule support and take in signed binary would be a more secured way.
>>> So, influencing UEFI community to have such support would be the right
>>> move throughout the discussion. That is my summary.
>>
>> CSH stands for "Clanton Secure Header" - Clanton being the internal
>> code-name for Quark X1000 prior to release.
>>
>> There is no chance the UEFI standard (which can be used on ARM and
>> potentially other architectures) will accept a SoC specific
>> route-of-trust prepended header.
>>
>> Sure some kind of binary signed headers might become part of the
>> standard eventually but, definitely _not_ a CSH.
>>
>> The fact is CSH exists in the real-world and a UEFI firmware supports
>> accepting the CSH/UEFI-capsule pair for updating itself.
>>
>> I think a far more practical solution is to accommodate the defacto
>> implementation (the only ? current implementation). To me it defies
>> reason to have Quark X1000 be the only system (that I know of) capable
>> of doing a capsule update - have capsule code in the kernel - but _not_
>> support the header prepended to that capsule that the Quark
>> firmware/bootrom require.
>>
>> Right now the capsule code is dead code on Quark x1000. Let's do the
>> right thing and make it usable. I fully support having a
>> separate/parallel conversation with the UEFI body but, I'd be amazed if
>> the "Clanton Secure Header" made it into the standard...
>>
> 
> To be precise, CSH is only required on X102x. The X100x SoCs, those are
> also found on the Galileo Gen2 maker board, do not support secure boot
> and do not use the header.

The CSH is supported on the non-secure SoCs - the BSP on Gen1 certainly did.

https://downloadcenter.intel.com/download/23197/Intel-Quark-SoC-X1000-Board-Support-Package-BSP-

- > QuarkPlatformPkg/Platform/Dxe/PlatformInit/DxeCapsuleSecurity.c

CreateCapsuleBufferForWriting()

Looks like it will tolerate a lack of CSH but, obviously that's no
solution for the secure boot parts.

> IIRC, there used to be an eval system with
> the X1020 as well, but I think it's no longer available.
> 
> Interestingly, the capsule file found in Intel's Galileo firmware update
> package [1] contains the CSH header. But I only succeeded flashing it on
> a Gen2 by removing the header first.

Hmm - the out of the box firmware will accept capsules from the website.
Gen1 and Gen2 should be the same in that respect - if you use the BSP
kernel.

You should validate the out-of-the-box capsule update - with the kernel
on SPI flash works with the CSH in place.

Next step then is to get it working on tip-of-tree.

I have one Gen1 left (which I won't be experimenting with) - and I think
one Gen2 (which I don't especially mind blowing up).

Let's take the time to validate (or repudiate)

1. Out of the box BSP works with CSH capsules in place
2. New tip-of-tree addition supports CSH capsules

and review.

Stripping the CSH shouldn't be necessary (and breaks the secure boot
parts anyway).

-- 
bod
