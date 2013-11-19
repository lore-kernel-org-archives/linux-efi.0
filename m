From: Yasuaki Ishimatsu <isimatu.yasuaki-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [PATCH] x86, efi: change name of efi_no_storage_paranoia parameter
 to efi_storage_paranoia
Date: Tue, 19 Nov 2013 12:03:41 +0900
Message-ID: <528AD50D.6060503@jp.fujitsu.com>
References: <527C93B5.7010407@jp.fujitsu.com> <527C9B5C.6040509@nod.at> <527CB013.30200@jp.fujitsu.com> <527CB0F4.8080606@nod.at> <527CBC05.6080505@jp.fujitsu.com> <527CBD01.1000908@nod.at> <527CBDD3.2020609@jp.fujitsu.com> <20131108143421.GB22636@console-pimps.org> <52809AEB.9080100@jp.fujitsu.com> <20131111105424.GD22636@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131111105424.GD22636-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org, jlee-IBi9RG/b67k@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Hi Matt,

Sorry for late the reply.


(2013/11/11 19:54), Matt Fleming wrote:
> On Mon, 11 Nov, at 05:52:59PM, Yasuaki Ishimatsu wrote:
>> Hi Matt,
>>
>> I uses FUJITSU's x86 box.
>> This does not become bricked even if I use all efi variable storage.
>> Thus I want a way to not need to specify efi_no_storage_paranoia
>> parameter.
>
> The efi_no_storage_paranoia parameter was introduced because some
> machines do not initiate garbage collection of the NVRAM until you
> allocate all space - basically it's a switch to turn off the "save 5KB
> of stoarge at all times" workaround that is needed to avoid bricking
> some machines.
>
> The intention of the switch is not to allow you to fill your NVRAM just
> because you can. If that is something you want to do then I think it's
> fair to require you to explicitly turn on efi_no_storage_paranoia. But
> I'm assuming here that you are doing something like writing lots and
> lots of pstore entries and just want to write as many as your variable
> storage will allow? Or are you doing something more fundamental like
> creating BootXXXX entries?
>
> What are you doing to run into the 5KB reserve? How much NVRAM does your
> machine come with?

I just add boot entry to NVRAM by efibootmgr command. But when Linux boots up,
the remaining NVRAM is less than 5Kbyte. So I cannnot add new entry.

Thanks,
Yasuaki Ishimatsu
