From: Madper Xie <cxie-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] x86, efi: change name of efi_no_storage_paranoia parameter to efi_storage_paranoia
Date: Fri, 08 Nov 2013 16:46:19 +0800
Message-ID: <8761s3waas.fsf@redhat.com>
References: <527C93B5.7010407@jp.fujitsu.com> <527C9B5C.6040509@nod.at>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <527C9B5C.6040509-/L3Ra7n9ekc@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org, jlee-IBi9RG/b67k@public.gmane.org
List-Id: linux-efi@vger.kernel.org


richard-/L3Ra7n9ekc@public.gmane.org writes:

> Am 08.11.2013 08:33, schrieb Yasuaki Ishimatsu:
>> 
>> According to above works, efi_no_storage_paranoia parameter was prepared
>> for sane UEFI which can do gc and fulfills spec. But why need a system
>> with a sane UEFI set the parameter? It is wrong. A system with a broken
>> UEFI should set the parameter.
>
> And how does one know that his UEFI is broken?
> "Oh my board is briked because I wrote too much into a variable, maybe setting
> efi_storage_paranoia would have saved me. Let's try with the next board..." ;)
>
Agreed. It's hard for people to fix their briked motherboard. At least
it's hard for someone who is the first time meet this issue like me. :-(
and IMO, at least 51% of uefi firmwares on the world is buggy... ;)
However, if we simply make all buggy firmware become a brick, the
vendors will more careful in their next generation of products... But
it's painful for everyone, both customers and vendors.
> Thanks,
> //richard
> --
> To unsubscribe from this list: send the line "unsubscribe linux-efi" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Best,
Madper Xie.
