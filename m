From: Lingzhu Xiang <lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: sysfs: cannot create duplicate filename
Date: Wed, 20 Mar 2013 00:00:00 +0800
Message-ID: <51488B80.6000105@redhat.com>
References: <CAHsu+b-cG+ED6TX5evRTBjR-LwHugW+8-9hnHXAz5DnAioJnUQ@mail.gmail.com>  <5135BD66.1030005@redhat.com>  <1362755479.15011.238.camel@mfleming-mobl1.ger.corp.intel.com>  <513A2B29.8090705@redhat.com>  <1363082900.15011.257.camel@mfleming-mobl1.ger.corp.intel.com>  <513F0734.80600@redhat.com>  <1363106125.15011.263.camel@mfleming-mobl1.ger.corp.intel.com>  <51405943.2000601@redhat.com>  <1363278817.15011.316.camel@mfleming-mobl1.ger.corp.intel.com>  <A5ED84D3BB3A384992CBB9C77DEDA4D41AF68807@USINDEM103.corp.hds.com> <1363618261.14988.4.camel@mfleming-mobl1.ger.corp.intel.com> <51483A88.6060509@redhat.com> <A5ED84D3BB3A384992CBB9C77DEDA4D41AF6E1F9@USINDEM103.corp.hds.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <A5ED84D3BB3A384992CBB9C77DEDA4D41AF6E1F9-ohthHghroY0jroPwUH3sq+6wyyQG6/Uh@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Seiji Aguchi <seiji.aguchi-7rDLJAbr9SE@public.gmane.org>
Cc: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Andre Heider <a.heider-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 03/19/2013 10:25 PM, Seiji Aguchi wrote:
>> If the firmware is broken, the variable interfaces probably are also broken
>> and can't be used to erase variable. 
> 
> I see, you are concerned that a set_variable service may not work correctly.
> If so,  the set_variable service should be disabled in addition to get_next_variable service.

Since you're suggesting fixing firmware by erasing, I'm wondering
SetVariable may not actually remove duplicate variables since the way
they exist is already an undefined behavior. And some variables can't
be removed.

GetNextVariable is clearly causing harm in this case. But the rest of efi
runtime services should be left as they are.


Lingzhu Xiang
