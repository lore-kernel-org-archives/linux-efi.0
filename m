From: Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>
Subject: Re: [PATCH] x86,efi: Implement efi_no_storage_paranoia parameter
Date: Wed, 17 Apr 2013 16:56:45 +0200
Message-ID: <516EB82D.8090500@nod.at>
References: <1366153253-28572-1-git-send-email-richard@nod.at> <alpine.LRH.2.00.1304170116060.8789@twin.jikos.cz> <516E500E.3020909@nod.at> <516EB7E8.1030105@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <516EB7E8.1030105-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, cbouatmailru-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Am 17.04.2013 16:55, schrieb Matt Fleming:
> On 17/04/13 08:32, Richard Weinberger wrote:
>> Am 17.04.2013 01:16, schrieb Jiri Kosina:
>>> On Wed, 17 Apr 2013, Richard Weinberger wrote:
>>>> +static bool efi_no_storage_paranoia;
>>>> +EXPORT_SYMBOL_GPL(efi_no_storage_paranoia);
>>>
>>> Is there any particular reason to export this symbol?
>>
>> I saw that the other parameters in that file are exported too
>> and other (efi) drivers may also be interested in that symbol.
>> So I thought it is a good idea to export it too.
>
> I've applied this patch but I did drop the EXPORT_SYMBOL_GPL() line. If
> people want access to this symbol at some future date we can address
> that later.

Okay. I'm fine with this!

Thanks,
//richard
