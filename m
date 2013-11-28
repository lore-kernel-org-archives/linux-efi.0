From: Madper Xie <cxie-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] efi-pstore: Make efi-pstore return a unique id
Date: Thu, 28 Nov 2013 10:15:18 +0800
Message-ID: <87vbzdb7bd.fsf@redhat.com>
References: <87bo1bnxhi.fsf@redhat.com> <20131127114440.GF18170@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <20131127114440.GF18170-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: Madper Xie <cxie-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "'linux-kernel@vger.kernel.org'" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi@vger.kernel.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "matt.fleming@intel.com" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Seiji Aguchi <seiji.aguchi-7rDLJAbr9SE@public.gmane.org>, "richard@nod.at" <richard-/L3Ra7n9ekc@public.gmane.org>, Tony Luck <tony.luck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org


matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org writes:

> On Sat, 23 Nov, at 07:55:37PM, Madper Xie wrote:
>> 
>> Pstore fs expects that backends provide a uniqued id which could avoid
>> pstore making entries as duplication or denominating entries the same
>> name. So I combine the timestamp, part and count into id.
>> 
>> Signed-off-by: Madper Xie <cxie-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> ---
>>  drivers/firmware/efi/efi-pstore.c | 19 +++++++++++++------
>>  1 file changed, 13 insertions(+), 6 deletions(-)
>
> Thanks unless anyone complains, I'm going to apply this.
>
> Does this need to be tagged for stable?
Since it fix a real issue, my answer is "Yes".
