From: Yasuaki Ishimatsu <isimatu.yasuaki-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [PATCH] x86, efi: change name of efi_no_storage_paranoia parameter
 to efi_storage_paranoia
Date: Mon, 11 Nov 2013 17:52:59 +0900
Message-ID: <52809AEB.9080100@jp.fujitsu.com>
References: <527C93B5.7010407@jp.fujitsu.com> <527C9B5C.6040509@nod.at> <527CB013.30200@jp.fujitsu.com> <527CB0F4.8080606@nod.at> <527CBC05.6080505@jp.fujitsu.com> <527CBD01.1000908@nod.at> <527CBDD3.2020609@jp.fujitsu.com> <20131108143421.GB22636@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131108143421.GB22636-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org, jlee-IBi9RG/b67k@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Hi Matt,

I uses FUJITSU's x86 box.
This does not become bricked even if I use all efi variable storage.
Thus I want a way to not need to specify efi_no_storage_paranoia
parameter.

Thanks,
Yasuaki Ishimatsu


(2013/11/08 23:34), Matt Fleming wrote:
> On Fri, 08 Nov, at 07:32:51PM, Yasuaki Ishimatsu wrote:
>>> Everything started with an issue that killed Samsung laptops:
>>> http://mjg59.dreamwidth.org/22855.html
>>>
>>> Later it was found that if you write too much into UEFI variables many
>>> UEFI implementations will do bad things.
>>
>> Thanks for the information.
>> I will read it.
>
> Out of curiosity, what hardware are you using?
>
