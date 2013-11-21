From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Subject: Re: [PATCH] x86, efi: change name of efi_no_storage_paranoia parameter
 to efi_storage_paranoia
Date: Thu, 21 Nov 2013 18:13:59 +0900
Message-ID: <528DCED7.5070806@jp.fujitsu.com>
References: <527C93B5.7010407@jp.fujitsu.com> <527C9B5C.6040509@nod.at>  <527CB013.30200@jp.fujitsu.com> <527CB0F4.8080606@nod.at>  <527CBC05.6080505@jp.fujitsu.com> <527CBD01.1000908@nod.at>  <527CBDD3.2020609@jp.fujitsu.com>  <20131108143421.GB22636@console-pimps.org>  <52809AEB.9080100@jp.fujitsu.com>  <20131111105424.GD22636@console-pimps.org>  <528AD50D.6060503@jp.fujitsu.com> <87siutqdwv.fsf@redhat.com>  <528C562B.3070008@jp.fujitsu.com> <1384934881.6516.4082.camel@linux-s257.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1384934881.6516.4082.camel@linux-s257.site>
Sender: linux-kernel-owner@vger.kernel.org
To: joeyli <jlee@suse.com>
Cc: Madper Xie <cxie@redhat.com>, Matt Fleming <matt@console-pimps.org>, Richard Weinberger <richard@nod.at>, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, matt.fleming@intel.com, matthew.garrett@nebula.com
List-Id: linux-efi@vger.kernel.org

(2013/11/20 17:08), joeyli wrote:
> =E6=96=BC =E4=B8=89=EF=BC=8C2013-11-20 =E6=96=BC 15:26 +0900=EF=BC=8C=
Yasuaki Ishimatsu =E6=8F=90=E5=88=B0=EF=BC=9A
>> (2013/11/19 12:16), Madper Xie wrote:
>>>
>>> isimatu.yasuaki@jp.fujitsu.com writes:
>>>
>>>> Hi Matt,
>>>>
>>>> Sorry for late the reply.
>>>>
>>>>
>>>> (2013/11/11 19:54), Matt Fleming wrote:
>>>>> On Mon, 11 Nov, at 05:52:59PM, Yasuaki Ishimatsu wrote:
>>>>>> Hi Matt,
>>>>>>
>>>>>> I uses FUJITSU's x86 box.
>>>>>> This does not become bricked even if I use all efi variable stor=
age.
>>>>>> Thus I want a way to not need to specify efi_no_storage_paranoia
>>>>>> parameter.
>>>>>
>>>>> The efi_no_storage_paranoia parameter was introduced because some
>>>>> machines do not initiate garbage collection of the NVRAM until yo=
u
>>>>> allocate all space - basically it's a switch to turn off the "sav=
e 5KB
>>>>> of stoarge at all times" workaround that is needed to avoid brick=
ing
>>>>> some machines.
>>>>>
>>>>> The intention of the switch is not to allow you to fill your NVRA=
M just
>>>>> because you can. If that is something you want to do then I think=
 it's
>>>>> fair to require you to explicitly turn on efi_no_storage_paranoia=
=2E But
>>>>> I'm assuming here that you are doing something like writing lots =
and
>>>>> lots of pstore entries and just want to write as many as your var=
iable
>>>>> storage will allow? Or are you doing something more fundamental l=
ike
>>>>> creating BootXXXX entries?
>>>>>
>>>>> What are you doing to run into the 5KB reserve? How much NVRAM do=
es your
>>>>> machine come with?
>>>>
>>>> I just add boot entry to NVRAM by efibootmgr command. But when Lin=
ux boots up,
>>>> the remaining NVRAM is less than 5Kbyte. So I cannnot add new entr=
y.
>>>>
>>> Howdy Yasuaki,
>>>     If the remaining NVRAM is less than 5Kb, your writing will trig=
ger a
>>>     NVRAM storage reclamation. However you still failed creating en=
try. So
>>>     I'm just curious what itmes occupy lots of nvram storage space.
>>
>> Even if we got EFI_OUT_OF_RESOURCES while running Linux, gc does not=
 run.
>> Trigger of gc is when EFI_OUT_OF_RESOURCES occurs on pre OS environm=
ent with
>> UEFI. So on my system, if EFI_OUT_OF_RESOURCES occurs by the 5Kbyte =
threshold,
>> we cannot use nvram storage until EFI_OUT_OF_RESOURCES occurs on pre=
 OS
>> environment with UEFI.
>>
>> Thanks,
>> Yasuaki Ishimatsu
>
> Can we try to trigger gc by EFI_OUT_OF_RESOURCE in EFI stub kernel or
> EFI boot loader to recover NVRAM space? Does work with the BIOS on th=
is
> machine?

Yes. I can trigger gc by EFI_OUT_OF_RESOUCE in EFI shell on my machine.

Thanks,
Yasuaki Ishimatu

>
>
> Thanks a lot!
> Joey Lee
>
