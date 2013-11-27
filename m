From: Seiji Aguchi <seiji.aguchi-7rDLJAbr9SE@public.gmane.org>
Subject: RE: [PATCH v2] efi-pstore: Make efi-pstore return a unique id
Date: Wed, 27 Nov 2013 14:51:22 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D47FA16730@USINDEM103.corp.hds.com>
References: <87bo1bnxhi.fsf@redhat.com>
 <20131127114440.GF18170@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131127114440.GF18170-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Content-Language: en-US
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Madper Xie <cxie-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "'linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org'" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "richard-/L3Ra7n9ekc@public.gmane.org" <richard-/L3Ra7n9ekc@public.gmane.org>, Tony Luck <tony.luck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org



> -----Original Message-----
> From: Matt Fleming [mailto:matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org]
> Sent: Wednesday, November 27, 2013 6:45 AM
> To: Madper Xie
> Cc: 'linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org'; linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org; Seiji Aguchi; richard-/L3Ra7n9ekc@public.gmane.org; Tony Luck
> Subject: Re: [PATCH v2] efi-pstore: Make efi-pstore return a unique id
> 
> On Sat, 23 Nov, at 07:55:37PM, Madper Xie wrote:
> >
> > Pstore fs expects that backends provide a uniqued id which could avoid
> > pstore making entries as duplication or denominating entries the same
> > name. So I combine the timestamp, part and count into id.
> >
> > Signed-off-by: Madper Xie <cxie-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > ---
> >  drivers/firmware/efi/efi-pstore.c | 19 +++++++++++++------
> >  1 file changed, 13 insertions(+), 6 deletions(-)
> 
> Thanks unless anyone complains, I'm going to apply this.
> 

I'm OK with this patch based on Madper's comment below.

<snip>
So i'd like to using fixed length. My dell xps has 128kb nvram
space. and it at most store 126 pstore entries. So I think 1000 will be
a safe value for count. For part, 100 should be okay. I don't think
there will be a large kmsg and we must split it into more than 100 parts.
<snip>

> Does this need to be tagged for stable?
> 

I think so.

Seiji

> --
> Matt Fleming, Intel Open Source Technology Center
