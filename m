From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: sysfs: cannot create duplicate filename
Date: Tue, 19 Mar 2013 15:26:47 +0000
Message-ID: <514883B7.1010602@console-pimps.org>
References: <CAHsu+b-cG+ED6TX5evRTBjR-LwHugW+8-9hnHXAz5DnAioJnUQ@mail.gmail.com>  <5135BD66.1030005@redhat.com>  <1362755479.15011.238.camel@mfleming-mobl1.ger.corp.intel.com>  <513A2B29.8090705@redhat.com>  <1363082900.15011.257.camel@mfleming-mobl1.ger.corp.intel.com>  <513F0734.80600@redhat.com>  <1363106125.15011.263.camel@mfleming-mobl1.ger.corp.intel.com>  <51405943.2000601@redhat.com>  <1363278817.15011.316.camel@mfleming-mobl1.ger.corp.intel.com>  <A5ED84D3BB3A384992CBB9C77DEDA4D41AF68807@USINDEM103.corp.hds.com> <1363618261.14988.4.camel@mfleming-mobl1.ger.corp.intel.com> <51483A88.6060509@redhat.com> <A5ED84D3BB3A384992CBB9C77DEDA4D41AF6E1F9@USINDEM103.corp.hds.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <A5ED84D3BB3A384992CBB9C77DEDA4D41AF6E1F9-ohthHghroY0jroPwUH3sq+6wyyQG6/Uh@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Seiji Aguchi <seiji.aguchi-7rDLJAbr9SE@public.gmane.org>
Cc: Lingzhu Xiang <lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andre Heider <a.heider-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 03/19/2013 02:25 PM, Seiji Aguchi wrote:
> I see, you are concerned that a set_variable service may not work correctly.
> If so,  the set_variable service should be disabled in addition to get_next_variable service.

We've no reason to believe that there are broken SetVariable()
implementations in the wild. If any ever crop up, we can deal with them
as and when.

-- 
Matt Fleming, Intel Open Source Technology Center
