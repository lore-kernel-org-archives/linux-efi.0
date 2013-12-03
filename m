From: Yasuaki Ishimatsu <isimatu.yasuaki-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [PATCH] x86, efi: add efi_whitelist_table to use all efi variable
 storage
Date: Tue, 3 Dec 2013 14:12:20 +0900
Message-ID: <529D6834.2070408@jp.fujitsu.com>
References: <528DD3E0.3050606@jp.fujitsu.com> <1385064722.12107.1.camel@x230> <528E9EB2.3060808@jp.fujitsu.com> <1385078632.12107.3.camel@x230> <528EF87D.4050300@jp.fujitsu.com> <528EF9CE.2070305@jp.fujitsu.com> <1385142450.2884.1.camel@x230> <529D4DF5.80502@jp.fujitsu.com> <25e63f3b748741998d2b3e04bbc53064@BN1PR05MB423.namprd05.prod.outlook.com> <529D62C0.2080400@jp.fujitsu.com> <20131203050450.GA30967@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131203050450.GA30967-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "jlee-IBi9RG/b67k@public.gmane.org" <jlee-IBi9RG/b67k@public.gmane.org>, "matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org" <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, "richard-/L3Ra7n9ekc@public.gmane.org" <richard-/L3Ra7n9ekc@public.gmane.org>, "cxie-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <cxie-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

(2013/12/03 14:04), Matthew Garrett wrote:
> On Tue, Dec 03, 2013 at 01:49:04PM +0900, Yasuaki Ishimatsu wrote:
>
>> What boot service is the "boot services" in these sentences?
>
> The environment prior to ExitBootServices() being called.
>

I see.
I'll check it.

Thank,
Yasuaki Ishimatsu
