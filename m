From: Richard Weinberger <richard@nod.at>
Subject: Re: [PATCH] x86, efi: change name of efi_no_storage_paranoia parameter
 to efi_storage_paranoia
Date: Fri, 08 Nov 2013 11:29:21 +0100
Message-ID: <527CBD01.1000908@nod.at>
References: <527C93B5.7010407@jp.fujitsu.com> <527C9B5C.6040509@nod.at> <527CB013.30200@jp.fujitsu.com> <527CB0F4.8080606@nod.at> <527CBC05.6080505@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <527CBC05.6080505@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, matt.fleming@intel.com, matthew.garrett@nebula.com, jlee@suse.com
List-Id: linux-efi@vger.kernel.org

Am 08.11.2013 11:25, schrieb Yasuaki Ishimatsu:
> (2013/11/08 18:37), Richard Weinberger wrote:
>> Am 08.11.2013 10:34, schrieb Yasuaki Ishimatsu:
>>> (2013/11/08 17:05), Richard Weinberger wrote:
>>>> Am 08.11.2013 08:33, schrieb Yasuaki Ishimatsu:
>>>>> By following works, my system very often fails set_variable() to set new
>>>>> variable to efi variable storage and shows "efivars: set_variable() failed:
>>>>> status=-28" message.
>>>>>
>>>>> - commit 31ff2f20d9003e74991d135f56e503fe776c127c
>>>>>       efi: Distinguish between "remaining space" and actually used space
>>>>> - commit 8c58bf3eec3b8fc8162fe557e9361891c20758f2
>>>>>       x86,efi: Implement efi_no_storage_paranoia parameter
>>>>> - commit f8b8404337de4e2466e2e1139ea68b1f8295974f
>>>>>       Modify UEFI anti-bricking code
>>>>>
>>>>> When booting my system, remaining space of efi variable storage is about
>>>>> 5KB. So there is no room that sets a new variable to the storage.
>>>>>
>>>>> According to above works, efi_no_storage_paranoia parameter was prepared
>>>>> for sane UEFI which can do gc and fulfills spec. But why need a system
>>>>> with a sane UEFI set the parameter? It is wrong. A system with a broken
>>>>> UEFI should set the parameter.
>>>>
>>>> And how does one know that his UEFI is broken?
>>>
>>> I have no idea. But at least, bricked board is broken UEFI.
>>> Do you know the issue occurs on several boards or specific board?
>>
>> On *many* boards including laptops....
>> Please read the history of the whole issue.
> 
> Thank you for your comment.
> I has read git log. But there is no information like this.
> So I will read them of related threads again. Do you know good threads
> to know the history of the issue?

Everything started with an issue that killed Samsung laptops:
http://mjg59.dreamwidth.org/22855.html

Later it was found that if you write too much into UEFI variables many
UEFI implementations will do bad things.

Thanks,
//richard
