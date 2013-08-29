From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 05/10] asus-wmi: Restrict debugfs interface when module
 loading is restricted
Date: Thu, 29 Aug 2013 11:46:32 -0700
Message-ID: <521F9708.6040902@zytor.com>
References: <1376928619-3775-1-git-send-email-matthew.garrett@nebula.com>  <1376928619-3775-5-git-send-email-matthew.garrett@nebula.com>  <521F9162.9060405@zytor.com> <1377801331.27493.17.camel@x230>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1377801331.27493.17.camel@x230>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org" <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 08/29/2013 11:35 AM, Matthew Garrett wrote:
> On Thu, 2013-08-29 at 11:22 -0700, H. Peter Anvin wrote:
>> On 08/19/2013 09:10 AM, Matthew Garrett wrote:
>>> +	if (!capable(CAP_COMPROMISE_KERNEL))
>>> +		return -EPERM;
>>> +
>>
>> Stale bits?
> 
> Yeah. Did I manage to send out the old copy of that again? I'm sorry,
> spending a few months concentrating on cloud stuff seems to have
> entirely destroyed my ability to deal with git :(
> 

No, you mixed and matched in a single patch...

I still believe that CAP_RAWIO should be forbidden in this case.

	-hpa
