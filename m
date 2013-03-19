From: Lingzhu Xiang <lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: sysfs: cannot create duplicate filename
Date: Tue, 19 Mar 2013 18:14:32 +0800
Message-ID: <51483A88.6060509@redhat.com>
References: <CAHsu+b-cG+ED6TX5evRTBjR-LwHugW+8-9hnHXAz5DnAioJnUQ@mail.gmail.com>  <5135BD66.1030005@redhat.com>  <1362755479.15011.238.camel@mfleming-mobl1.ger.corp.intel.com>  <513A2B29.8090705@redhat.com>  <1363082900.15011.257.camel@mfleming-mobl1.ger.corp.intel.com>  <513F0734.80600@redhat.com>  <1363106125.15011.263.camel@mfleming-mobl1.ger.corp.intel.com>  <51405943.2000601@redhat.com>  <1363278817.15011.316.camel@mfleming-mobl1.ger.corp.intel.com>  <A5ED84D3BB3A384992CBB9C77DEDA4D41AF68807@USINDEM103.corp.hds.com> <1363618261.14988.4.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1363618261.14988.4.camel-ZqTwcBeJ+wsBof6jY8KHXm7IUlhRatedral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: Seiji Aguchi <seiji.aguchi-7rDLJAbr9SE@public.gmane.org>, Andre Heider <a.heider-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 03/18/2013 10:51 PM, Matt Fleming wrote:
> On Thu, 2013-03-14 at 19:31 +0000, Seiji Aguchi wrote:
>> To fix the broken firmware, users need to erase the duplicated variable.
>> Is it correct?
>
> I'm unsure whether that will fix the problem for all platforms. Lingzhu,
> do you have any idea?

I'm not very sure what is to "erase the duplicated variable". If the 
firmware is broken, the variable interfaces probably are also broken and 
can't be used to erase variable. Users need to reset nvram to a known 
clean state, but often the hardware doesn't provide such facility.

> How does everyone feel about this version? Lingzhu, if I could get a
> Tested-by for this version that would be great. This, plus some other
> patches, are sitting on the 'urgent' branch.

I will test this. The IBM x3100m4 is gone. It takes some time to figure 
out how to corrupt nvram in QEMU...
