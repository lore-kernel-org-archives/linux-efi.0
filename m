From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: sysfs: cannot create duplicate filename
Date: Thu, 14 Mar 2013 16:33:37 +0000
Message-ID: <1363278817.15011.316.camel@mfleming-mobl1.ger.corp.intel.com>
References: <CAHsu+b-cG+ED6TX5evRTBjR-LwHugW+8-9hnHXAz5DnAioJnUQ@mail.gmail.com>
	    <5135BD66.1030005@redhat.com>
	   <1362755479.15011.238.camel@mfleming-mobl1.ger.corp.intel.com>
	   <513A2B29.8090705@redhat.com>
	  <1363082900.15011.257.camel@mfleming-mobl1.ger.corp.intel.com>
	  <513F0734.80600@redhat.com>
	 <1363106125.15011.263.camel@mfleming-mobl1.ger.corp.intel.com>
	 <51405943.2000601@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51405943.2000601-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lingzhu Xiang <lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Andre Heider <a.heider-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Seiji Aguchi <seiji.aguchi-7rDLJAbr9SE@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, 2013-03-13 at 18:47 +0800, Lingzhu Xiang wrote:
> On 03/13/2013 12:35 AM, Matt Fleming wrote:
> >> I think using what we have is good enough for this. I'll verify
> >> boot time tomorrow.
> >
> > That would be great, thank you.
> 
> On a Windows 8 logo desktop with 91 variables, the average time (30 runs 
> each) of variable iteration goes from 0.009672 second to 0.010180 second 
> (+0.000508 second, or +5%). Negligible.

Thanks for testing that.

[...]

> >> By the way, efivar_update_sysfs_entries from Seiji's sysfs workqueue
> >> patch may also get stuck in loop in the same way.
> >
> > You mean if GetNextVariableName() never terminates? Yeah,
> > efivar_update_sysfs_entries() looks like it needs protecting from that
> > too, good catch.
> 
> Yes that's what I meant.

Hmm.. actually, I'm not at all sure how to fix that case, since the
algorithm expects to find duplicates.

Seiji, any thoughts here? For a recap of the discussion see,

	http://article.gmane.org/gmane.linux.kernel.efi/835

-- 
Matt Fleming, Intel Open Source Technology Center
