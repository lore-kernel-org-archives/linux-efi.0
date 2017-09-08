From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 5/7] arm: efi: split zImage code and data into separate
 PE/COFF sections
Date: Fri, 8 Sep 2017 15:48:23 +0100
Message-ID: <CAKv+Gu8e49ZmB6X=H2vE_dw1HA3CyOq0GN7cZOYJ+JpkTftGWA@mail.gmail.com>
References: <20170629081849.15081-1-ard.biesheuvel@linaro.org>
 <20170629081849.15081-6-ard.biesheuvel@linaro.org> <87r2vhs3il.fsf@free-electrons.com>
 <CAKv+Gu9DVRE6jGEvdkfWwaJDhmTeaF2-CMi=JdFx3GS2Qqdy3A@mail.gmail.com>
 <CAKv+Gu9UF7-Dyjijvbc97yEF6zehQMyjOcV=RxFEJkNEebakUw@mail.gmail.com> <87mv65s1iu.fsf@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87mv65s1iu.fsf-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gregory CLEMENT <gregory.clement-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Russell King <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Andrew Lunn <andrew-g2DYL2Zd6BY@public.gmane.org>, Jason Cooper <jason-NLaQJdtUoK4Be96aLqz0jA@public.gmane.org>, Sebastian Hesselbarth <sebastian.hesselbarth-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Petazzoni <thomas.petazzoni-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, Miquel RAYNAL <miquel.raynal-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, =?UTF-8?Q?Antoine_T=C3=A9nart?= <antoine.tenart-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 8 September 2017 at 15:33, Gregory CLEMENT
<gregory.clement-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org> wrote:
> Hi Ard,
>
>  On ven., sept. 08 2017, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
>
>> On 8 September 2017 at 14:54, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
>>> On 8 September 2017 at 14:50, Gregory CLEMENT
>>> <gregory.clement-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org> wrote:
>>>> Hi Ard,
>>>>
>>>>  On jeu., juin 29 2017, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
>>>>
>>>>> To prevent unintended modifications to the kernel text (malicious or
>>>>> otherwise) while running the EFI stub, describe the kernel image as
>>>>> two separate sections: a .text section with read-execute permissions,
>>>>> covering .text, .rodata, .piggytext and the GOT sections (which the
>>>>> stub does not care about anyway), and a .data section with read-write
>>>>> permissions, covering .data and .bss.
>>>>>
>>>>> This relies on the firmware to actually take the section permission
>>>>> flags into account, but this is something that is currently being
>>>>> implemented in EDK2, which means we will likely start seeing it in
>>>>> the wild between one and two years from now.
>>>>
>>>> This patch had been merged in mainline yesterday and now prevent the
>>>> Marvell Armada 370 and the Armada XP based SoC to boot. I also suspect
>>>> that more Socs are impacted because the number of boot fail exploded
>>>> according to kci:
>>>> https://kernelci.org/boot/all/job/mainline/branch/master/kernel/v4.13-8899-g8dc5b3a6cb2f/
>>>>
>>>
>>> Ouch.
>>>
>>>> I found this patch after bisecting (I can provide the bisect log if
>>>> needed).
>>>>
>>>> The kernel failed to boot only if CONFIG_EFI is enabled so it occurs in
>>>> multi_v7_defconfig but not with mvebu_v7_defconfig.
>>>>
>>>> Currently the solution is to revert this patch.
>>>>
>>>> Have you a better option?
>>>>
>>>
>>> I will investigate.
>>
>> I cannot reproduce this on QEMU or my Beaglebone white. I have tried a
>> locally built zImage as well as the one built by kernelci.
>>
>> Could you please try whether this fixes things? It does not explain
>> anything but it will help me figure out what is going on (hopefully)
>
> I've just tested this change and it didn't fix anything.
>
> Gregory
>
>>
>>
>> diff --git a/arch/arm/boot/compressed/efi-header.S
>> b/arch/arm/boot/compressed/efi-header.S
>> index c94a88ae834d..671a6e5b7b99 100644
>> --- a/arch/arm/boot/compressed/efi-header.S
>> +++ b/arch/arm/boot/compressed/efi-header.S
>> @@ -127,7 +127,7 @@ section_table:
>>
>>                 .set    section_count, (. - section_table) / 40
>>
>> -               .align  12
>> +               .align  9
>>  __efi_start:
>>  #endif
>>                 .endm
>


How about this?

diff --git a/arch/arm/boot/compressed/vmlinux.lds.S
b/arch/arm/boot/compressed/vmlinux.lds.S
index 7a4c59154361..dfcc2baa0077 100644
--- a/arch/arm/boot/compressed/vmlinux.lds.S
+++ b/arch/arm/boot/compressed/vmlinux.lds.S
@@ -29,6 +29,11 @@ SECTIONS
      * of the text/got segments.
      */
     *(.data)
+    /*
+     * C code that is shared with the kernel proper (but rebuilt for the
+     * decompressor) may contain exports that we have no use for here.
+     */
+    *(*ksymtab* *kcrctab*)
   }

   . = TEXT_START;
