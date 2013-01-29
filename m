From: Lingzhu Xiang <lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC] efivars write(2) races
Date: Tue, 29 Jan 2013 10:30:01 +0800
Message-ID: <51073429.10503@redhat.com>
References: <20130125002552.GC4503@ZenIV.linux.org.uk>   <51020120.5000500@redhat.com>  <1359119883.2496.156.camel@mfleming-mobl1.ger.corp.intel.com>  <5105E4A3.9040102@redhat.com> <1359376730.8282.20.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1359376730.8282.20.camel-ZqTwcBeJ+wsBof6jY8KHXm7IUlhRatedral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 01/28/2013 08:38 PM, Matt Fleming wrote:
> On Mon, 2013-01-28 at 10:38 +0800, Lingzhu Xiang wrote:
>> On 01/25/2013 09:18 PM, Matt Fleming wrote:
>>>> 4. EFI_VARIABLE_APPEND_WRITE with EFI_OUT_OF_RESOURCES truncates size but you
>>>>      can still read its content.
>>>
>>> I'm not sure what you mean by this. Could you please explain?
>>
>> Oops, this one is incorrect. I was testing EFI_VARIABLE_APPEND_WRITE
>> using this:
>>
>> printf "\x47\x00\x00\x00\x00" >test-1-$guid
>>
>> So it truncates the file before writing, but efivarfs figures out the right
>> size afterwards. The size remains zero if the write fails.
>>
>> I should be using this for appending:
>>
>> printf "\x47\x00\x00\x00\x00" >>test-1-$guid
> 
> Does this mean that these two test cases work as expected?

Mostly yes.

printf "\x47\x00\x00\x00\x00" >test-1-$guid

still shows unexpected truncate behavior. But this is the same one
already noted previously (truncate doesn't actually work). 
