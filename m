From: Lingzhu Xiang <lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: sysfs: cannot create duplicate filename
Date: Wed, 13 Mar 2013 18:47:31 +0800
Message-ID: <51405943.2000601@redhat.com>
References: <CAHsu+b-cG+ED6TX5evRTBjR-LwHugW+8-9hnHXAz5DnAioJnUQ@mail.gmail.com>    <5135BD66.1030005@redhat.com>   <1362755479.15011.238.camel@mfleming-mobl1.ger.corp.intel.com>   <513A2B29.8090705@redhat.com>  <1363082900.15011.257.camel@mfleming-mobl1.ger.corp.intel.com>  <513F0734.80600@redhat.com> <1363106125.15011.263.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1363106125.15011.263.camel-ZqTwcBeJ+wsBof6jY8KHXm7IUlhRatedral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: Andre Heider <a.heider-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Seiji Aguchi <seiji.aguchi-7rDLJAbr9SE@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 03/13/2013 12:35 AM, Matt Fleming wrote:
>> I think using what we have is good enough for this. I'll verify
>> boot time tomorrow.
>
> That would be great, thank you.

On a Windows 8 logo desktop with 91 variables, the average time (30 runs 
each) of variable iteration goes from 0.009672 second to 0.010180 second 
(+0.000508 second, or +5%). Negligible.

>> status = EFI_NOT_FOUND here doesn't seem to do anything.
>
> It terminates the enclosing do-while loop.

Oops, my brain fart.

>> By the way, efivar_update_sysfs_entries from Seiji's sysfs workqueue
>> patch may also get stuck in loop in the same way.
>
> You mean if GetNextVariableName() never terminates? Yeah,
> efivar_update_sysfs_entries() looks like it needs protecting from that
> too, good catch.

Yes that's what I meant.


Lingzhu Xiang
